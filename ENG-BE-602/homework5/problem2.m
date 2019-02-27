%% Homework #5
% Problem 2
% Alec Hoyland
% 2019-2-27 10:54

pdflib.header;
tic

%% Produce Fourier coefficients

C = zeros(11, 11);
a = 4;
b = 2;
x = 0:0.05:a;
y = 0:0.05:b;

for ii = 1:length(C)
  for qq = 1:length(C)
    C(ii, qq) = 4 / a^2 * (a / (ii*pi)) * sin(ii * pi / 2) * (-b/(qq * pi)) * (cos(2*qq*pi/3) - cos(qq * pi / 3));
  end
end

C(1, 1) = C(1, 1) / 2;

disp('Fourier Coefficients:')
disp(C)

%% Plot a 3-D graph

f = zeros(length(x), length(y));

for ii = 1:length(x)
  for qq = 1:length(y)
    f(ii, qq) = sumFourierSeries(x(ii), y(qq), C, a, b);
  end
end

figure

[X, Y] = meshgrid(x, y);
surf(X, Y, f');

if being_published
  plotlib.snap
  delete(gcf)
end

%% Plot a 2-D graph

figure;
pcolor(X, Y, f')

if being_published
  plotlib.snap
  delete(gcf)
end

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function f = sumFourierSeries(x, y, C, a, b)
  f = 0;
  for ii = 1:length(C)
    for qq = 1:length(C)
      f = f + C(ii, qq) * cos(ii * pi * x / a) * sin(qq * pi * y / a);
    end
  end
end
