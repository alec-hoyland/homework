%% Homework #3
% Problem 1
% Alec Hoyland
% 2019-4-11 15:31

pdflib.header;
tic

% Part 1

[x, t, u] = hw3prob1([], []);

% plot result

figure;
[X, T] = meshgrid(x, t);
s = pcolor(X, T, u')
set(s, 'FaceColor', 'interp')
set(s, 'EdgeColor', 'none')
c = colorbar;
c.Label.String = 'temperature (C)'
xlabel('distance (nm)')
ylabel('time (us)')
title('FTCS solution')

pdflib.snap
delete(gcf)

% plot steady-state

v0s = [0, 0.2, 1, 6] * 1e7 * 1e-6; % nm / us
t_end = 10;
u_ss = zeros(1e2+1, 4);
lgd = cell(4, 1);

for ii = 1:4
	[x, ~, u] = hw3prob1(t_end, v0s(ii));
	u_ss(:, ii) = u(:, end);
	lgd{ii} = ['v_0 = ' num2str(v0s(ii)) 'nm/us'];
end

figure
plot(x, u_ss)
xlabel('distance (nm)')
ylabel('temperature')
legend(lgd, 'Location', 'best')

pdflib.snap
delete(gcf)

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function [x, t, u] = hw3prob1(t_end, v0)
	% constants
	a = 100; % nm
	b0 = 40; % nm
	epsilon = 10; % nm
	h0 = 3; % mM
	h1 = 0; % mM
	h2 = 5; % mM
	D = 5e-6 * 1e14 * 1e-6; % nm^2/us

	if isempty(v0)
		v0 = 6 * 1e7 * 1e-6; % cm/us
	end

	if isempty(t_end)
		t_end = 1;
	end

	% set up mesh grids
	x = linspace(0, a, 1e2+1); % nm
	t = linspace(0, t_end, 1e4*t_end+1); % us

	dx = x(2);
	dt = t(2);

	% transition matrix

	G0 = D / dx^2;
	Gflow = v0 / dx;

	G = zeros(length(x));
	G(logical(gallery('tridiag', length(G), 1, 0, 0))) = G0;
	G(logical(gallery('tridiag', length(G), 0, 1, 0))) = -2 * G0 + Gflow + 1/dt;
	G(logical(gallery('tridiag', length(G), 0, 0, 1))) = G0 - Gflow;

	b = zeros(length(x), 1);
	b(1) = b(1) + G0 * h1;
	b(end) = b(end) + (G0 - Gflow) * h2;

	% compute initial matrix

	u = zeros(length(x), length(t));
	u(getIndex(x, [b0 - epsilon, b0 + epsilon]), 1) = h0;

	% evolve system with time

	for ii = 2:size(u, 2)
		u(:,ii) = dt * (G * u(:,ii-1) + b);
	end

end
