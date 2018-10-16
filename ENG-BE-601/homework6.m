%% Homework #6
% Alec Hoyland
% 15:42 2018-10-15

pHeader;
tic

%% Problem #1 Part A

%% Loading Data
% Load the dataset for the lengths (inches) and weights (ounces) of rock bass
% caught at Moosehead Lake in Maine.

[fish_ID, fish_length, fish_weight] = textread('homework6_data_problem1.txt', '%f%f%f', 'headerlines', 1);

disp('Number of fish:')
disp(length(fish_ID))
disp('The mean of the fish length is:')
disp(mean(fish_length))
disp('The mean of the fish weight is:')
disp(mean(fish_weight))

%% Preliminary Statistics
% Visualize the fish data.

% scatter plot of data
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
dots      = plot(fish_length, fish_weight, 'LineStyle', 'none',...
          'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', ...
          'MarkerSize', 20);
setMarkerColor(dots, 'k', 0.3);
xlabel('fish length (in)')
ylabel('fish weight (oz)')
title('Moosehead Lake Rock Bass')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

% construct the deviation matrix
D         = zeros(length(fish_weight), 2);
D(:,1)    = fish_length - mean(fish_length);
D(:,2)    = fish_weight - mean(fish_weight);

disp('The deviation matrix:')
disp(D)

% construct the sample covariance matrix
S         = zeros(2);
for ii = 1:2
  for qq = 1:2
    S(ii,qq) = 1 / (length(D) - 1) * D(:,ii)' * D(:,qq);
  end
end

disp('The covariance matrix:')
disp(S)

% construct the Pearson's correlation coefficient matrix
r         = zeros(2);
for ii = 1:2
  for qq = 1:2
    r(ii,qq) = S(ii,qq) / ( sqrt(S(ii,ii)) * sqrt(S(qq,qq)) );
  end
end

disp('The Pearson''s correlation matrix:')
disp(r)

%% Problem #1 Part B

% compute the eigenvalues
[V, lambda] = eig(S)

% scatter plot of data
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
dots      = plot(fish_length, fish_weight, 'LineStyle', 'none',...
          'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', ...
          'MarkerSize', 20);
setMarkerColor(dots, 'k', 0.3);

hold on

% plot eigenvectors at centroid
slope(1)  = V(1) / V(2);
slope(2)  = V(3) / V(4);
b         = mean(fish_weight) - slope * mean(fish_length);
x         = 0:max(fish_length);
plot(x, slope(1)*x + b(1), 'r')
plot(x, slope(2)*x + b(2), 'r')

xlabel('fish length (in)')
ylabel('fish weight (oz)')
title('Moosehead Lake Rock Bass')

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

t = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
