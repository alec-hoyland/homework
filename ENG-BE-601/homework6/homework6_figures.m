[fish_ID, fish_length, fish_weight] = textread('homework6_data_problem1.txt', '%f%f%f', 'headerlines', 1);

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

figlib.pretty()
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_1.png')
close all

% construct the deviation matrix
D         = zeros(length(fish_weight), 2);
D(:,1)    = fish_length - mean(fish_length);
D(:,2)    = fish_weight - mean(fish_weight);

% construct the sample covariance matrix
S         = 1 / (length(D) - 1) * D' * D;

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

figlib.pretty()
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_2.png')
close all

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

figlib.pretty()
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_3.png')
close all

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

figlib.pretty()
drawnow
saveas(fig, '/home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_4.png')
close all

index = find(my_distances > c2)
disp('Fish IDs with high statistical differences')
fish_ID(index)

X = [fish_length fish_weight];
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
hist3(X, 'Nbins', [15 15]);
xlabel('fish length (in)')
ylabel('fish weight (oz)')
zlabel('# occurrences')

figlib.pretty()
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/homework6/homework6_figure_5.png')
close all
