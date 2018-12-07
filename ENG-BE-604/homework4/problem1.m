%% Homework #4
% Problem 1
% Alec Hoyland
% 2018-12-6 13:23

pHeader;
tic

%% Load the data

[t, y] 		= textread('data_problem1.txt', ' %f%f ', 'headerlines', 1);

disp('The half-period parameter is L=4')
L = 4;

% first-order odd Fourier
f     = [sin(pi/L*t)];
c     = mldivide(y, f);
yfit  = c(1)*f(:,1);
r1    = norm(y-yfit);

% second-order odd Fourier
f     = [sin(pi/L*t), sin(2*pi/L*t)];
c     = mldivide(y, f);
yfit  = c(1)*f(:,1) + c(2)*f(:,2);
r2    = norm(y-yfit);

% third-order odd Fourier
f     = [sin(pi/L*t), sin(2*pi/L*t), sin(3*pi/L*t)];
c     = mldivide(y, f);
yfit  = c(1)*f(:,1) + c(2)*f(:,2) + c(3)*f(:,3);
r3    = norm(y-yfit);

% fourth-order odd Fourier
f     = [sin(pi/L*t), sin(2*pi/L*t), sin(3*pi/L*t) sin(4*pi/L*t)];
c     = mldivide(y, f);
yfit  = c(1)*f(:,1) + c(2)*f(:,2) + c(3)*f(:,3) + c(4)*f(:,4);
r4    = norm(y-yfit);

%%
% The third order odd Fourier coefficients produce the best fit for
% a percent difference in residual of greater than but as close to
% 1 percent. A fourth order fit has too many terms and a second
% order fit has too few.

R     = [r1 r2 r3 r4];

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
cat   = categorical({'first-order', 'second-order', 'third-order'});
xlabel('order of odd Fourier series fit')
ylabel('sum of squares residual')
bar(R)

%%

varNames = {'Factor X1', 'Factor X3', 'Factor X5', 'Error', 'Regression Combo', 'Total', 'R2 Value'};
t = table(varNames', NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1));
t.Properties.VariableNames = {'Factor', 'DoF', 'SumSq', 'SequentialSS', 'AdjustedSS', 'Variance', 'F', 'FCritical'};

t{1:3,3} = [r1 r2 r3]';


%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
