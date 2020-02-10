function W = get_identity_structure(H_ish)
    triuH_ish = triu(H_ish);
    value = unique(triuH_ish);
    veclen = size(H_ish,1)*size(H_ish,1);
    W = sparse(0, veclen);
    for i = 1:size(value, 1)
        if all(value(i) == 0)
            continue
        end
        comps = find(triuH_ish==value(i));
        for j = 2:size(comps, 1)
            newline = sparse([1 1], [comps(1), comps(j)], [1 -1], 1, veclen);
            W = [W; newline];
        end
    end
    if size(W,1) == 0 
        W = 0;
    end
end