%% Take-Home Final
% Alec Hoyland
% 15:32 2018-10-29

pHeader;
tic

%% 1. Load the Data
[wavenumber, arabica1, arabica2, arabica3, arabica4, arabica5, ...
 robusta1, robusta2, robusta3, robusta4, robusta5 ] ...
 = textread('Problem3_coffee_FTIR_data.txt', ...
 '%f%f%f%f%f%f%f%f%f%f%f', 'headerlines', 3 );

%% 2. Build the Data Matrix

X 				= [arabica1 arabica2 arabica3 arabica4 arabica5 robusta1 robusta2 ...
					 	robusta3 robusta4 robusta5];

%% Singular Value Decomposition

[U, S, V]	= svd(X);

disp('The eigenvector matrix V:')
disp(V)

disp('The non-zero singular values:')
disp(diag(S))

% plot the singular values S on the y-axis vs. a dummy index
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
sigma 		= S(find(S));
semilogy(1:length(sigma), sigma);
grid on
ylabel('singular values')
xlabel('nth singular value')
title('singular values of coffee IR spectra')

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
