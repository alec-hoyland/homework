%% Homework #5
% Problem 1
% Alec Hoyland
% 2018-12-10 12:36

pHeader;
tic

%% Load data
[x, y]  = textread('data_problem1.txt', '%f%f', 'headerlines', 1);

% preprocess data
[x, I]  = sort(x);
y       = y(I);

%% Find the Least-Squares Coefficients
% for a third-order polynomial fit

beta    = polyfit(x, y, 3);

disp('polynomial coefficients (ascending order):')
disp(flip(beta))

%% Raw data and polynomial fit

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x, y, 'o');
plot(x, polyval(beta, x), '-k');
xlabel('x')
ylabel('y')
legend({'raw data', 'LS 3rd-order fit'}, 'Location', 'northwest')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% Bootstrap residual vector

yfit  = polyval(beta, x);
r     = yfit - y;
bs    = unidrnd(80, 80, 100);


betas = NaN(100, 4);

for ii = 1:100
  % construct a bootstrapped data set
  ys    = yfit - r(bs(:,ii));
  % compute a polynomial fit
  betas(ii, :) = flip(polyfit(x, ys, 3));
end

tbl = table(cell(4,1), NaN(4,1), NaN(4,1), NaN(4,1));
tbl.Properties.VariableNames = {'Coefficient', 'mean', 'stdev', 'ci90pm'};
tbl.Coefficient = {'intercept', 'linear', 'quadratic', 'cubic'}';
tbl.mean    = mean(betas)';
tbl.stdev   = std(betas)';
tbl.ci90pm  = 1.645*tbl.stdev/sqrt(80);

disp(tbl)

%% Histograms

% figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
% histogram(betas(:, ii))
% title([num2str(ii-1) '-order parameter'])
% temp = tbl.mean(ii) + tbl.ci90pm(ii);
% line([temp, temp], [0 20], 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
% temp = tbl.mean(ii) - tbl.ci90pm(ii);
% line([temp, temp], [0 20], 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
% xlabel('parameter value')
% ylabel('# occurring')
%
% prettyFig()
%
% if being_published
%   snapnow
%   delete(gcf)
% end

%%
% <</home/ahoyland/code/homework/ENG-BE-604/homework5/1.png>>

%%
% <</home/ahoyland/code/homework/ENG-BE-604/homework5/2.png>>

%%
% <</home/ahoyland/code/homework/ENG-BE-604/homework5/3.png>>

%%
% <</home/ahoyland/code/homework/ENG-BE-604/homework5/4.png>>


%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x, y, 'o')
for ii = 1:100
  plot(x, polyval(flip(betas(ii,:)), x), 'LineWidth', 1, 'Color', [0 0 0 0.2]);
end
plot(x, yfit, 'k');
plot(x, polyval(beta-flip(tbl.ci90pm)', x), '--r');
plot(x, polyval(beta+flip(tbl.ci90pm)', x), '--r');
xlabel('x')
ylabel('y')

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
