%% Homework #4
% Problem 2
% Alec Hoyland
% 2018-12-6 13:23

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem2.txt', '%f%f', 'headerlines', 1);

r     = sqrt(x1.^2 + x2.^2);
p     = 1:14;

for ii = 1:14

  b = mldivide(r'*r, )


%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
