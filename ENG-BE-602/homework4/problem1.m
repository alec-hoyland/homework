%% Homework #4
% Problem 1a
% Alec Hoyland
% 2019-2-20 13:26

pHeader;
tic

%% Vary the gain variable 'c'

p = struct;
p.a = 0.7;
p.b = 0.8;
p.c = 0;

tspan = 0:0.1:60;
initial = [2; -1];

z = -0.4 * ones(1, length(tspan));

c = [1, 1.9, 2];
x1 = zeros(length(tspan), length(c));
x2 = zeros(length(tspan), length(c));
l  = linspecer(length(c));
leg = cell(length(c), 1);

for ii = 1:length(c)
  p.c = c(ii);
  [t, x] = ode45(@(t, x) odefun(t, x, p, tspan, z), tspan, initial);
  x1(:, ii) = x(:, 1);
  x2(:, ii) = x(:, 2);
  leg{ii} = ['c = ' num2str(c(ii))];
end

%% Hopf bifurcation when c > 1.9

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
for ii = 1:size(x1, 2)
  plot(t, x1(:, ii), 'Color', l(ii, :))
end

xlabel('time (s)')
ylabel('membrane potential (mV)')
title('varying the gain parameter: trajectory')
legend(leg, 'Location', 'best')

figlib.pretty('lw', 1)

if being_published
  snapnow
  delete(gcf)
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
for ii = 1:size(x1, 2)
  plot(x1(:,ii), x2(:,ii), 'o', 'Color', l(ii, :))
end

xlabel('x')
ylabel('y')
title('varying the gain parameter: phase')
legend(leg, 'Location', 'best')

axis square
axis([-2.5 2.5 -2.5 2.5])

figlib.pretty

if being_published
  snapnow
  delete(gcf)
end

%% Varying the input function

p = struct;
p.a = 0.7;
p.b = 0.8;
p.c = 3;

dt = 0.01;
t = 0:dt:60;
initial = [2, -1];

z = -0.4 * ones(1, length(t));
z(22/0.1:40/0.1) = 0;

x = zeros(length(t), 2);
x(1, :) = initial;

dxdt1 = @(x, z) c * (x(2) + x(1) - 1/3 .* x(1)^3 + z);
dxdt2 = @(x) - 1/c * (x(1) -a + b*x(2));

for ii = 2:length(t)
  [dxdt, dydt] = odefun2(x(ii-1, :), z(ii-1), p);
  x(ii, 1) = x(ii-1, 1) + dt * dxdt;
  x(ii, 2) = x(ii-1, 2) + dt * dydt;
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x(:,1), x(:,2), 'o')

xlabel('x')
ylabel('y')
title('varying the input function: phase')
axis square
axis([-2.5 2.5 -2.5 2.5])

figlib.pretty

if being_published
  snapnow
  delete(gcf)
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, x(:,1))

xlabel('time (s)')
ylabel('membrane potential(V)')
title('varying the input function: trajectory')

figlib.pretty()

if being_published
  snapnow
  delete(gcf)
end

%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))

function dxdt = odefun(t, x, params, zt, z)
  dxdt = zeros(2, 1);
  v = struct2vec(params);
  z = interp1(zt, z, t);
  a = v(1);
  b = v(2);
  c = v(3);
  dxdt(1) = c * (x(2) + x(1) - 1/3 * x(1)^3 + z);
  dxdt(2) = - 1/c * (x(1) -a + b*x(2));
end

function [dxdt, dydt] = odefun2(x, z, params)
  v = struct2vec(params);
  a = v(1);
  b = v(2);
  c = v(3);

  dxdt = c * (x(2) + x(1) - 1/3 * x(1)^3 + z);
  dydt = - 1/c * (x(1) -a + b*x(2));
end
