%% Homework #4
% Problem 1
% Alec Hoyland
% 2019-4-24 17:17

pdflib.header;
tic

ri = 2e6;
rm = 50e3;
cm = 150e-9;
ro = 1e6;

alpha = 1 / (ri * cm);
beta = 1 / (rm * cm);
gamma = ro / ((ro + ri) * cm);

a = 0;
b = 10e-3;
Q = 100e-9;

xext = 0.25;
tfinal = 150e-3;
dt = 0.01;
dt = 0.005e-3;

x = -xext:dt:xext;
t = dt:dt:tfinal;

V = zeros(length(x), length(t));
for ii = 1:length(x)
	for qq = 1:length(t)
		V(ii, qq) = green(x(ii), t(qq));
	end
end

pulse = zeros(length(x), length(t));
[~, temp] = min(abs(x - a));
[~, temp2] = min(abs(t - b));
pulse(temp, 1:temp2) = Q;

Vpulse = sconv2(sparse(pulse), sparse(V), 'same');
%% Plot

figure;
[X, T] = meshgrid(x, t);
pcolor(X, T, V');
xlabel('distance (cm)')
ylabel('time (s)')
zlabel('membrane potential (mV)')

pdflib.snap
delete(gcf)

figure;
[X, T] = meshgrid(x, t);
surf(X, T, V');
xlabel('distance (cm)')
ylabel('time (s)')
zlabel('membrane potential (mV)')

pdflib.snap
delete(gcf)

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function g = green(x, t)
	ri = 2e6;
	rm = 50e3;
	cm = 150e-9;
	ro = 1e6;

	alpha = 1 / (ri * cm);
	beta = 1 / (rm * cm);
	gamma = ro / ((ro + ri) * cm);

	a = 0;
	b = 10e-3;
	Q = 100e-9;

	part1 = exp(- beta * t);
	part1 = part1 * exp(-x^2/(4*a*t)) * exp(x/(2 * t)) * exp(-a/(4*t)) / sqrt(a * t);
	part2 = exp(- beta * (t - b));
	part2 = part2 * exp(-x^2/(4*a*(t-b))) * exp(x/(2 * (t-b))) * exp(-a/(4*(t-b))) / sqrt(a * (t-b));

	if t < b
		part2 = 0;
	end

	g = gamma / sqrt(2) * (part1 + part2);

end
