%% Homework #2
% Problem 1
% Alec Hoyland
% 2019-4-4 11:53

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

for xx = 1:length(x)
	for yy = 1:length(y)
		for tt = 1:length(t)
			val = 0;
			for p = 1:nCoeffs
				for q = 1:nCoeffs
					val = val + C(p, q) * sin(p * pi / a * xx) * sin(q * pi / b * yy) * exp(-((p * pi / a)^2 + (q * pi / b)^2));
				end
			end
			u(xx, yy, tt) = val;
		end
	end
end

[X, Y] = meshgrid(x, y);

for tt = 1:length(t)

	figure;
	slice(X, Y, u(:, :, tt), 'EdgeColor', 'k');
	xlabel('x')
	ylabel('y')
	colorbar
	title(['temp heatmap at t = ' numstr(t(tt)) 's'])

	pdflib.snapnow
	delete(gcf)

end

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
