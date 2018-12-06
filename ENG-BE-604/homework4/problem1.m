%% Homework #4
% Problem 1
% Alec Hoyland
% 2018-12-6 13:23

pHeader;
tic

%% Load the data

[t, y] 		= textread('problem1_data.txt', ' %f%f ', 'headerlines', 1);




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

time = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
