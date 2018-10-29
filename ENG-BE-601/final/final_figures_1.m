%% Take-Home Final
% Alec Hoyland
% 14:07 2018-10-24

%% Problem #1: Spatial Frequency and Feature Size within an Image

% load the image file and convert into floating point decimals
img 			= single(imread('/home/ahoyland/code/homework/ENG-BE-601/RedPill2_BW.tif'));
% invert the tone by making black = 127.5 and white = -127.5
img 			= - (img - 127.5);

% perform singular-value decomposition
[U, S, V] = svd(img);


%% Problem #1: Spectral Sums to Resolve "Morpheus"

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
A 			= spectralSums(100, U, S, V);
imshow(mat2gray(A));
title('83.28% compression')
prettyFig
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/morpheus.jpg')
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/morpheus.png')
close

%% Problem #2: Spectral Sums to Resolve Question Mark

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
A 			= spectralSums(75, U, S, V);
imshow(mat2gray(A));
title('87.46% compression')
prettyFig
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/questionmark.jpg')
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/questionmark.png')
close

%% Problem #2: Spectral Sums to Resolve 4 7 8

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
A 			= spectralSums(200, U, S, V);
imshow(mat2gray(A));
title('66.56% compression')
prettyFig
drawnow
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/478.jpg')
saveas(gcf, '/home/ahoyland/code/homework/ENG-BE-601/final/478.png')
close
