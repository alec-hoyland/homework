%% Homework #3
% Problem 1
% Alec Hoyland
% 2018-11-20 14:09

pHeader;
tic

%% Load the data

[t, y] 		= textread('problem1_data.txt', ' %f%f ', 'headerlines', 1);

%% 1.1 Residual contour terrain
% $\alpha$ must be negative, or the function will blow up as $t \rightarrow \infty$.

stepA 		= -2:0.01:-0.2;
stepO 		= 0:0.01:2;
[X, Y] 		= meshgrid(stepA, stepO);

residual 	= NaN;
res_norm 	= NaN(length(stepA), length(stepO));
for ii = 1:length(stepA)
	for qq = 1:length(stepO)
		residual					= y - alpha_sine(t, stepA(ii), stepO(qq));
		res_norm(ii, qq) 	= sum(residual.^2);
	end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
xlabel('\alpha')
ylabel('\omega')
title('norm-squared residual of alpha-sinusoid fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 1.2 Levenberg-Marquardt

x 					= LevenbergMarquardt(t, y, @alpha_sine, 0.1, [5, 50], [1, 1]);

%% 1.3 Overlay of solutions onto MSE topography

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
plot(x(1,:), x(2,:), 'k-o', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
xlabel('\alpha')
ylabel('\omega')
title('Levenberg-Marquardt algorithm progress with MSE topography')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 1.4 Least-squares fit over data

yhat 		= alpha_sine(t, x(1,end), x(2,end));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or');
plot(t, yhat, 'k-')
legend({'data', 'fit'})
xlabel('t')
ylabel('y')
title('raw data with least-squares fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.1

%%

x 					= LevenbergMarquardt(t, y, @alpha_sine, 1, [5, 50], [-0.4, 0.5], 15);

%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
plot(x(1,:), x(2,:), 'k-o', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
xlabel('\alpha')
ylabel('\omega')
title('Levenberg-Marquardt algorithm progress with MSE topography')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%%

yhat 		= alpha_sine(t, x(1,end), x(2,end));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or');
plot(t, yhat, 'k-')
legend({'data', 'fit'})
xlabel('t')
ylabel('y')
title('raw data with least-squares fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.2

%%

x 					= LevenbergMarquardt(t, y, @alpha_sine, 100, [5, 50], [-0.4, 0.5], 15);

%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
plot(x(1,:), x(2,:), 'k-o', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
xlabel('\alpha')
ylabel('\omega')
title('Levenberg-Marquardt algorithm progress with MSE topography')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%%

yhat 		= alpha_sine(t, x(1,end), x(2,end));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or');
plot(t, yhat, 'k-')
legend({'data', 'fit'})
xlabel('t')
ylabel('y')
title('raw data with least-squares fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.3

%%

x 					= LevenbergMarquardt(t, y, @alpha_sine, 1e5, [5, 50], [-0.4, 0.5], 15);

%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
plot(x(1,:), x(2,:), 'k-o', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
xlabel('\alpha')
ylabel('\omega')
title('Levenberg-Marquardt algorithm progress with MSE topography')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%%

yhat 		= alpha_sine(t, x(1,end), x(2,end));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or');
plot(t, yhat, 'k-')
legend({'data', 'fit'})
xlabel('t')
ylabel('y')
title('raw data with least-squares fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.4

%%

x 					= LevenbergMarquardt(t, y, @alpha_sine, 1e5, [5, 5], [-0.4, 0.5], 15);

%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
contour(X, Y, res_norm', 20)
plot(x(1,:), x(2,:), 'k-o', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
xlabel('\alpha')
ylabel('\omega')
title('Levenberg-Marquardt algorithm progress with MSE topography')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%%

yhat 		= alpha_sine(t, x(1,end), x(2,end));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or');
plot(t, yhat, 'k-')
legend({'data', 'fit'})
xlabel('t')
ylabel('y')
title('raw data with least-squares fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end


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
