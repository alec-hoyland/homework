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

% store the sum-of-squares for the data
SS        = NaN(2,4);

%% Fourier series approximations
% The Fourier series approximation has terms $\beta_n \sin(\frac{n\pi}{L}t)$.
% We want to use a minimum of terms with a mimimum of accuracy, defined by Pearson's
% $R^2$ contribution from the last term be just over 1 percent, where
% $R^2 = 1 - \frac{SS_{residual}}{SS_{total}}$.

% first-order odd Fourier
f     = [ones(length(t),1), sin(pi/L*t)];
c     = inv(f'*f)*f'*y;
yfit  = c(1) + c(2)*f(:,2);
SS_residual   = norm(y - yfit);
SS_regression = norm(yfit - mean(y));
SS(1,1)       = SS_residual;
SS(2,1)       = SS_regression;
r1    = 1 - SS_residual / (SS_residual + SS_regression);

% second-order odd Fourier
f     = [ones(length(t), 1), sin(pi/L*t), sin(2*pi/L*t)];
c     = inv(f'*f)*f'*y;
yfit  = c(1) + c(2)*f(:,2) + c(3)*f(:,3);
SS_residual   = norm(y - yfit);
SS_regression = norm(yfit - mean(y));
SS(1,2)       = SS_residual;
SS(2,2)       = SS_regression;
r2    = 1 - SS_residual / (SS_residual + SS_regression);

% third-order odd Fourier
f     = [ones(length(t), 1), sin(pi/L*t), sin(2*pi/L*t), sin(3*pi/L*t)];
c     = inv(f'*f)*f'*y;
yfit  = c(1) + c(2)*f(:,2) + c(3)*f(:,3) + c(4)*f(:,4);
SS_residual   = norm(y - yfit);
SS_regression = norm(yfit - mean(y));
SS(1,3)       = SS_residual;
SS(2,3)       = SS_regression;
r3    = 1 - SS_residual / (SS_residual + SS_regression);

% fourth-order odd Fourier
f     = [ones(length(t), 1), sin(pi/L*t), sin(2*pi/L*t), sin(3*pi/L*t) sin(4*pi/L*t)];
c     = inv(f'*f)*f'*y;
yfit  = c(1) + c(2)*f(:,2) + c(3)*f(:,3) + c(4)*f(:,4) + c(5)*f(:,5);
SS_residual   = norm(y - yfit);
SS_regression = norm(yfit - mean(y));
SS(1,4)       = SS_residual;
SS(2,4)       = SS_regression;
r4    = 1 - SS_residual / (SS_residual + SS_regression);

%%
% The third order odd Fourier coefficients produce the best fit for
% a percent difference in residual of greater than but as close to
% 1 percent. A fourth order fit has too many terms and a second
% order fit has too few. Technically speaking, the second-order fit meets the
% criteria with a percent difference of 0.054 percent, but the third-order fit
% increases the $R^2$ measure by over 19 percent.
R     = [r1 r2 r3 r4];

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
cat   = categorical({'first-order', 'second-order', 'third-order'});
xlabel('order of odd Fourier series fit')
ylabel('sum of squares')
bar(cat, SS(:,1:3)', 'stacked')
legend({'residual sum-of-squares error', 'regression sum-of-squares error', }, 'Location', 'northeast')
title('sum-of-squares error by odd Fourier series order fit')

figlib.pretty()

if being_published
  snapnow
  delete(gcf);
end

%%

% third-order odd Fourier (redo)
f     = [ones(length(t), 1), sin(pi/L*t), sin(2*pi/L*t), sin(3*pi/L*t)];
c     = inv(f'*f)*f'*y;
yfit  = c(1) + c(2)*f(:,2) + c(3)*f(:,3) + c(4)*f(:,4);

varNames = {'Factor X1', 'Factor X3', 'Factor X5', 'Error', 'Regression Combo', 'Total', 'R2 Value'};
tbl      = table(varNames', NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1),NaN(7,1));
tbl.Properties.VariableNames = {'Factor', 'DoF', 'SumSq', 'SequentialSS', 'AdjustedSS', 'Variance', 'F', 'FCritical'};

% degrees of freedom
tbl.DoF(6)    = length(t)-1;
tbl.DoF(1:3)  = 3-1;
tbl.DoF(5)    = sum(tbl.DoF(1:3));
tbl.DoF(4)    = tbl.DoF(6) - tbl.DoF(5);

% sum-of-squares error
tbl.SumSq(1:3)= SS(1,2:4);
tbl.SumSq(4)  = SS(2,4);
tbl.SumSq(5)  = sum(tbl.SumSq(1:3));
tbl.SumSq(6)  = sum(tbl.SumSq(1:4));
tbl.SumSq(7)  = r4;

% sequential sum of squares
tbl.SequentialSS(1) = norm(y - (c(1) + c(2)*f(:,2) + c(3)*f(:,3) + c(4)*f(:,4)));
tbl.SequentialSS(2) = norm(y - (c(1) + c(2)*f(:,2) + c(3)*f(:,3)));
tbl.SequentialSS(3) = norm(y - (c(1) + c(4)*f(:,4)));
tbl.SequentialSS(4) = SS(2,4);
tbl.SequentialSS(5) = sum(tbl.SequentialSS(1:3));
tbl.SequentialSS(6) = sum(tbl.SequentialSS(1:4));

% adjusted SS
tbl.AdjustedSS(1)   = norm(y - (c(1) + c(2)*f(:,2)));
tbl.AdjustedSS(2)   = norm(y - (c(1) + c(3)*f(:,3)));
tbl.AdjustedSS(3)   = norm(y - (c(1) + c(4)*f(:,4)));
tbl.AdjustedSS(4)   = SS(2,4);

% variance
tbl.Variance        = tbl.AdjustedSS / (length(t)-1);

% F-test
tbl.F(1:3)          = tbl.AdjustedSS(1:3) / tbl.AdjustedSS(4);

% Fcritical
tbl.FCritical(1:3)  = 3.019;

disp('ANOVA table')
disp(tbl)
disp('coefficients')
disp(c)
disp('R2 value')
disp(r3)

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'o')
plot(t, yfit);
xlabel('t')
ylabel('y')

figlib.pretty()

if being_published
  snapnow
  delete(gcf)
end

%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
