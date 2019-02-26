%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem3.txt', '%f%f%f', 'headerlines', 1);

%% 1. Solve using Levenberg-Marquardt
options         = LMFsolve('default');
options.Display = 1;
[pf, ssq, cnt]  = LMFsolve(@(p) norm(y - logistic(p, x1, x2)), [1 1 1], options);

%% 2. Visualizing the results

figure;
plot3(x1(logical(y)), x2(logical(y)), y(logical(y)), 'r+');
hold on;
plot3(x1(~logical(y)), x2(~logical(y)), y(~logical(y)), 'ko');
xgrid = 0:0.1:12;
ygrid = 0:0.1:12;
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

figlib.pretty();

if being_published
  snapnow
  delete(gcf)
end

figure;
plot(x1(logical(y)), x2(logical(y)), 'r+');
hold on
plot(x1(~logical(y)), x2(~logical(y)), 'ko');
plot(x1, (-pf(2)*x1 - pf(1))/pf(3), 'k');
xlabel('factor 1')
ylabel('factor 2')
title('2-D logistic regression')

figlib.pretty();

if being_published
  snapnow
  delete(gcf)
end

%% 4. Sensitivity and Specificity
sensitivity = (sum(logical(y)) - 6) / sum(logical(y))
specificity = (sum(~logical(y)) - 12) / sum(~logical(y))



%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
