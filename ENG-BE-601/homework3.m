%% Homework #3
% Alec Hoyland
% 17:05 2018-09-26

pHeader;
tic

%% Part 1: Choosing the Right Polynomial
% I would choose the cubic function because the data are non-monotonic and odd.

% load the data
[x, y] = textread('homework3_data_problem1.txt', '%f%f', 'headerlines', 1);

% compute the least-squares coefficients
X = zeros(length(x), 4);
X(:, 1) = 1;
X(:, 2) = x;
X(:, 3) = x .* x;
X(:, 4) = x .* x .* x;

c = (X' * X) \ (X' * y);

disp('The least-squares coefficients:')
disp(c)

% plot the data, y
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
plot(x, y, 'o')
hold on
xfit = linspace(min(x), max(x), 101);
yfit = c(1) + c(2) * xfit + c(3) * xfit .* xfit + c(4) * xfit .* xfit .* xfit;
plot(xfit, yfit);
xlabel('x-data');
ylabel('y-data');
title('some data with some regression')
legend({'data', 'fit'})

figlib.pretty()

if being_published
  snapnow
  delete(gcf)
end

%% Part 2: Analyzing your Residuals
fitfunc = @(x) c(1) + c(2) * x + c(3) * x .* x + c(4) * x .* x .* x;
r     = fitfunc(x) - y;
sse   = sum(r .* r);

disp('The sum of the squares error is:')
disp(sse)

% plot a histogram of the residuals
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
histogram(r, -1:0.025:1)
xlim([-1 1])
ylim([0 10])
ylabel('# of occurances')
xlabel('value')
title('distribution of residuals')

disp('The mean of the residuals is:')
disp(mean(r))
disp('The variance of the residuals is')
disp(var(r))
disp('The variance times N-1 is')
disp(var(r) * (length(r) - 1))

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

t = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
