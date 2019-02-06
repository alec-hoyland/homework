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
A     = [0, 0, 1, 0, ...
         0, 0, 0, 1, ...
         -(k(1) + k(2))/m(1), k(2)/m(1), -(b(1) + b(2))/m(1), b(2)/m(1), ...
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

prettyFig()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.1 Time Series

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(t, y);
xlabel('time')
ylabel('displacement')
legend({'x_1', 'x_2'})

prettyFig()

if being_published
    snapnow
    delete(gcf)
end

%% 2a.1 Explanation
% There are no dissipative forces -- all energy is conserved. It is possible to
% write a Hamiltonian for this system

%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
