%% Take-Home Final
% Alec Hoyland
% 12:36 2018-10-31

pHeader;
tic

%% 1. Load the Files

faceFolder 						= '/home/ahoyland/code/homework/ENG-BE-601/final/faces/';
StevenTyler 					= mat2gray(imcomplement(imread([faceFolder 'StevenTyler_BW_cropped(1)(1).tif'])));
MelissaRivers 				= mat2gray(imcomplement(imread([faceFolder 'MelissaRivers_BW_cropped(1)(1).tif'])));
LivTyler			 				= mat2gray(imcomplement(imread([faceFolder 'LivTyler_BW_cropped(1)(1).tif'])));
KieferSutherland			= mat2gray(imcomplement(imread([faceFolder 'KieferSutherland_BW_cropped(1)(1).tif'])));
RachelSutherland			= mat2gray(imcomplement(imread([faceFolder 'RachelSutherland_BW_cropped(1)(1).tif'])));
EmilyDeschanel 				= mat2gray(imcomplement(imread([faceFolder 'EmilyDeschanel_BW_cropped(1)(1).tif'])));
ZooeyDeschanel 				= mat2gray(imcomplement(imread([faceFolder 'ZooeyDeschanel_BW_cropped(1)(1).tif'])));
ZooeyDeschanel2				= mat2gray(imcomplement(imread([faceFolder 'ZooeyDeschanel2_BW_cropped(1)(1).tif'])));
KatyPerry			 				= mat2gray(imcomplement(imread([faceFolder 'KatyPerry_BW_cropped(1)(1).tif'])));

%% 2.1 Feature Extractions

features 							= struct;

features(1).name 			= 'StevenTyler';
features(1).eyes 			= StevenTyler(60:90, 30:130);
features(1).nose 			= StevenTyler(91:125, 10:140);
features(1).chin 			= StevenTyler(130:160, 20:120);

features(2).name 			= 'MelissaRivers';
features(2).eyes 			= MelissaRivers(50:80, 20:120);
features(2).nose 			= MelissaRivers(81:115, 10:140);
features(2).chin 			= MelissaRivers(130:160, 20:120);

features(3).name 			= 'LivTyler';
features(3).eyes			= LivTyler(60:90, 20:120);
features(3).nose 			= LivTyler(91:125, 10:140);
features(3).chin 			= LivTyler(140:170, 20:120);

features(4).name 			= 'KieferSutherland';
features(4).eyes 			= KieferSutherland(45:75, 20:120);
features(4).nose 			= KieferSutherland(81:115, 10:140);
features(4).chin 			= KieferSutherland(140:170, 20:120);

features(5).name 			= 'RachelSutherland';
features(5).eyes 			= RachelSutherland(55:85, 20:120);
features(5).nose 			= RachelSutherland(85:119, 10:140);
features(5).chin 			= RachelSutherland(140:170, 20:120);

features(6).name 			= 'EmilyDeschanel';
features(6).eyes 			= EmilyDeschanel(50:80, 20:120);
features(6).nose 			= EmilyDeschanel(81:115, 5:135);
features(6).chin 			= EmilyDeschanel(140:170, 20:120);

features(7).name 			= 'ZooeyDeschanel';
features(7).eyes 			= ZooeyDeschanel(45:75, 30:130);
features(7).nose 			= ZooeyDeschanel(81:115, 10:140);
features(7).chin 			= ZooeyDeschanel(140:170, 20:120);

features(8).name 			= 'ZooeyDeschanel2';
features(8).eyes 			= ZooeyDeschanel2(45:75, 25:125);
features(8).nose 			= ZooeyDeschanel2(81:115, 10:140);
features(8).chin 			= ZooeyDeschanel2(140:170, 20:120);

features(9).name 			= 'KatyPerry';
features(9).eyes 			= KatyPerry(45:75, 20:120);
features(9).nose 			= KatyPerry(81:115, 10:140);
features(9).chin 			= KatyPerry(140:170, 20:120);

%% 2.2 Horizontal Rastering and Concatenation
clear X

for ii = 1:9
	X(:,ii) 						= [features(ii).eyes(:); features(ii).nose(:); features(ii).chin(:)];
end

%% 3.1 Construct Un-Normalized Deviation Matrix

D 										= X - mean(X);

%% 3.2 Construct Sample Covariance Matrix

S 										= 1 / (length(D) - 1) * D' * D;

disp('The sample covariance matrix is:')
disp(S)

%% 3.3 Normalize the Deviation Vectors

for ii = 1:9
	D(:, ii) 						= D(:, ii) / norm(D(:, ii));
end

%% 3.4 Calculate the Pearson Correlation Coefficient Matrix

R 										= D' * D;

disp('The Pearson correlation coefficient matrix:')
disp(R)

%% 3.5 Questions
% The largest non-trivial correlation coefficient value is 0.80184, between faces #7
% and #8 (e.g. R(7,8)). Unsurprisingly, faces #7 and #8 are the same person:
% Zooey Deschanel. The highest correlation in pixel values for the three facial
% features examined are between the two pictures of the same person.

%% 4.1 Obtain Eigenvalues and Eigenvectors

[V, lambda] 				= eig(S);

disp('Eigenvectors:')
disp(V)

disp('Eigenvalue Matrix:')
disp(lambda)

%% 4.2 Normalize the Eigenvectors

V 									= V ./ min(abs(V));

disp('Normalized eigenvectors:')
disp(V)

%% 5.1 Total Variance Explained by First Three PCs

eigs 								= diag(lambda);
disp([num2str(sum(eigs(1:3))/sum(eigs)*100) '%'])

%% 5.2 Questions
% The 7th-9th entries in the second principal component have large values because
% the corresponding pictures all look very similar. Zooey and Katy have very similar
% smiles and large eyes. Zooey's actual sister, Emily, has a toothier smile with
% some cheek action causing her eyes to appear slimmer. For this reason, Zooey
% and Katy appear more similar in the 2nd PC.
%
% Steven, Melissa, and Liv all look quite similar, so the eigenvectors of the
% covariance matrix represent that.
%
% Kiefer and Rachel have chins that are different shapes and (with respect to
% these images) different tones. For this reason, the higher order eigenvectors
% begin to highlight the difference between Kiefer's chiseled jaw and his sister's.
%
% Melissa is the oddball, which makes sense considering that she is unrelated
% to any of the other people in the pictures. The eigenvector components related
% to her are dissimilar from the others.
%
% Photos #1 and #4 are most different from the others in that they depict men.
% Perhaps #1 and #2 have the most typically-classifiable male and female face
% characteristics as identified from the face snippets we correlated.


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
