function [n, r] = dims(x)
% returns dimensions of the input matrix
% -------------------------------------------------------------------------
% x is a matrix (n times r)
dim = size(x);
n = dim(1);
r = dim(2);
assert(n >= r, 'n must be not less then r')
end