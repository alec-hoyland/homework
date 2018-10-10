%% Homework #4, Problem 3
% Alec Hoyland
% 11:24 2018-10-2

addpath('haar')

pHeader;
tic

%% Load the Photo
% Meghan, Duchess of Sussex

% load the .tif file
A = imread('Meghan_Markle_BW.tif', 'tiff');
% convert to single-precision floating point numbers
A = single(A);
% flip black and white (white == 0)
% A = abs(A - 255) - 127.5;
A = 126.5 + imcomplement(A);

% display original image
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(A));
title('original image with inverted colors')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% Generate Haar Matrix
% For an image matrix $\mathrm{A}$ and a row-wise normalized Haar matrix $\mathrm{W}$,
% the 2-D compressed image is $\mathrm{C} = \mathrm{W}^{-1} \mathrm{A} (\mathrm{W}^{-1})^T$.
% These operations can be performed using the Haar matrix, or by using a "high-school algorithm."

% column rastering
W = haar(512, 'half');
B = W * A;

%% J = 9 Post-Column Raster

% display the J = 9 post-column raster result
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(B));
title('J = 9, post-columns only')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

% row rastering
C = haar2(A);

%% J = 8

% display the J = 8 photo
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(C))
title('Proper J = 8 photo (small upper-left corner)')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

% J = 7
A2 = C(1:256, 1:256);
C2 = haar2(A2);

%% J = 7

% display the J = 7 photo
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(C2))
title('Proper J = 7 photo (small upper-left corner)')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% J = 6

% J = 6
A3 = C2(1:128, 1:128);
C3 = haar2(A3);

% display the J = 6 photo
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(C3))
title('Proper J = 6 photo (small upper-left corner)')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% J = 5

% J = 5
A4 = C3(1:64, 1:64);
C4 = haar2(A4);

% display the J = 5 photo
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
imshow(mat2gray(C4))
title('Proper J = 5 photo (small upper-left corner)')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% 32 x 32 image

% visualize the 32x32 snapshot of the Duchess
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
snap = C4(1:32, 1:32);
pcolor(snap)
% caxis([-127.5 127.5]);
title('tiny Meghan')

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% 32 x 32 matrix

disp('The 32x32 snapshot is:')
disp(snap)

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
