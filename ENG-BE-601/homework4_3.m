%% Homework #4, Problem 3
% Alec Hoyland
% 11:24 2018-10-2

addpath('haar')

pHeader;
tic

%% Load the Photo
% Meghan, Duchess of Sussex

% % load the .tif file
% A = imread('Meghan_Markle_BW.tif', 'tiff');
% % convert to single-precision floating point numbers
% A = single(A);
% % flip black and white (white == 0)
% A = abs(A - 255) - 127.5;

% load the test file
A = imread('squiggle.tif', 'tiff');
A = single(A);
A = abs(A - 255);

% column rastering
B = haar(16, 'half');

disp('The normalized Haar matrix is:')
disp(B)


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
