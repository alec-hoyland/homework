%% Take-Home Final
% Alec Hoyland
% 14:07 2018-10-24

pHeader;
tic

%% Problem #1: Spatial Frequency and Feature Size within an Image

% load the image file and convert into floating point decimals
img 			= single(imread('/home/ahoyland/code/homework/ENG-BE-601/RedPill2_BW.tif'));
% invert the tone by making black = 127.5 and white = -127.5
img 			= - (img - 127.5);

% perform singular-value decomposition
[U, S, V] = svd(img);

% plot the singular values S on the y-axis vs. a dummy index
figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);
sigma 		= S(find(S));
semilogy(1:length(sigma), sigma);
grid on
ylabel('singular values')
xlabel('nth singular value')
title('singular values of redpill2')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% Problem #1: Spectral Sums to Resolve "Morpheus"
% You're able to get a recognizable "Morpheus" around 50/598 sums, but at
% around 100 sums the lettering really starts to take shape. The bottom part
% of the "p" has a lot of trouble -- around 200 sums, it stops getting smeared.
% <</home/ahoyland/code/homework/ENG-BE-601/final/morpheus.jpg>>

%% Problem #1: Spectral Sums to Resolve Question Mark
% The question mark becomes recognizable after 50 sums. 75 sums makes a
% much prettier image.
% <</home/ahoyland/code/homework/ENG-BE-601/final/questionmark.jpg>>

%% Problem #1: Spectral Sums to Resolve "4 7 8"
% The 7 and 8 render very well at 150 sums, but the 4 doesn't become recognizable
% until around 180-200 sums.

%% Problem #1: Comparing the Original and SVD-approximated Images
% I would expect there to be slight variation between the two images
% as represented by pixel intensities. Specifically, I would expect the
% SVD-decomposed image to have less contrast and therefore smaller variance
% which would cause the clustering to spread out (variance between x1 and x2).

n = [100 75 200];
for ii = 1:3

	[U, S, V] = svd(img);

	A 			= img';
	B 			= spectralSums(n(ii), U, S, V)';
	x1 			= A(:);
	x2 			= B(:);

	figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]); hold on
	plot(x1, x2, '.')
	xlabel('original image intensities')
	ylabel('SVD-reconstructed pixel intensities')
	title(['N' num2str(ii)])

	prettyFig()

	if being_published
		snapnow
		delete(gcf)
	end

	% compute the deviation vectors
	d1 			= x1 - mean(x1);
	d2 			= x2 - mean(x2);

	% store these vectors in a columnwise normalized matrix
	d1hat 	= d1 / norm(d1);
	d2hat 	= d2 / norm(d2);

	% form the normalized deviation matrix
	clear S
	clear V
	D 			= [d1hat d2hat];

	% calculate the sample covariance matrix
	S 			= 1 / (length(D)) * D' * D;

	% calculate the eigenvalues and eigenvectors
	[V, lambda] = eig(S);

	disp(['(N' num2str(ii) ') ' 'The sample covariance matrix is:'])
	disp(S)
	disp(['(N' num2str(ii) ') ' 'The eigenvalue matrix is:'])
	disp(lambda)
	disp(['(N' num2str(ii) ') ' 'The eigenvectors are:'])
	disp(V)

	% plot the principal axes
	figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]); hold on
	plot(x1, x2, '.')
	plot(x1, V(1)/V(3)*(x1-mean(x1)) + mean(x2), 'k-')
	plot(x1, V(2)/V(4)*(x1-mean(x1)) + mean(x2), 'k-')
	xlabel('original image intensities')
	ylabel('SVD-reconstructed pixel intensities')
	title(['N' num2str(ii)])

	axis square
	axis([-255 255 -255 255])

	prettyFig()

	if being_published
		snapnow
		delete(gcf)
	end

	l = diag(lambda);

	disp(['(N' num2str(ii) ') ' 'The % variance explained by principal axis 1:'])
	disp(100*l(1)/sum(l))

	disp(['(N' num2str(ii) ') ' 'The % variance explained by principal axis 2:'])
	disp(100*l(2)/sum(l))

	disp(['(N' num2str(ii) ') ' 'The Pearson correlation coefficient is:'])
	disp(D'*D)

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
