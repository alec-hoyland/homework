%% Homework #4
% Problem 1
% Alec Hoyland
% 2019-4-24 17:17

pdflib.header;
tic

ra = 2e6;
rm = 10e3;
Cm = 150e-9;
D = 1 / (ra * Cm);
B = 1 / (rm * Cm);

b = 1;

a = 2.5;
tfinal = 5e-3;
dx = a/1000;
dt = tfinal/100;

x = -a:dt:a;
t = dt:dt:tfinal;

% compute h times g and integrate over it
dummyindex = linspace(-1, 1, 11);
integrand = zeros(length(x), length(t), length(dummyindex));
V = zeros(length(x), length(t));
count = 0;
total = length(x) * length(t) * length(dummyindex);
for xx = 1:length(x)
	corelib.textbar(count, total);
	for tt = 1:length(t)
		for bb = 1:length(dummyindex)
			integrand(xx, tt, bb) = get_h(dummyindex(bb), 1) * green(x(xx), t(tt), dummyindex(bb), D, B);
			count = count + 1;
		end
		V(xx, tt) = trapz(dummyindex, integrand(xx, tt, :));
	end
end

%% Plot

figure;
[X, T] = meshgrid(x, t);
surf(X, T, V);
xlabel('distance (cm)')
ylabel('time (s)')
zlabel('membrane potential (mV)')
title('solution with double pulse IC')

pdflib.snap
delete(gcf)

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function hval = get_h(x, b)
	hval = zeros(length(x),1);
	hval(-b < x | x < 0) = -1;
	hval(0 < x | x < b) = 1;
end

function g = green(x, t, b, D, B)
	g = sqrt(pi) ./ sqrt(D) ./ sqrt(t) .* exp(-((x + 2 .* pi .* b).^2 - 4 .* B .* D .* t.^2) ./ (4 .* D .* t));
end
