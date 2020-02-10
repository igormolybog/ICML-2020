function [S,W] = get_structure(H_ish)
S = ones(size(H_ish)) - spones(H_ish);
W = get_identity_structure(H_ish);
end