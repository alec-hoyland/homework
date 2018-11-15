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

% set up the A matrix
A 					= [t ones(size(t))];
% set up the b vector
b 					= y;

disp('A matrix where the first column is t')
disp('A''A:')
disp(A'*A)
disp('A''b:')
disp(A'*b)

disp('My integer guess for a is 4')
a 					= 4;

%% 1.3 Find Coefficients

disp('A matrix where the first column is sin(2\pi/a*t)')
A 					= [sin(2*pi/a*t) ones(size(t))];
disp('A''A:')
disp(A'*A)
disp('A''b:')
disp(A'*b)

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

%% 2.1 Steepest Descent


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
