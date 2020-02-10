function X = X(x)
% operator bold X defined in the appendix of the paper
% -------------------------------------------------------------------------
% x is a matrix (n times r)
    [n, r] = size(x);
    is = double.empty(2*r*n*n,0);
    js = double.empty(2*r*n*n,0);
    vs = double.empty(2*r*n*n,0);
    l = 1;
%     Index over the rows of the matrix X:
    for k = 1:n*n
        [I,J] = ind2sub([n,n],k);
        for s = 1:r
            is(l) = k;
            js(l) = sub2ind(size(x),J(1),s);
            vs(l) = x(I(1),s);
            l = l + 1;
%             ---------
            is(l) = k;
            js(l) = sub2ind(size(x),I(1),s);
            vs(l) = x(J(1),s);
            l = l + 1;
        end
    end
    X = sparse(is,js,vs,n*n,n*r);
end