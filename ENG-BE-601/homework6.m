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
xlim([0.5*min(fish_length) 1.5*max(fish_length)])
ylim([0.5*min(fish_weight) 1.5*max(fish_weight)])
title('Moosehead Lake Rock Bass')

prettyFig()
drawnow

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
S         = 1 / (length(D) - 1) * D' * D;

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
slope(2) 	= - 1/slope(1);
b         = mean(fish_weight) - slope * mean(fish_length);
x         = 0:max(fish_length);
plot(x, slope(1)*x + b(1), 'r')
plot(x, slope(2)*x + b(2), 'r')

xlabel('fish length (in)')
ylabel('fish weight (oz)')
xlim([0.5*min(fish_length) 1.5*max(fish_length)])
ylim([0.5*min(fish_weight) 1.5*max(fish_weight)])
title('Moosehead Lake Rock Bass')

prettyFig()
drawnow

if being_published
  snapnow
  delete(gcf)
end

disp('The inverse covariance matrix:')
disp(inv(S))

%% Problem #1 Part C

% compute statistical distance using the L-2 norm
my_distances = zeros(100,1);
for ii = 1:length(fish_weight)
	d			= zeros(2,1);
	d(1) 	= fish_length(ii) - mean(fish_length);
	d(2) 	= fish_weight(ii) - mean(fish_weight);
	my_distances(ii) = d' * inv(S) * d;
end
disp('The statistical distances:')
disp(my_distances)

% produce histogram of statistical distance
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
histogram(my_distances, 0:0.5:10)
xlim([0 10])
ylim([0 25])
xlabel('statistical distance')
ylabel('occurrences')
title('histogram of statistical differences')

prettyFig()
drawnow

if being_published
  snapnow
  delete(gcf)
end

disp('I have picked 0.95 for the alpha value');
disp('From the chi-square table, c_squared is = 5.99')
c2 = 5.99;

% scatter plot of data
fig = figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
ax = axes(fig);
dots      = plot(ax, fish_length, fish_weight, 'LineStyle', 'none',...
          'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', ...
          'MarkerSize', 20);
setMarkerColor(dots, 'k', 0.3);

hold on

% plot eigenvectors at centroid
slope(1)  = V(1) / V(2);
slope(2) 	= - 1/slope(1);
b         = mean(fish_weight) - slope * mean(fish_length);
x         = 0:max(fish_length);
plot(ax, x, slope(1)*x + b(1), 'r')
plot(ax, x, slope(2)*x + b(2), 'r')

% plot an ellipse as black dots
d1 				= linspace(-16.8, 16.8, 101);
d2 				= zeros(length(d1), 2);
invS 			= inv(S);
for ii = 1:length(d2)
	d2(ii,:)= roots([invS(2,2) (invS(1,2) + invS(2,1))*d1(ii) (invS(1,1)*d1(ii)^2 - c2^2)]);
end

plot(ax, d1, d2, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');

xlabel('fish length (in)')
ylabel('fish weight (oz)')
xlim([-5 25])
ylim([-25 25])
title('Moosehead Lake Rock Bass')

prettyFig()
drawnow

if being_published
  snapnow
  delete(gcf)
end

%% Problem #1 Part D

index = find(my_distances > c2)
disp('Fish IDs with high statistical differences')
fish_ID(index)

X = [fish_length fish_weight];
figure;
hist3(X, 'Nbins', [15 15]);
xlabel('fish length (in)')
ylabel('fish weight (oz)')
zlabel('# occurrences')

prettyFig()
drawnow

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
