%% Take-Home Final
% Alec Hoyland
% 14:07 2018-10-24

pHeader;
tic

%% Native Transition Probability Matrix

% define the native transition probability matrix, H
H = zeros(15,15);
H(1,:) 		= [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0];
H(2,:) 		= [0 1 1 0 0 0 1 0 1 1 1 0 0 0 0];
H(3,:) 		= [0 0 0 0 0 0 0 0 0 1 1 1 0 0 0];
H(4,:) 		= [0 0 0 1 0 0 1 0 0 0 1 0 0 0 0];
H(5,:) 		= [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0];
H(6,:) 		= [0 0 0 0 0 1 1 0 0 0 1 1 1 0 0];
H(7,:) 		= [0 0 0 0 0 0 1 0 0 0 1 1 0 1 1];
H(8,:) 		= [0 0 0 0 0 0 0 0 1 1 0 0 0 0 0];
H(9,:) 		= [0 0 0 0 0 0 1 0 1 0 0 0 0 0 0];
H(10,:) 	= [0 0 0 0 0 0 0 1 1 1 0 0 0 0 0];
H(11,:) 	= [0 0 0 0 0 0 0 0 0 1 1 1 1 0 0];
H(12,:)  	= [0 0 0 0 0 0 0 0 0 0 1 1 1 0 1];
H(13,:) 	= [0 0 0 0 0 0 1 0 0 0 1 1 1 0 0];
H(14,:) 	= [0 0 0 0 0 0 1 0 0 1 1 1 1 1 0];
H(15,:) 	= [0 0 0 0 0 0 0 0 0 0 1 1 1 0 0];

% exits are columns
H 				= H';

% normalize the columns
H 				= H ./ sum(H);

disp('The native transition probability matrix:')
disp(H)

%% The Google Matrix
alpha 		= 0.8;
N 				= 15;
G 				= alpha * H + (1 - alpha)/N * ones(N);

disp('The Google Matrix is:')
disp(G)

%% Shifted Inverse Power Iteration

[gamma, x] = shifted_inverse_power(G, x, true);

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
