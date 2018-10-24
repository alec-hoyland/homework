%% Take-Home Final
% Alec Hoyland
% 14:07 2018-10-24

pHeader;
tic

%% Problem #1

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
