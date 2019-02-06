%% Homework #2
% Problem 1
% Alec Hoyland
% 2019-2-6 13:09

pHeader;
tic

% define constants
n     = 4;
kr1   = 1;
kr2   = 0.8;
s0    = 1;

% transition matrix
A     = [-n*kr1*s0, kr2; n*kr1*s0, -kr2];

%% 1.2 Plot solutions
% For a systems of coupled linear differential equations,
% $$ \dot{v} = \mathrm{A}v $$
% the solution is
% $$ v(t) = v(0) \exp(\mathrm{A}t) $$
% where $$\exp(\mathrm{A}) $$ is defined by the power series expansion.
% $$ \exp(At) = A \sinh(t) + I \cosh(t) $$

% time vector & solution vector
t       = 0:0.02:1;
R       = solution2(A, t, [1e-3; 0]);

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, R);
xlabel('time')
ylabel('concentration')
legend({'R_0', 'R_1'})
axis([0 1 0 1e-3])
prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 1.3 Plot phase diagram

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(R(:, 1), R(:, 2), 'o');
xlabel('concentration R_0')
ylabel('concentration R_1')
axis([-1e-3, 1e-3, -1e-3, 1e-3])
axis square

hold on

xplot = linspace(-1e-3, 1e-3, 2);
[vectors, values] = eig(A);
line(xplot, vectors(2)/vectors(1) * xplot);
line(xplot, vectors(4)/vectors(3) * xplot);

% compute the solution for other initial conditions
initial   = [0.4e-3, 0.2e-3, 0; 0, 0, 0.6e-3];
for ii = 1:3
  R = solution2(A, t, initial(:, ii));
  plot(R(:,1), R(:,2), 'o');
end

legend({'A', 'B', 'C', 'D'})

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 1.6
% The trajectories approach the eigenvectors because the differential equations
% are governed by the transition matrix: $\mathrm{D} \vec{v} = \mathrm{A} \vec{v}$.
% The type of approach is determined by the eigenvector (e.g. the rate and if it spirals).


%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))

function sol = solution(A, t, initial)

  if nargin < 3
    initial = [1, 1]';
  end

  I = eye(length(A));
  sol = zeros(length(A), length(t));

  for ii = 1:length(t)
    sol(:, ii) = (A * sinh(t(ii)) + I * cosh(t(ii))) * initial;
  end

  sol = sol';

end

function sol = solution2(A, t, initial)

  if nargin < 3
    initial = [1, 1]';
  end

  I = eye(length(A));
  sol = zeros(length(A), length(t));
  dt = diff(t);
  dt = dt(1);

  sol(:, 1) = initial;

  for ii = 2:length(t)
    sol(:, ii) = dt * A * sol(:, ii-1) + sol(:, ii-1);
  end

  sol = sol';
end
