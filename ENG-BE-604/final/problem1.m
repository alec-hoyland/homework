%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load the data
[S, rate]    = textread('data_problem1.txt', '%f%f', 'headerlines', 1);

%% 1. Using Levenberg-Marquardt

%% 1.1 Plot the nonlinear contour terrain

x         = 2:0.1:4;
y         = 2:0.1:4;
[X, Y]    = meshgrid(x, y);
R         = NaN(length(x), length(y));

for ii = 1:length(x)
  for qq = 1:length(y)
    R(ii, qq) = norm(y - hill(S, x(ii), y(qq)));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, R', 20)
xlabel('n')
ylabel('K_m')
title('Nonlinear least-squares landscape')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 1.2 Levenberg-Marquardt

initial = [3, 2.5];
mu      = 1;
mu_scale= [5, 50];

p       = LevenbergMarquardt(S, rate, @hill, mu, mu_scale, initial, 100);
% options   = optimoptions('lsqcurvefit', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter', 'InitDamping', 500);
% [p, resnorm, exitflag, output, lambda, jacobian] = lsqcurvefit(@hill2, [1, 0.1], S, rate, [], [], options);

%% 1.3
% The fit is pretty good, so the points all appear on top of each other.

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, R', 20)
plot(p(1,:), p(2,:), '-ok', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
xlabel('n')
ylabel('K_m')
title('Nonlinear least-squares landscape w/ LM')

% prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 1.4
figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(S, rate, 'o')
plot(S, hill(S, p(1), p(2)), '-k');
xlabel('substrate concentration (nM) ')
ylabel('enzyme rate (rxn/sec)')
title('Data with Hill function fit')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 2. Use bootstrapping to assess uncertainties
yfit  = hill(S, p(1), p(2));
r     = yfit - y;
bs    = unidrnd(20, 20, 100);
ps    = NaN(100, 2);

for ii = 1:100
  % construct a bootstrapped data set
  ys  = yfit - r(bs(:, ii));
  % compute the Hill fit
  ps(ii, :)  = lsqcurvefit(@hill2, [3, 2.5], S, ys);
end

%% 2.4

tbl = table(cell(2,1), NaN(2,1), NaN(2,1), NaN(2, 1));
tbl.Properties.VariableNames = {'BootstrapStatistic', 'mean', 'stdev', 'ci90pm'};
tbl.mean    = mean(ps)';
tbl.stdev   = std(ps)';
tbl.ci90pm  = 1.645*tbl.stdev / sqrt(100);


%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
