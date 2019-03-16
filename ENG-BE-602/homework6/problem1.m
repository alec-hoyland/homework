%% Homework #6
% Problem 1
% Alec Hoyland
% 2019-3-16 10:53

pdflib.header;
tic

%% Coefficients of the Fourier-Legendre Series
% The definite integral $\int_0^{2\pi} \cos^n \mathrm{d}x$ is nonzero only if
% $n$ is even. Therefore, since $h(\phi) = \cos^2(\phi)$, $m$ must be even.
% If $m=0$ the first integral is $\pi$. If $m=2$, the first integral is $\pi/2$.
% We can eliminate any cofficients where $l < 2$ since $m = 2$. This condition
% is enforced by the Dirichlet boundary conditions and properties of the
% associated Legendre polynomials.

%% Compute the Fourier-Legendre Coefficients

C = zeros(7, 3); % l, m, indexed starting at 0

% TODO: plug in the C values by hand

%% Plot the spherical surface


% define Cartesian coordinates
dx = 0.1;
x = -1:dx:1;
y = x;
z = x;
[X, Y, Z] = meshgrid(x,y,z);

% compute spherical coordinates
r = sqrt(X.^2 + Y.^2 + Z.^2);
theta = acos(Z ./ r);
phi = atan2(Y, X);

% build temperature profile
T = zeros(size(r));
for ii = 1:numel(T)
  temp = 0;
  for l = 1:size(C, 1)
    for m = 1:size(C, 2)
      lgdr = legendre(l, cos(theta(ii)));
      temp = temp + C(l, m) * (1 / (r(ii)^(l +1))) * cos(m * phi(ii)) * lgdr(m);
    end
  end
  T(ii) = temp;
end

% create spherical coordinates
[SX, SY, SZ] = sphere(360);
[SX2, SY2, SZ2] = sphere(60);

figure;
slicehandle = slice(X, Y, Z, T, SX, SY, SZ);
title('spherical coordinate plot of temperature at r=1')
xlabel('x')
ylabel('y')
zlabel('z')
colorbarhandle = colorbar;
c.Label.String = 'Temperature (C)';
caxis([-60, 60])

pdflib.snap
delete(gcf)


figure;
slicehandle1 = slice(X, Y, Z, T, 0, 0, 0); hold on;
set(slicehandle1, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
slicehandle2 = slice(X, Y, Z, T, SX, SY, SZ);
set(slicehandle, 'EdgeColor', 'none');
slicehandle3 = slice(X, Y, Z, T, SX2, SY2, SZ2);
set(slicehandle3, 'EdgeColor', 'black', 'FaceColor', 'none');
title('spherical coordinate plot of temperature at r=1')
xlabel('x')
ylabel('y')
zlabel('z')
colorbarhandle = colorbar;
c.Label.String = 'Temperature (C)';
caxis([-60, 60])

pdflib.snap
delete(gcf)



% compute f(r, theta, phi) at r=1, phi = 0
f = zeros(length(x), 1);
for ii = 1:length(x)
  temp = 0;
  for l = 1:size(C, 1)
    for m = 1:size(C, 2)
      lgdr = legendre(l, cos(x(ii));
      temp = temp + C(l, m) * lgdr(m);
    end
  end
  f(ii) = temp;
end

figure;
plot(x, cos(x).^2);
hold on
plot(x, f(ii))
title('temperature profile at \phi = 0')
xlabel('\theta')
ylabel('h(\theta)')
legend({'theoretical', 'approximation'})

pdflib.snap
delete(gcf)

%% Temperature outside the planet

% define Cartesian coordinates
dx = 0.1;
x = -3:dx:3;
y = x;
z = x;
[X, Y, Z] = meshgrid(x,y,z);

% compute spherical coordinates
r = sqrt(X.^2 + Y.^2 + Z.^2);
theta = acos(Z ./ r);
phi = atan2(Y, X);

% build temperature profile
T = zeros(size(r));
for ii = 1:numel(T)
  temp = 0;
  for l = 1:size(C, 1)
    for m = 1:size(C, 2)
      lgdr = legendre(l, cos(theta(ii)));
      temp = temp + C(l, m) * (1 / (r(ii)^(l +1))) * cos(m * phi(ii)) * lgdr(m);
    end
  end
  T(ii) = temp;
end

figure;
slicehandle1 = slice(X, Y, Z, T, 0, 0, 0); hold on;
set(slicehandle1, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
slicehandle2 = slice(X, Y, Z, T, SX, SY, SZ);
set(slicehandle, 'EdgeColor', 'none');
slicehandle3 = slice(X, Y, Z, T, SX2, SY2, SZ2);
set(slicehandle3, 'EdgeColor', 'black', 'FaceColor', 'none');
title('spherical coordinate plot of temperature at r=1')
xlabel('x')
ylabel('y')
zlabel('z')
colorbarhandle = colorbar;
c.Label.String = 'Temperature (C)';
caxis([-60, 60])

pdflib.snap
delete(gcf)

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
