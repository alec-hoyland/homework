%% Homework #6
% Alec Hoyland
% 15:42 2018-10-15

pHeader;
tic

%% Problem #1 Part A

%% Loading Data
% Load the dataset for the lengths (inches) and weights (ounces) of rock bass
% caught at Moosehead Lake in Maine.

[fish_ID, fish_length, fish_weight] = textread('homework6_data_problem1.txt', '%f%f%f', 'headerlines', 1);

disp('Number of fish:')
disp(length(fish_ID))
disp('The mean of the fish length is:')
disp(mean(fish_length))
disp('The mean of the fish weight is:')
disp(mean(fish_weight))

%% Preliminary Statistics
% Visualize the fish data.

%%
% <</home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_1.png>>

% construct the deviation matrix
D         = zeros(length(fish_weight), 2);
D(:,1)    = fish_length - mean(fish_length);
D(:,2)    = fish_weight - mean(fish_weight);

disp('The deviation matrix:')
disp(D)

% construct the sample covariance matrix
S         = 1 / (length(D) - 1) * D' * D;

disp('The covariance matrix:')
disp(S)

% construct the Pearson's correlation coefficient matrix
r         = zeros(2);
for ii = 1:2
  for qq = 1:2
    r(ii,qq) = S(ii,qq) / ( sqrt(S(ii,ii)) * sqrt(S(qq,qq)) );
  end
end

disp('The Pearson''s correlation matrix:')
disp(r)

%% Problem #1 Part B

% compute the eigenvalues
[V, lambda] = eig(S)

%%
% <</home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_2.png>>

disp('The inverse covariance matrix:')
disp(inv(S))

%% Problem #1 Part C

% compute statistical distance using the L-2 norm
my_distances = zeros(100,1);
for ii = 1:length(fish_weight)
	d			= zeros(2,1);
	d(1) 	= fish_length(ii) - mean(fish_length);
	d(2) 	= fish_weight(ii) - mean(fish_weight);
	my_distances(ii) = d' * inv(S) * d;
end
disp('The statistical distances:')
disp(my_distances)

%%
% <</home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_3.png>>

disp('I have picked 0.95 for the alpha value');
disp('From the chi-square table, c_squared is = 5.99')
c2 = 5.99;

%%
% <</home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_4.png>>

%% Problem #1 Part D

index = find(my_distances > c2)
disp('Fish IDs with high statistical differences')
fish_ID(index)

%%
% <</home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_5.png>>


%% Problem 2
% Use the refined shifted inverse power method to estimate the four eigenvalues
% and eigenvectors of matrix A.

A 					= [2, -3, 1, 3; 1, 4, -3, -3; 5, 3, -1, -1; 3, -6, -3, 1];
disp('The matrix A is:')
disp(A)

% set up a guess vector
xGuess(:,1) = [-1, 0, 0, 0];
xGuess(:,2) = [0, 1+i, 0, 0];
xGuess(:,3) = [0, 0, 1-i, 0];
xGuess(:,4)	= [0, 0, 0, 1];

disp('Four guess vectors (each column is a vector)')
disp(xGuess)

% perform iteration
gamma = complex(zeros(4,1));

%% Eigenvector #1
gamma(1) 		= shifted_inverse_power(A, xGuess(:,1), true);

%% Eigenvector #2
gamma(2) 		= shifted_inverse_power(A, xGuess(:,2), true);

%% Eigenvector #3
gamma(3) 		= shifted_inverse_power(A, xGuess(:,3), true);

%% Eigenvector #4
gamma(4) 		= shifted_inverse_power(A, xGuess(:,4), true);

disp('The final estimates for the eigenvectors are:')
disp(gamma)

%% Version Info
% The file that generated this document is called:
disp(mfilename)


%%
% and its md5 hash is:
Opt.Input = 'file';
disp(dataHash(strcat(mfilename,'.m'),Opt))


%%
% This file should be in this commit:
[status,m]=unix('git rev-parse HEAD');
if ~status
	disp(m)
end

t = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
