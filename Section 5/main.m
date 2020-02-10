addpath('../util/');

% !!!README!!! To run the scriprs, uncomment the needed parameters in the SETUP section 

% -------------------SETUP----------------------

% ---------Synthetic----------

% % (uncomment all below)
% m = 20;
% n = 5 ;
% n_trials = 20;
% n_valuess = [2, 3, 4, 5, 6, 7, 8, 9, 10];

% % (choose one to uncomment below)
% sparsity = 0.85;
% sparsity = 0.875;
% sparsity = 0.90;
% sparsity = 0.925;
% sparsity = 0.95;


% ---------Power system----------

% n_trials = 500;

% % (uncomment one section below)

% % Usual 9:
% m=63;
% n=9;
% sparsity=0.961;
% n_valuess=[61,];

% % Usual 14:
% m=98;
% n=14;
% sparsity=0.981;
% n_valuess=[128,];



% -------------------JOB----------------------

results = cell(length(n_valuess),1);

for i = 1 : length(n_valuess)
    results{i} = run_trials(m, n, sparsity, n_valuess(i), n_trials);
end    
    

%%
function result = run_trials(m, n, sparsity, n_values, n_trials)
    result = cell(n_trials,1);
    for i = 1:n_trials
        try
            [S, W, result{i}] = BO_synthetic(m, n, sparsity, n_values);
            close all
        catch ME
        end
    close all
    end
end


