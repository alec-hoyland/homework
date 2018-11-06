%% Homework #1
% Alec Hoyland
% 2018-11-06 12:55

pHeader;
tic

%% 1.1 SOR with an arbitrary tuning factor
% The solution gets "stuck" at a solution and does not converge. The approximate
% solution changes drastically in the first few iterations and then ceases to change.
% The norm of the residual does not significantly decrease in the first few iterations
% however. The unoptimized SOR parameter is likely to blame.

% define the matrix of interest
A 					= [4, -1.5, 0.5; -1.5, 4, -1.5; -0.5, -1.5, 4];
% A*x = b
b 					= [5; 5; -4];
% initial guess
x0 					= [1; 1; 1];

% define the SOR matrix
omega 			= 1.8;
M 					= tril(A, -1) + A / omega .* eye(3);

% perform the SOR iteration
x 					= zeros(3, 31);
x(:, 1) 		= x0;

for ii = 2:length(x)
	disp(['[INFO] iteration #' num2str(ii)])

	x(:,ii)		= ( (M - A) * x(:,ii-1) + b ) \ M;
	residual 	= b - A * x(:,ii);
	disp(['[INFO] residual norm = ' num2str(norm(residual))])

	if norm(residual) < 0.01
		break
		disp(['[INFO] SOR converges, terminating...'])
	end

end

disp('Iterations with \omega = 1.8')
disp(x)

%% 2. Eigenvalues of the error matrix
% The eigenvalues of the error matrix for given SOR tuning parameters. $\omega = 1.8$
% produces eigenvalues that lie outside the complex unit circle. $\omega=1.6$ produces
% eigenvalues of B that lie within.

omega 			= linspace(1, 2, 21);
eigs 				= NaN(3, length(omega));
for ii = 1:length(omega)
	M 				= tril(A, -1) + A / omega(ii) .* eye(3);
	B 				= eye(3) - inv(M) * A;
	eigs(:,ii)= eig(B);
end

figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]); hold on
% plot the eigenvalues in the complex plane
c 					= linspecer(length(omega));
for ii = 1:length(omega)
	plot(eigs(:, ii), 'o', 'MarkerEdgeColor', c(ii,:))
	leg{ii} 	= ['\omega = ' num2str(omega(ii))];
end

% add unit circle
theta				= 0:0.01:2*pi;
plot(real(cos(theta)), imag(i * sin(theta)), 'k');

leg{end+1} 	= 'unit circle';
legend(leg, 'Location', 'West')
xlabel('real')
ylabel('imaginary')
ylim([-3 3])
xlim([-3 3])
axis square
title('The eigenvalues of matrix B as a function of the SOR tuning factor \omega')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 3. SOR with a less arbitrary tuning factor
% The algorithm achieved convergence because the error matrix eigenvalues with
% $\omega = 1.6$ lie within the unit circle. This means that the error will decrease
% with each iteration.

% define the SOR matrix
omega 			= 1.6;
M 					= tril(A, -1) + A / omega .* eye(3);

% perform the SOR iteration
x 					= zeros(3, 31);
x(:, 1) 		= x0;

for ii = 2:length(x)
	disp(['[INFO] iteration #' num2str(ii)])

	x(:,ii)		= ( (M - A) * x(:,ii-1) + b ) \ M;
	residual 	= b - A * x(:,ii);
	disp(['[INFO] residual norm = ' num2str(norm(residual))])

	if norm(residual) < 0.01
		break
		disp(['[INFO] SOR converges, terminating...'])
	end

end

disp('Iterations with \omega = 1.6')
disp(x)

%% 4. Estimate the optimal parameter
% The best parameter is close to $\omega_{opt} = 1.15$.

% define the SOR matrix
omega 			= 1.15;
M 					= tril(A, -1) + A / omega .* eye(3);

% perform the SOR iteration
x 					= zeros(3, 31);
x(:, 1) 		= x0;

for ii = 2:length(x)
	disp(['[INFO] iteration #' num2str(ii)])

	x(:,ii)		= ( (M - A) * x(:,ii-1) + b ) \ M;
	residual 	= b - A * x(:,ii);
	disp(['[INFO] residual norm = ' num2str(norm(residual))])

	if norm(residual) < 0.01
		break
		disp(['[INFO] SOR converges, terminating...'])
	end

end

disp('Iterations with \omega = 1.15')
disp(x)

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
