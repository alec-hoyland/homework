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
b 			= 100;
b0      = 50;
eps     = 10;
h0      = 3;

% reconstruct u(x, 0) using a 60-term fourier series
nCoeffs = 60;
C 		= zeros(60, 60); % p, q
x 		= 0:0.5:a; % pick some nice sample frequency
y 		= 0:0.5:b; % pick some nice sample frequency
t 		= [10 50 100 1000];

% compute the fourier coefficients using the by-hand calculate formulae

for p = 1:nCoeffs
	for q = 1:nCoeffs
		prefactor = a^2 * q / (pi * (a^2*q^2 + b^2*p*2));
		prefactor = prefactor * (-2 / (p * pi) * h0 * (cos(p * pi / a * (b0 + eps) - cos(p * pi / a * (b0 - eps)))));
		prefactor = prefactor / sinh(p * pi / a * b);
		C(p, q) = prefactor * (exp(-pi * b * p / a) - exp(pi * b * p / a));
	end
end

% compute the temperature u(x,y,t)
u 		= zeros(length(x), length(y), length(t));

for

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
