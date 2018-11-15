%% Homework #2
% Problem 1
% Alec Hoyland
% 2018-11-15 12:18

pHeader;
tic

%%

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
