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
  ps(ii, :)  = lsqcurvefit(@hill2, [p(1,end), p(2,end)], S, ys, [0 0], [4, 4]);
end

%% 2.4

tbl = table(cell(2,1), NaN(2,1), NaN(2,1), NaN(2, 1));
tbl.Properties.VariableNames = {'BootstrapStatistic', 'mean', 'stdev', 'ci90pm'};
tbl.BootstrapStatistic = {'Hill coefficient', 'dissociation constant'}';
tbl.mean    = mean(ps)';
tbl.stdev   = std(ps)';
tbl.ci90pm  = 1.645*tbl.stdev / sqrt(100);

disp(tbl)

%% 2.5

for ii = 1:2
  figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
  histogram(ps(:, ii))
  title([num2str(ii-1) '-order parameter'])
  temp = tbl.mean(ii) + tbl.ci90pm(ii);
  line([temp, temp], [0 20], 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
  temp = tbl.mean(ii) - tbl.ci90pm(ii);
  line([temp, temp], [0 20], 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
  xlabel('parameter value')
  ylabel('# occurring')

  if being_published
    snapnow
    delete(gcf)
  end
end

%% 2.6
figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(S, rate, 'o')
for ii = 1:100
  plot(S, hill2(ps(ii,:), S), 'LineWidth', 1, 'Color', [0 0 0 0.2]);
end
plot(S, yfit, 'k');
plot(S, hill2(p(1,end)-flip(tbl.ci90pm)', S), '--r');
plot(S, hill2(p(2,end)+flip(tbl.ci90pm)', S), '--r');
xlabel('substrate concentration (nM) ')
ylabel('enzyme rate (rxn/sec)')
title('Bootstrapped data with Hill function fit and CI')

%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
