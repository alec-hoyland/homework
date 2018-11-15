%% Homework #2
% Problem 1
% Alec Hoyland
% 2018-11-15 12:18

pHeader;
tic

%% 1.1 Load the Data

% load all data
[t, y]			= textread('problem1_sineData.txt', '%f%f', 'headerlines', 1);

%% 1.2 Set up the Least-Squares Equation

a 					= 4;
b 					= y;

disp('A matrix where the first column is sin(2\pi/a*t)')
A 					= [sin(2*pi/a*t) ones(size(t))];
disp('A''A:')
disp(A'*A)
disp('A''b:')
disp(A'*b)

disp('My integer guess for a is 4')

%% 1.3 Find Coefficients

x 					= mldivide(A'*A, A'*b);
C 					= x(1);
f 					= x(2);

disp('My C estimate, given a = 4, is:')
disp(C)
disp('My f estimate, given a = 4, is:')
disp(f)

% create a scatter plot of the data
figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y, 'or')
plot(t, C * sin(2*pi/a*t) + f, 'k');
xlabel('t')
ylabel('y')
title('Data and Least-Squares Fit')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 1.4 Calculate the MSE

r 				= b - A*x;
r2 				= norm(r)^2;

disp('the sum-of-squares of the residuals is:')
disp(r2)

%% 1.5 Plot a Histogram of the Residuals

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
histogram(r, 'BinWidth', 0.1)
xlabel('residual value')
ylabel('# of occurrences')
title('distribution of residual values')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

disp('The residuals appear to be uniformly distributed.')

%% 2.1-2 Steepest Descent

[t, y]			= textread('problem1_sineData.txt', '%f%f', 'headerlines', 1);

disp('A matrix where the first column is sin(2\pi/a*t)')
A 					= [sin(2*pi/4*t) ones(size(t))];
b 					= y;

x 					= mldivide(A'*A, A'*b);
C 					= x(1);
f 					= x(2);

%% 2.3 Steepest Descent Least-Squares Paraboloid

phi 				= zeros(51, 51);
icount 			= 0;
qcount 			= 0;
for ii = linspace(-10, 10, 51)
	icount 		= icount + 1;
	qcount 		= 0;
	for qq = linspace(-10, 10, 51)
		x 			= [ii, qq]';
		qcount 	= qcount + 1;
		phi(icount, qcount) = x'*(A'*A)*x - 2*x'*(A'*b) + norm(b)^2;
	end
end

%% 2.4 Elliptical Contour Plot

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

[X,Y] 			= meshgrid(linspace(-10, 10, 51), linspace(-10, 10, 51));
contour(X, Y, phi, 15);
xlabel('x_1')
ylabel('x_2')
title('contour plot')
xlim([-10, 10])
ylim([-10, 10])
axis square

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.5 Choose an Initial Guess Vector

x0 					= [8, -3]';
x(:,1) 			= x0;

%% 2.6 Find Coefficients using Steepest Descent

old_norm = -1;
for ii = 2:100
	disp(['[INFO] iteration # ' num2str(ii-1)])

	residual	= b - A*x(:, ii-1);
	res_norm 	= residual' * residual;
	w(:,ii-1)	= 2 * (A'*b - A'*A*x(:,ii-1));
	alpha 		= 1/2 * (w(:,ii-1)'*w(:,ii-1)) / (w(:,ii-1)'*A'*A*w(:,ii-1));
	x(:,ii) 	= x(:, ii-1) + alpha * w(:, ii-1);

	disp(['[INFO] x: ' mat2str(x(:,ii-1)')])
	disp(['[INFO] residual: ' mat2str(residual')])
	disp(['[INFO] residual norm squared: ' num2str(res_norm)])
	disp(['[INFO] downhill gradient: ' mat2str(w(:,ii-1)')])
	disp(['[INFO] hiking distance: ' num2str(alpha)])

	if res_norm - old_norm < 0.0001 & ii > 4
		disp(['[INFO] solution converges'])
		disp(['[INFO] x: ' mat2str(x(:,ii)')])
		disp(['[INFO] residual: ' mat2str(residual')])
		disp(['[INFO] residual norm squared: ' num2str(res_norm)])
		break
	end
	old_norm 		= res_norm;
end

%% 2.7 Plot Steps

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

[X,Y] 			= meshgrid(linspace(-10, 10, 51), linspace(-10, 10, 51));
contour(X, Y, phi, 15);
for ii = 1:size(x, 2)
	plot(x(1,ii), x(2,ii), 'ok', 'MarkerFaceColor', 'k');
end
for ii = 1:size(x, 2)-1
	plot([x(1,ii), x(1,ii)+w(1,ii)], [x(2,ii), x(2,ii)+w(2,ii)], 'Color', [0 0 0 0.2], 'LineWidth', 2);
end
xlabel('x_1')
ylabel('x_2')
title('contour plot')
xlim([-10, 10])
ylim([-10, 10])
axis square

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

time = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
