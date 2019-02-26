%% Homework #2
% Problem 2
% Alec Hoyland
% 2019-2-6 16:19

%%
pHeader;
tic

%% 2a.1

% constants
m     = [1, 1];
k     = [1, 2, 1];
b     = [0, 1, 0];

% construct the transition matrix
A     = [0, 0, 1, 0; ...
         0, 0, 0, 1; ...
         -(k(1) + k(2))/m(1), k(2)/m(1), -(b(1) + b(2))/m(1), b(2)/m(1); ...
         k(2)/m(2), -(k(2) + k(3))/m(2), b(2)/m(2), -(b(2) + b(3))/m(2)];

% define function for ode solver
odefun = @(t, y) A * y;

% initial conditions
init  = [1, 0, 0, 0];

% time
tspan = [0, 20*pi];

% solve using RK4 with Dormand-Prince correction
[t, y] = ode45(odefun, tspan, init);

%% 2a.1 Phase Portrait

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(y(:, 1), y(:, 2), 'o');
xlabel('x_1')
ylabel('x_2')
axis([-1 1 -1 1])
axis square

figlib.pretty()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.1 Time Series

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y(:, 1:2));
xlabel('time')
ylabel('displacement')
legend({'x_1', 'x_2'})

figlib.pretty()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.1 Explanation
% There are no dissipative forces -- all energy is conserved. It is possible to
% write a Hamiltonian for this system

%% 2a.2

% constants
m     = [1, 1];
k     = [1, 2, 1];
b     = [0, 20, 0];

% construct the transition matrix
A     = [0, 0, 1, 0; ...
         0, 0, 0, 1; ...
         -(k(1) + k(2))/m(1), k(2)/m(1), -(b(1) + b(2))/m(1), b(2)/m(1); ...
         k(2)/m(2), -(k(2) + k(3))/m(2), b(2)/m(2), -(b(2) + b(3))/m(2)];

% define function for ode solver
odefun = @(t, y) A * y;

% initial conditions
init  = [1, 0, 0, 0];

% time
tspan = [0, 20*pi];

% solve using RK4 with Dormand-Prince correction
[t, y] = ode45(odefun, tspan, init);

%% 2a.2 Phase Portrait

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(y(:, 1), y(:, 2), 'o');
xlabel('x_1')
ylabel('x_2')
axis([-1 1 -1 1])
axis square

figlib.pretty()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.2 Time Series

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y(:, 1:2));
xlabel('time')
ylabel('displacement')
legend({'x_1', 'x_2'})

figlib.pretty()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.2 Explanation
% The stiffness increases the time it takes to reach steady-state. A greater proportion
% of the energy is tied up in the potential of the dashpot initially, though both reach
% the same amplitude of oscillations at steady-state.

%% 2b.1

% constants
m     = [1, 1];
k     = [1, 2, 1];
b     = [2, 20, 0];

% construct the transition matrix
A     = [0, 0, 1, 0; ...
         0, 0, 0, 1; ...
         -(k(1) + k(2))/m(1), k(2)/m(1), -(b(1) + b(2))/m(1), b(2)/m(1); ...
         k(2)/m(2), -(k(2) + k(3))/m(2), b(2)/m(2), -(b(2) + b(3))/m(2)];

% define function for ode solver
odefun = @(t, y) A * y;

% initial conditions
init  = [1, 0, 0, 0];

% time
tspan = [0, 20*pi];

% solve using RK4 with Dormand-Prince correction
[t, y] = ode45(odefun, tspan, init);

%% 2b.1 Phase Portrait

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(y(:, 1), y(:, 2), 'o');
xlabel('x_1')
ylabel('x_2')
axis([-1 1 -1 1])
axis square

figlib.pretty()

if being_published
 snapnow
 delete(gcf)
end

%% 2b.1 Time Series

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y(:, 1:2));
xlabel('time')
ylabel('displacement')
legend({'x_1', 'x_2'})

figlib.pretty()

if being_published
 snapnow
 delete(gcf)
end

%% 2b.2 Explanation
% The second dashpot makes the system asymmetric and overdamped, causing no oscillations.
% Instead, the two masses move to a steady-state equilibrium condition.

%% 2b.2

% constants
m     = [1, 1];
k     = [1, 2, 1];
b     = [2, 20, 0];

% construct the transition matrix
A     = [0, 0, 1, 0; ...
         0, 0, 0, 1; ...
         -(k(1) + k(2))/m(1), k(2)/m(1), -(b(1) + b(2))/m(1), b(2)/m(1); ...
         k(2)/m(2), -(k(2) + k(3))/m(2), b(2)/m(2), -(b(2) + b(3))/m(2)];

% define function for ode solver
% non-homeogeneous -- forcing into f_2(t)
odefun = @(t, y) A * y + [0; 0; 0; -1];

% initial conditions
init  = [1, 0, 0, 0];

% time
tspan = [0, 20*pi];

% solve using RK4 with Dormand-Prince correction
[t, y] = ode45(odefun, tspan, init);

%% 2b.2 Phase Portrait

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(y(:, 1), y(:, 2), 'o');
xlabel('x_1')
ylabel('x_2')
axis([-1 1 -1 1])
axis square

figlib.pretty()

if being_published
 snapnow
 delete(gcf)
end

%% 2b.2 Time Series

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y(:, 1:2));
xlabel('time')
ylabel('displacement')
legend({'x_1', 'x_2'})

figlib.pretty()

if being_published
 snapnow
 delete(gcf)
end

%% 2b.2 Explanation
% The masses would move to equal equilibrium conditions, except that one
% is being forced, causing it to reach equilibrium at a lower value (the forcing is negative).

%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
