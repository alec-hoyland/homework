%% Homework #51
% Problem 1
% Alec Hoyland
% 2019-1-28 13:37

pHeader;
tic

% define constants
E     = 10;
eta   = 1;

% exact solution
% voigt = @(t) 1/(omega^2 + E^2/eta^2) .* exp(E/eta*t) .* (E/eta.*sin(omega*t) - omega*cos(omega*t));

% derivative
xdot = @(x, t, omega) -E/eta*x + 1/eta * sin(omega * t);

dt    = 0.001;
t     = dt:dt:100;
x     = zeros(length(t), 1);
omega = linspace(0, 1e6, 1001);
amplitude = zeros(length(omega), 1);

for omg = 1:length(omega)
  % reset to initial conditions
  x(1) = 0;

  % euler's method numerical integration
  for ii = 2:length(t)
    x(ii) = x(ii-1) + dt * xdot(x(ii-1), t(ii-1), omega(omg));
  end

  % compute the amplitude of the oscillations
  amplitude(omg) = abs(max(x)) + abs(min(x));
end

figure;
loglog(omega, amplitude)
xlabel('frequency of sinusoid forcing term (rad/sec)')
ylabel('amplitude of resultant oscillation (a.u.)')

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
