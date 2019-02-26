%% Homework #1
% Alec Hoyland
% 2018-11-06 14:24

pHeader;
tic

%% A. Jacobi iterations

% build the G matrix
K 		= full(gallery('tridiag', 3, -1, 4, -1));
I 		= eye(3);
z 		= zeros(3);
G 		= [K -I z z; -I K -I z; z -I K -I; z z -I K];

%% 1. Determine the Jacobi error matrix B

M 		= G .* eye(size(G));
B 		= eye(size(G)) - inv(M) * G;

disp('The Jacobi error matrix:')
disp(B)

%% 2. Gerschgorin Circles

% centers of the Gerschgorin circles
C 		= diag(B);
% radii of the Gerschgorin circles
r 		= (sum(B') - C')';

disp('centers of the Gerschgorin circles:')
disp(C)
disp('radii of the Gerschgorin circles:')
disp(r)

%% 3. Plot the Gerschgorin circles

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
theta	= 0:0.01:2*pi;
c 		= linspecer(length(C));
eigs 	= eig(B);
for ii = 1:length(C)
	patch(real(r(ii)*cos(theta)+C(ii)), imag(i*r(ii)*sin(theta)+C(ii)), c(ii,:), 'FaceAlpha', 0.1);
	plot(real(eigs(ii)), imag(eigs(ii)), 'kx')
end
xlim([-1 1])
ylim([-1 1])
xlabel('real')
ylabel('imaginary')
title('Jacobi Gerschgorin circles')

figlib.pretty()
axis square

if being_published
	snapnow
	delete(gcf)
end

%% B. Gauss-Seidel iterations

%% 1. Determine the GS error matrix B

M 		= tril(G);
B 		= eye(size(G)) - inv(M) * G;

disp('The Gauss-Seidel error matrix:')
disp(B)

%% 2. Gerschgorin Circles

% centers of the Gerschgorin circles
C 		= diag(B);
% radii of the Gerschgorin circles
r 		= (sum(B') - C')';

disp('centers of the Gerschgorin circles:')
disp(C)
disp('radii of the Gerschgorin circles:')
disp(r)

%% 3. Plot the Gerschgorin circles

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
theta	= 0:0.01:2*pi;
c 		= linspecer(length(C));
eigs 	= eig(B);
for ii = 1:length(C)
	patch(real(r(ii)*cos(theta)+C(ii)), imag(i*r(ii)*sin(theta)+C(ii)), c(ii,:), 'FaceAlpha', 0.1);
	plot(real(eigs(ii)), imag(eigs(ii)), 'kx')
end
xlim([-1 1])
ylim([-1 1])
xlabel('real')
ylabel('imaginary')
title('Gauss-Seidel Gerschgorin circles')

figlib.pretty()
axis square

if being_published
	snapnow
	delete(gcf)
end

%% C. Successive Over-Relaxation iterations

%% 1. Determine the SOR error matrix B

M 		= tril(G, -1) + G / 1.07 * eye(size(G));
B 		= eye(size(G)) - inv(M) * G;

disp('The SOR error matrix:')
disp(B)

%% 2. Gerschgorin Circles

% centers of the Gerschgorin circles
C 		= diag(B);
% radii of the Gerschgorin circles
r 		= (sum(B') - C')';

disp('centers of the Gerschgorin circles:')
disp(C)
disp('radii of the Gerschgorin circles:')
disp(r)

%% 3. Plot the Gerschgorin circles

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
theta	= 0:0.01:2*pi;
c 		= linspecer(length(C));
eigs 	= eig(B);
for ii = 1:length(C)
	patch(real(r(ii)*cos(theta)+C(ii)), imag(i*r(ii)*sin(theta)+C(ii)), c(ii,:), 'FaceAlpha', 0.1);
	plot(real(eigs(ii)), imag(eigs(ii)), 'kx')
end
xlim([-1 1])
ylim([-1 1])
xlabel('real')
ylabel('imaginary')
title('SOR Gerschgorin circles')

figlib.pretty()
axis square

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
