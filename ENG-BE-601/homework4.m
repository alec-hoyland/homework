%% Homework #4
% Alec Hoyland
% 16:34 2018-09-28

pHeader;
tic

%% Part #2

% half-period length
L     = 3;
% set up the "time" vector
x     = linspace(0, 2*L, 101);
% the function is a sawtooth with amplitude L^2 and slope -L, zero when negative
y     = L^2 - L*x;
y(y<0) = 0;

% fit a 5th-order Fourier series using the least-squares method
addpath('fourier/')
[A, B] = Fseries(x, y, 6);

disp('The Fourier cosine coefficients are:')
disp(A)
disp('The Fourier sine coefficients are:')
disp(B(2:end))

figure('OuterPosition',[0 0 1200 800],'PaperUnits','points','PaperSize',[1200 800]);
hold on
plot(x, y)
plot(x, Fseriesval(A, B, x))
xticks([0 3 6])
xticklabels({'0', 'L', '2L'})
ylabel('amplitude (a.u.)')
legend({'data', '5th-order fourier'})

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% Problem #3

% load the oscilloscope data
[t, y]  = textread('homework4_data_problem3.txt', '%f%f', 'headerlines', 1);
L       = 1; % s

% create a matrix of sines
S       = zeros(length(t), 5);
for ii = 1:5
  S(:, ii) = sin(ii * pi / L * t);
end

% compute the sine Fourier coefficients using the least squares method
b = (S' * y) \ (S' * S);

disp('The sine Fourier coefficients are:')
disp(b)

disp('The "S" matrix is orthogonal:')
disp(S' * S)

% create a matrix of sines
C       = zeros(length(t), 6);
for ii = 0:5
  C(:, ii+1) = cos(ii * pi / L * t);
end

% compute the sine Fourier coefficients using the least squares method
a = (C' * y) \ (C' * C);

disp('The sine Fourier coefficients are:')
disp(a)

disp('The "C" matrix is orthogonal:')
disp(C' * C)

% combine the terms into a linear combination
yapprox = C * a' + S * b';

figure('OuterPosition',[0 0 1200 800],'PaperUnits','points','PaperSize',[1200 800]);
hold on
plot(t, y, 'o')
plot(t, yapprox/max(yapprox)*max(y))
xticks([0 1 2 3 4])
xticklabels({'0', 'L', '2L', '3L', '4L'})
ylabel('amplitude (a.u.)')
legend({'data', '5th-order fourier'})

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
