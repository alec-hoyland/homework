%% Proof that this algorithm actually works
% Alec Hoyland
% 14:13 2018-10-19

pHeader;
tic

% define a simple matrix
A = [1, 0; 1, 0];
disp('A simple matrix:')
disp(A)

disp('with eigenvalues:')
disp(eig(A))

% define two arbitrary test vectors
v1 = [0.1, 0.9]';
v2 = [0.9, 0.1]';

disp('for test vector v1:')
disp(v1)
gamma = shifted_inverse_power(A, v1, true)

disp('for test vector v2:')
disp(v2)
gamma = shifted_inverse_power(A, v2, true)

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
