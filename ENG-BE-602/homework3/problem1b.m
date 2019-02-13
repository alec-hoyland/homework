%% Homework #3
% Problem 1b
% Alec Hoyland
% 2019-2-13 13:25

pHeader;
tic

%% 1a Looking at fixed points

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
F0    = [0.1, 0.35, 0.4, 0.75];
x     = linspace(-0.5, 0.5, 21);
C     = linspecer(length(F0));
leg   = cell(length(F0), 1);
for ii = 1:length(F0)
  f = @(x) F0(ii) - x + x.^3;
  plot(x, f(x), 'Color', C(ii, :))
  leg{ii} = ['F_0 = ' num2str(F0(ii))];
end

legend(leg);

prettyFig()

if being_published
  snapnow
  delete(gcf)
end

%% 1b Looking at fixed points
% The fixed points are located at $x_2^{*} = 0$ and $x_1^{*} = \mathrm{roots}(F_0 - x_1 + x_1^3)$.

for ii = 1:length(F0)
  disp(['For F_0 = ' num2str(F0(ii)) ', the fixed points lie on the x_2 = 0 line and'])
  disp(['x_1 = ' mat2str(roots([1 0 -1 F0(ii)]))]);
end

%% 2 Phase Plots F0 = 0.1

t     = 0:0.1:9;
F0    = 0.1;
initial = [1 0.9 0.9 0.9 0.9 0.65 0.5 -0.9; 0 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1];
C     = linspecer(size(initial, 2));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

for ii = 1:size(initial, 2)
  [t,x] = ode45(@(t, y) odefun(t, y, F0), t, initial(:, ii));
  plot(x(:,1), x(:,2), 'o', 'Color', C(ii, :))
end

xlabel('position')
ylabel('velocity')
axis([-2 2 -2 2])
axis square;

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 2 Phase Plots F0 = 0.38

t     = 0:0.1:9;
F0    = 0.38;
initial = [1 0.9 0.9 0.9 0.9 0.65 0.5 -0.9; 0 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1];
C     = linspecer(size(initial, 2));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

for ii = 1:size(initial, 2)
  [t,x] = ode45(@(t, y) odefun(t, y, F0), t, initial(:, ii));
  plot(x(:,1), x(:,2), 'o', 'Color', C(ii, :))
end

xlabel('position')
ylabel('velocity')
axis([-2 2 -2 2])
axis square;

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 2 Phase Plots F0 = 0.4

t     = 0:0.1:9;
F0    = 0.4;
initial = [1 0.9 0.9 0.9 0.9 0.65 0.5 -0.9; 0 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1];
C     = linspecer(size(initial, 2));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

for ii = 1:size(initial, 2)
  [t,x] = ode45(@(t, y) odefun(t, y, F0), t, initial(:, ii));
  plot(x(:,1), x(:,2), 'o', 'Color', C(ii, :))
end

xlabel('position')
ylabel('velocity')
axis([-2 2 -2 2])
axis square;

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 2 Phase Plots F0 = 0.75

t     = 0:0.1:9;
F0    = 0.75;
initial = [1 0.9 0.9 0.9 0.9 0.65 0.5 -0.9; 0 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1];
C     = linspecer(size(initial, 2));

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on

for ii = 1:size(initial, 2)
  [t,x] = ode45(@(t, y) odefun(t, y, F0), t, initial(:, ii));
  plot(x(:,1), x(:,2), 'o', 'Color', C(ii, :))
end

xlabel('position')
ylabel('velocity')
axis([-2 2 -2 2])
axis square;

prettyFig

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

function dxdt = odefun(t, x, F0)
  dxdt = zeros(2, 1);
  dxdt(1) = x(2);
  dxdt(2) = F0 - x(1) + x(1)^3;
end
