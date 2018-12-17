%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load the data
[S, rate]    = textread('data_problem1.txt', '%f%f', 'headerlines', 1);

%% 1. Using Levenberg-Marquardt

%% 1.1 Plot the nonlinear contour terrain

x         = 0:0.1:4;
y         = 0:0.1:4;
[X, Y]    = meshgrid(x, y);
R         = NaN(length(x), length(y));

for ii = 1:length(x)
  for qq = 1:length(y)
    R(ii, qq) = norm(y - hill(S, x(ii), y(qq)));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, R', 10)
xlabel('n')
ylabel('K_m')
title('Nonlinear least-squares landscape')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end




%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
