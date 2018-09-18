%% Homework #2
% Alec Hoyland
% 15:01 2018-09-18

pHeader;
tic

%% Problem #1
% Using 1-D finite differences to solve the Laplace (heat) equation.
% The pseudo-3-D thermal conductances are computed by
% $G_x = k \frac{h_y h_z}{h_x}$, where $k$ is the thermal conductance, and
% $h$ is the discretization in the subscripted Cartesian direction.
% The discrete form of this problem can be solved by finding the solution to
% $\mathrm{A} \vec{u} = \vec{b}$, where  $\mathrm{A}$ describes the connectivity,
% $\vec{u}$ is the temperature, and $\vec{b}$ the net flux.

% set up the length vector
hx                  = 0.1;    % m
hy                  = 0.01;   % m
hz                  = 0.01;   % m
x                   = 0:hx:1; % m

% thermal conductances
k                   = zeros(size(x)); % W / (m*K)
k(getIndex(x, [0.0 0.4]))     = 27.6; % uranium
k(getIndex(x, [0.4+hx 0.7]))  = 205;  % aluminum
k(getIndex(x, [0.7+hx 1.0]))  = 16;   % stainless steel

% heat transfer coefficients
h                   = 150;    % W / (m^2 * K)

% ambient temperature
Tinf                = 298;    % K
% heat source termperature (for left Dirichlet boundary condition)
Tsource             = 398;    % K

% pseudo-3-D thermal conductances
G                   = k * (hy * hz) / hx;
Ginf                = hy * hz * h;
[~, materials]      = unique(k, 'stable');
material_names      = {'uranium', 'aluminum', 'stainless steel'};
for ii = 1:length(materials)
  disp(['The pseudo-3-D thermal conductance for ' material_names{ii} ' is: ' num2str(G(materials(ii))) ' W/K.'])
end
disp(['The pseudo-3-D thermal conductance for a big-ass fan is: ' num2str(Ginf) ' W/K.'])

% generate the connectivity matrix
A                   = G .* full(gallery('tridiag', length(x), -1, 2, -1));
% enforce Neumann boundary conditions
A(end)              = G(end) + Ginf;
% generate the value vector
b                   = zeros(length(x), 1);
% enforce Dirichlet boundary conditions
b(1)                = G(1) * Tsource;
% enforce Neumann boundary conditions
b(end)              = Ginf * Tinf;

disp('The steady state ''G'' matrix')
disp(A)
disp('The target vector ''b''')
disp(b)

% make the matrices sparse
A = sparse(A);
b = sparse(b);

% solve for the temperature
T = A \ b;
disp('The heat profile ''T''')
disp(T)

% prepend and append boundary conditions
Tfinal            = zeros(length(T)+2,1);
Tfinal(1)         = Tsource;  % Dirichlet boundary conditions
Tfinal(end)       = Tinf;     % Neumann boundary conditions
Tfinal(2:end-1)   = full(T);

disp('The post-processed vector ''T''')
disp(T)

% plot the result
figure('OuterPosition',[0 0 1200 800],'PaperUnits','points','PaperSize',[1200 800]);
plot([-hx x x(end)+hx], Tfinal, 'o')
xlabel('length (m)')
ylabel('temperature (K)')
title('temperature of an anisotropic metal rod')
ylim([288 408])
box off

prettyFig()
if being_published
  snapnow
  delete(gcf)
end


%% Version Info
% The file that generated this document is called:
disp(mfilename)


%%
% and its md5 hash is:
Opt.Input = 'file';
disp(dataHash(strcat(mfilename,'.m'),Opt))


%%
% This file should be in this commit:
[status,m]=unix('git rev-parse HEAD');
if ~status
	disp(m)
end

t = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
