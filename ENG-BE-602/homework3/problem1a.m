%% Homework #3
% Problem 1a
% Alec Hoyland
% 2019-2-13 12:57

pHeader;
tic

%% 1a Energy and phase plots

% set up meshgrid
x1      = -2:0.05:2;
x2      = -2:0.05:2;
[X, Y]  = meshgrid(x1, x2);

% determine the energy surface
F0      = 0.1;
E       = @(x1, x2) -F0*x1 + 1/2*x1^2 - 1/4*x1^4 + 1/2*x2^2;
Esurf   = zeros(length(x1), length(x2));

for ii = 1:length(x1)
  for qq = 1:length(x2)
    Esurf(ii, qq) = E(x1(ii), x2(qq));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
surfc(X, Y, Esurf);
xlabel('position')
ylabel('velocity')
c = colorbar;
c.Label.String = 'Total Energy';
axis square;

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 1b Energy and phase plots

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
energyContours = [-0.5:0.05:05 06:0.1:2];
[ContourHandle, h] = contour(X, Y, Esurf, energyContours);
CfinalColorbarHandle = colorbar;
axis([-2 2 -2 2])

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 2 Energy and phase plots

% set up meshgrid
x1      = -2:0.05:2;
x2      = -2:0.05:2;
[X, Y]  = meshgrid(x1, x2);

% determine the energy surface
F0      = 0.35;
E       = @(x1, x2) -F0*x1 + 1/2*x1^2 - 1/4*x1^4 + 1/2*x2^2;
Esurf   = zeros(length(x1), length(x2));

for ii = 1:length(x1)
  for qq = 1:length(x2)
    Esurf(ii, qq) = E(x1(ii), x2(qq));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
energyContours = [-0.5:0.05:05 06:0.1:2];
[ContourHandle, h] = contour(X, Y, Esurf, energyContours);
CfinalColorbarHandle = colorbar;
axis([-2 2 -2 2])

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 3 Energy and phase plots

% set up meshgrid
x1      = -2:0.05:2;
x2      = -2:0.05:2;
[X, Y]  = meshgrid(x1, x2);

% determine the energy surface
F0      = 0.4;
E       = @(x1, x2) -F0*x1 + 1/2*x1^2 - 1/4*x1^4 + 1/2*x2^2;
Esurf   = zeros(length(x1), length(x2));

for ii = 1:length(x1)
  for qq = 1:length(x2)
    Esurf(ii, qq) = E(x1(ii), x2(qq));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
energyContours = [-0.5:0.05:05 06:0.1:2];
[ContourHandle, h] = contour(X, Y, Esurf, energyContours);
CfinalColorbarHandle = colorbar;
axis([-2 2 -2 2])

prettyFig

if being_published
  snapnow
  delete(gcf)
end

%% 4 Energy and phase plots

% set up meshgrid
x1      = -2:0.05:2;
x2      = -2:0.05:2;
[X, Y]  = meshgrid(x1, x2);

% determine the energy surface
F0      = 0.75;
E       = @(x1, x2) -F0*x1 + 1/2*x1^2 - 1/4*x1^4 + 1/2*x2^2;
Esurf   = zeros(length(x1), length(x2));

for ii = 1:length(x1)
  for qq = 1:length(x2)
    Esurf(ii, qq) = E(x1(ii), x2(qq));
  end
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
energyContours = [-0.5:0.05:05 06:0.1:2];
[ContourHandle, h] = contour(X, Y, Esurf, energyContours);
CfinalColorbarHandle = colorbar;
axis([-2 2 -2 2])

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
