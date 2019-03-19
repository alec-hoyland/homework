%% Homework #7
% Problem 1
% Alec Hoyland
% 2019-3-16 13:52

pdflib.header;
tic

%% Boundary Conditions
% $u \rightarrow 0$ as $z \rightarrow \infty$. $u = 0$ at $r = b= 10, z \neq 0$. Finally, at $z=0, r=b$,
% $u(r,\phi,0) = 50 - 0.004r^4 \cos(2\phi) - 0.015r^3\sin(\phi)$.
%
% $C_{m,p} = \frac{2}{\pi b^2[J_{m+1}(k_{m,p}b)]^2} \int_0^{2\pi} h_{cos}(\phi) cos(m\phi) d\phi$.
% For $D_{n,q}$ it's the same but with $\sin$ replacing $\cos$. For $m = 0$, divide by a factor of 2.
%
% Let $g_{cos}(r) = -0.004r^4$ and $h_{cos}(\phi) = cos(2\phi)$ and

% get Bessel function roots
broots = zeros(4,3); % indexed by m and p where m starts at 0
broots(1,1) = 2.40482555769577; % m = 0
broots(1,2) = 5.52007811028631;
broots(1,3) = 8.65372791291101;
broots(2,1) = 3.83170597020751; % m = 1
broots(2,2) = 7.01558666981561;
broots(2,3) = 10.1734681350627;
broots(3,1) = 5.13562230184068; % m = 2
broots(3,2) = 8.41724414039986;
broots(3,3) = 11.6198411721490;
broots(4,1) = 6.38016189592398; % m = 3
broots(4,1) = 9.76102312998166;
broots(4,1) = 13.0152007216984;

%% Get cosine coefficients

trig = @(x) -0.004 * x^3;
b = 10;

m = [0, 2] + 1; % matlab 1-indexing correction
p = [1, 2, 3];

C = getCoeff(broots, m, p, b, trig)

%% Get sine coefficients

trig = @(x) -0.015 * x^3;
b = 10;

n = [1] + 1; % matlab 1-indexing correction
q = [1, 2, 3];

D = getCoeff(broots, n, q, b, trig)

%% Construct the Fourier-Bessel series

x = 0:0.1:1;
r = b*x;
z = x;
phi = 2*pi*x;

u = zeros(length(r), length(phi), length(z));

for rr = 1:length(r)
    for zz = 1:length(z)
        for phiphi = 1:length(phi)
            for mm = 1:length(m)
                m0 = mm - 1;
                for pp = 1:length(p)
                    u(rr, phiphi, zz) = u(rr, phiphi, zz) + C(mm, pp) * ...
                    besselj(m0, broots(mm, pp)/b * r(rr)) * cos(m0 * phi(phiphi)) * ...
                    exp(-broots(mm, pp) * z(zz));
                end
            end
            for nn = 1:length(n)
                n0 = nn - 1;
                for qq = 1:length(q)
                    u(rr, phiphi, zz) = u(rr, phiphi, zz) + D(nn, qq) * ...
                    besselj(n0, broots(nn, qq)/b * r(rr)) * cos(n0 * phi(phiphi)) * ...
                    exp(-broots(nn, qq) * z(zz));
                end
            end
        end
    end
end

%% Plot the Fourier-Bessel series

x = 2*r;
y = 2*r;
z = z;

[X, Y, Z] = meshgrid(x, y, z);
R = sqrt(X.^2, Y.^2, Z.^2);
Phi = atan2(Y, X);

[cxx, cyy, czz] = cylinder(10, 60);

figure;
slicehandle1 = slice(X, Y, Z, u, cxx, cyy, czz);
set(slicehandle1, 'EdgeColor', 'Black')
set(slicehandle1, 'FaceAlpha', 0.9);
hold on
slicehandle2 = slice(X, Y, Z, u, cxx, pi/2, czz)
xlabel('x')
ylabel('y')
zlabel('z')

clrb = colorbar
caxis([0 100])
clrb.Label.String('temp')

pdflib.snap
delete(gcf)

figure
plot(r, u(:, 1, 1));
xlabel('radius')
ylabel('temperature')
title('z-0, \phi = 0')

pdflib.snap
delete(gcf)

figure
plot(r, u(:, 1, round(length(phi)/4)));
xlabel('radius')
ylabel('temperature')
title('z-0, \phi = \pi/2')

pdflib.snap
delete(gcf)


%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function C = getCoeff(broots, m, p, b, trig)
    % computes coefficients for a Fourier-Bessel double series

    C = zeros(max(m), max(p));

    for mm = m
        bessel_m = mm - 1;
        for pp = p
            prefactor = 2 / (b^2 * besselj(bessel_m+1, broots(mm))^2);
            fun = @(x) x * trig(x) * besselj(bessel_m, broots(mm)/b*x);
            C(mm, pp) = prefactor * integrate(fun, 0, b);
        end
    end

end
