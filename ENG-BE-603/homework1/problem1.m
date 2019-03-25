%% Homework #1
% Problem 1
% Alec Hoyland
% 2019-3-25 14:09

pdflib.header;
tic

%% Reconstruct diffusion wave from Fourier coefficients

% known parameters
D       = 5e-6;
h1      = 0;
h2      = 5;
a       = 100;
b0      = 50;
eps     = 10;
h0      = 3;

% reconstruct u(x, 0) using a 60-term fourier series
nCoeffs = 60;
k 		= zeros(60, 1);
x 		= 0:0.5:a; % pick some nice sample frequency

% compute the fourier coefficients using the by-hand calculate formulae
for n = 1:nCoeffs
	term1 = - 2 / (n * pi) * h0 * (cos(n * pi / a * (b0 + eps)) - cos(n * pi / a * (b0 - eps)));
	if mathlib.iseven(n)
		term2 = 0;
	else
		term2 = - 4 / (n * pi) * h1;
	end
	if mathlib.iseven(n)
		term3 = - 2 / (n * pi) * (h2 - h1);
	else
		term3 = 2 / (n * pi) * (h2 - h1);
	end
	k(n) = term1 + term2 + term3;
end

% set up the output vectors
ux		= zeros(length(x), 1);
sines 	= zeros(nCoeffs, 1);

% compute u(x, 0) by neglecting the time-dependent term
for ii = 1:length(x)
	for n = 1:nCoeffs
		sines(n) = sin(n * pi / a * x(ii));
	end
	ux(ii) = h1 + (h2 - h1) / a * x(ii) + k' * sines;
end

% construct the theoretical h(x) function
h 		= h0 * ones(length(x), 1);
h(x < b0 - eps) = 0;
h(x > b0 + eps) = 0;

figure;
plot(x, h)
hold on
plot(x, ux)
xlabel('length (nm)')
ylabel('concentration (\mu m)')
title('concentration at t=0')
legend({'theoretical', 'fourier n=60'})
axis([0 100 0 10])

figlib.pretty
% pdflib.snap
% delete(gcf)

%% Reconstruct diffusion wave for position and time

t		= 0:5:1000; % ns

[X, T] 	= meshgrid(x, t);
u 		= zeros(length(x), length(t));

% compute u(x, t)
for qq = 1:length(t)
	for ii = 1:length(x)
		for n = 1:nCoeffs
			sines(n) = sin(n * pi / a * x(ii)) * exp(-n^2 * pi^2 * D / a^2 * t(qq));
		end
		u(ii, qq) = h1 + (h2 - h1) / a * x(ii) + k' * sines;
	end
end

figure;
surf(X, T, u, 'EdgeColor', 'none')
xlabel('position (nm)')
ylabel('time (ns)')
zlabel('concentration (mM)')

figlib.pretty

% pdflib.snap
% delete(gcf)


%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
