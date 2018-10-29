%% Take-Home Final
% Alec Hoyland
% 15:44 2018-10-29

% load the data
[wavenumber, arabica1, arabica2, arabica3, arabica4, arabica5, ...
 robusta1, robusta2, robusta3, robusta4, robusta5 ] ...
 = textread('Problem3_coffee_FTIR_data.txt', ...
 '%f%f%f%f%f%f%f%f%f%f%f', 'headerlines', 3 );

% construct the data matrix
X 				= [arabica1 arabica2 arabica3 arabica4 arabica5 robusta1 robusta2 ...
					 	robusta3 robusta4 robusta5];

% singular value decomposition
[U, S, V]	= svd(X);
sigma 		= diag(S);

% plot the data spectra using pcolor
[nrows, ncols] 	= size(X);
fake_column 		= NaN .* ones(nrows, 1);
fake_row 				= NaN .* ones(1, ncols + 1);
Xpcolor 				= [X, fake_column];
Xpcolor 				= [Xpcolor; fake_row];
x 							= 1:11;
y 							= linspace(900, 1900, 287);
[Xmesh, Ymesh] 	= meshgrid(x, y);
myXTickLabels 	= {'a1', 'a2', 'a3', 'a4', 'a5', 'r1', 'r2', 'r3', 'r4', 'r5'};

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
h 							= pcolor(Xmesh, Ymesh, Xpcolor);
ch							= colorbar;
caxis([0 50])
set(get(ch, 'YLabel'), 'String', '% absorbance')
set(gca, 'EdgeColor', 'none', 'YDir', 'reverse')
title('Original Data X')
set(h, 'XTick', x-0.5, 'XTickLabels', myXTickLabels);
xlabel('coffee bean bag/type')
ylabel('wavenumber (cm^{-1})')
colormap(jet)
return

% plot the first 3 SVD spectra using pcolor
for ii = 1:3
end

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
A 			= spectralSums(100, U, S, V);
imshow(mat2gray(A));
title('83.28% compression')
prettyFig
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/morpheus.jpg')
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/morpheus.png')
close
