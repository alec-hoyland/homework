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

%% 2. Feature Extractions

features 							= struct;

features(1).name 			= 'StevenTyler';
features(1).eyes 			= StevenTyler(60:90, 30:130);
features(1).nose 			= StevenTyler(91:125, 10:140);
features(1).chin 			= StevenTyler(130:160, 20:120);

features(1).name 			= 'MelissaRivers';
features(1).eyes 			= MelissaRivers(50:80, 20:120);
features(2).nose 			= MelissaRivers(81:115, 10:140);
features(3).chin 			= MelissaRivers(130:160, 20:120);

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
