%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem3b.txt', '%f%f%f', 'headerlines', 1);

%% 1. Solve using Levenberg-Marquardt
options         = LMFsolve('default');
options.Display = 1;

% estimate initial conditions from the data
initial         = [73, -14, -10, 1, 0, 1];

% perform parameter estimation
% betas           = LMFsolve(@(p) norm(y - logistic_2factor(p, x1, x2)), initial, options);
% betas             = LevenbergMarquardt2D([x1 x2], y, @logistic_2factor, 500, [5, 50], [0 0 0 0 0 0], 100);
options           = optimoptions('lsqcurvefit', ...
                    'SpecifyObjectiveGradient', true, ...
                    'Algorithm', 'levenberg-marquardt', ...
                    'Display', 'iter');
betas             = lsqcurvefit(@logistic_2factor, initial, [x1 x2], y, [], [], options);
% betas             = betas(end, :);

% 2. Plot the data in 3-D space

figure;
plot3(x1(logical(y)), x2(logical(y)), y(logical(y)), 'r+');
hold on;
plot3(x1(~logical(y)), x2(~logical(y)), y(~logical(y)), 'ko');
xgrid = 0:0.1:10;
ygrid = 0:0.1:10;
[X,Y] = meshgrid(xgrid, ygrid);
Z = NaN(length(xgrid), length(ygrid));
for ii = 1:length(xgrid)
  for qq = 1:length(ygrid)
    [Z(ii, qq)] = logistic_2factor(betas, [xgrid(ii), ygrid(qq)]);
  end
end
surf(X, Y, Z', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
xlabel('factor 1')
ylabel('factor 2')
zlabel('cured?')
title('logistic regression of zombie cure factors')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 3. Plot the data in 2-D space
xplot = linspace(0, 11, 111);
yplot = linspace(0, 11, 111);
cplot = NaN(length(xplot), length(yplot));

for ii = 1:length(xplot)
  for qq = 1:length(yplot)
    cplot(ii,qq) = logistic_2factor(betas, [xplot(ii), yplot(qq)]);
  end
end

figure;
plot(x1(logical(y)), x2(logical(y)), 'r+');
hold on
plot(x1(~logical(y)), x2(~logical(y)), 'ko');
contour(xplot, yplot, cplot', [0.5 0.5]);
xlabel('factor 1')
ylabel('factor 2')
title('2-D logistic_2factor regression')


%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
