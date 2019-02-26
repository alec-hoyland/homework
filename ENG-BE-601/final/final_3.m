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

figlib.pretty()

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

figlib.pretty()

if being_published
	snapnow
	delete(gcf)
end

%% 2.4 Chemical Differences in Coffee Species
% _C. robusta_ has higher chlorogenic acid and caffeine contents on a dry
% weight basis. These chemicals appear in the ATR spectra and help to discriminate
% between _C. arabica_ and _C. robusta_.

%% 3.1 Calculate the Deviation and Covariance Matrices

% deviation is data - mean
D 				= X - mean(X);
% covariance matrix
S 				= 1 / (length(D) - 1) * D' * D;

%% 3.2 Eigenvalues from the Covariance

[V, lambda] = eig(S);

disp('The eigenvector matrix of the covariance:')
disp(V)

disp('The eigenvalue matrix of the covariance:')
disp(lambda)

%% 3.3 Normalize the Covariance Eigenvectors

V 				= V ./ min(abs(V));

disp('Normalized covariance eigenvectors:')
disp(V)

%% 4.1 Total Variance in First Three Principal Components

eigs 			= diag(lambda);

disp('Total variance explained by first three PCs:')
disp([num2str(sum(eigs(1:3))/sum(eigs)*100) '%'])

%% 4.2 Different Signs in Eigenvectors
% The second principle component describes some of the differences between groups.
% The negative signs correspond to one species of coffee, and the positive signs
% to the other.

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
