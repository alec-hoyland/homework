%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem3.txt', '%f%f%f', 'headerlines', 1);

%% Solve using Levenberg-Marquardt
options         = LMFsolve('default');
options.Display = 1;
[pf, ssq, cnt]  = LMFsolve(@(p) norm(y - logistic(p, x1, x2)), [1 1 1], options)

%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
