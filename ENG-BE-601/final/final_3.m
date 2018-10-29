%% Take-Home Final
% Alec Hoyland
% 15:32 2018-10-29

pHeader;
tic

%% 1.1 Load the Data
[wavenumber, arabica1, arabica2, arabica3, arabica4, arabica5, ...
 robusta1, robusta2, robusta3, robusta4, robusta5 ] ...
 = textread('Problem3_coffee_FTIR_data.txt', ...
 '%f%f%f%f%f%f%f%f%f%f%f', 'headerlines', 3 );

%% 1.2 Build the Data Matrix

X 				= [arabica1 arabica2 arabica3 arabica4 arabica5 robusta1 robusta2 ...
					 	robusta3 robusta4 robusta5];

%% 1.3 Singular Value Decomposition

[U, S, V]	= svd(X);

disp('The eigenvector matrix V:')
disp(V)

disp('The non-zero singular values:')
disp(diag(S))

%% 1.4 Plot the singular values S on the y-axis vs. a dummy index
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
sigma 		= S(find(S));
semilogy(1:length(sigma), sigma);
grid on
ylabel('singular values')
xlabel('nth singular value')
title('singular values of coffee IR spectra')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 1.5 SVD Decomposition of the Data

%%
% <</home/ahoyland/code/homework/ENG-BE-601/final/pcolor_X.png>>

%% SVD Submatrices

%%
% <</home/ahoyland/code/homework/ENG-BE-601/final/SVDsubmatrix_1.png>>

%%
% <</home/ahoyland/code/homework/ENG-BE-601/final/SVDsubmatrix_2.png>>

%%
% <</home/ahoyland/code/homework/ENG-BE-601/final/SVDsubmatrix_3.png>>

%% 2.1-2 Choose an SVD Submatrix that Demonstrates Differences Between _C. arabica_ and _C. robusta_
% I chose the second component since the differences between the species' IR signatures
% is most pronounced but the intraspecies differences are more minimal.

%% 2.3 Plot Absorbance vs. Wavenumber Spectrum

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
plot(wavenumber, robusta2)
title(['SVD #2, robusta 2 IR signature'])
xlabel('wavenumber (cm^{-1})')
set(gca, 'XDir', 'reverse')
ylabel('% absorbance')
grid on

%% 2.4 Chemical Differences in Coffee Species
% _C. robusta_ has higher chlorogenic acid and caffeine contents on a dry
% weight basis. These chemicals appear in the ATR spectra and help to discriminate
% between _C. arabica_ and _C. robusta_.

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
