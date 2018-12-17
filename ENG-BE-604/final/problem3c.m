%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem3c.txt', '%f%f%f', 'headerlines', 1);

%% 1. Solve using Levenberg-Marquardt
options         = LMFsolve('default');
options.Display = 1;
[pf, ssq, cnt]  = LMFsolve(@(p) norm(y - logistic(p, x1, x2)), [0 0 0 1 0 -1.9], options);

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
    Z(ii, qq) = logistic(pf, xgrid(ii), ygrid(qq));
  end
end
surf(X, Y, Z, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
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

figure;
plot(x1(logical(y)), x2(logical(y)), 'r+');
hold on
plot(x1(~logical(y)), x2(~logical(y)), 'ko');
% fplot(xplot, yplot, [0 2*pi], 'k');
xlabel('factor 1')
ylabel('factor 2')
title('2-D logistic regression')


%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
