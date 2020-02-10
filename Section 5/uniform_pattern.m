function A = uniform_pattern(size, sparsity, n_values)
% uniform_pattern creates a synthetic matrix A odf size 'size' that has 
% sparsity on average 'sparrsity' and 'n_values' diffenet values across
% non-zero entries (values are 1..n_values)

% size is a list of variables
% 0 <= sparsity < 1
% n_value - natural number

% Example: uniform_pattern([4,2], 0.5, 3)

random_matrix = rand(size);
normalized_matrix = (random_matrix - sparsity)/(1-sparsity)*n_values;
sparsified_matrix = normalized_matrix .* (normalized_matrix > 0);
A = ceil(sparsified_matrix);
end

