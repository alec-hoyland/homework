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
box off

prettyFig()
if being_published
  snapnow
  delete(gcf)
end

%% Problem #2

% finite-difference simulation grids
hx      = 5;    % um
hy      = 5;    % um
hz      = 35;   % um
a       = 40;   % um
b       = 35;   % um
x       = 0:hx:a;
y       = 0:hy:b;

% diffusion coefficients
Dcell   = 100;  % um^2/s
Dout    = 800;  % um^2/s

% ambient concentration
Cinf    = 0;    % M
gamma   = 40;   % um/s

% conductances
Gcell   = Dcell * hz;
Gout    = Dout * hz;
Ginfx   = gamma * hy * hz;
Ginfy   = gamma * hx * hz;

disp('The intracellular conductance is')
disp(Gcell)
disp('The extracellular conductance is')
disp(Gout)
disp('The y-face convection conductance is')
disp(Ginfy)
disp('Units are cubic microns per second')

% set up the matrices
G       = zeros(49, 49);
% c1 & c7
for ii = [1, 7]
  row         = zeros(1, 49);
  row(ii+7)   = Gout;
  if mod(ii, 7) == 0
    row(ii-1) = Gout;
  else
    row(ii+1) = Gout;
  end
  row(ii)     = -2 * Gout;
end
% row 1 edges
for ii = 2:6
  row       = zeros(1,49);
  row(ii-1) = Gout;
  row(ii)   = -3 * Gout;
  row(ii+1) = Gout;
  row(ii+7) = Gout;
  G(ii, :)  = row;
end
% c8 & c14
for ii = [8, 14]
  row         = zeros(1, 49);
  row(ii-7)   = Gout;
  row(ii+7)   = Gout;
  if mod(ii, 7) == 0
    row(ii-1) = Gout;
  else
    row(ii+1) = Gout;
  end
  row(ii)     = -3 * Gout;
  G(ii, :)    = row;
end
% row 2, 3, 4, 5, 6 internal
for ii = [9:13 18 23 27 30:34 37:41]
  row       = zeros(1,49);
  if ii > 29
    Gtemp = Gcell;
  else
    Gtemp = Gout;
  end
  row(ii-1) = Gtemp;
  row(ii)   = -4 * Gtemp;
  row(ii+1) = Gtemp;
  row(ii-7) = Gtemp;
  row(ii+7) = Gtemp;
  G(ii, :)  = row;
end
% columns 1 & 7 edges
for ii = [22:7:43 28:7:49]
  row       = zeros(1, 49);
  row(ii-7) = 1/2 * Gcell;
  row(ii+7) = 1/2 * Gcell;
  if mod(ii, 7) == 0
    row(ii-1) = Gcell;
  else
    row(ii+1) = Gcell;
  end
  row(ii)   = -sum(row) - Ginfx;
  G(ii, :)  = row;
end
% c15 & c21
for ii = [15, 21]
  row       = zeros(1, 49);
  row(ii-7) = Gout;
  row(ii+7) = 1/2 * Gcell;
  if mod(ii, 7) == 0
    row(ii-1) = 1/2 * (Gout + Gcell);
  else
    row(ii+1) = 1/2 * (Gout + Gcell);
  end
  row(ii)   = -sum(row);
  G(ii, :)  = row;
end
% c16 & c20
for ii = [16, 20]
  row       = row(1, 49);
  row(ii-7) = Gout;
  row(ii+7) = Gcell;
  row(ii-1) = 1/2 * (Gout + Gcell);
  row(ii+1) = 1/2 * (Gout + Gcell);
  row(ii)   = -sum(row);
  G(ii, :)  = row;
end
% c17
row       = zeros(1, 49);
row(17-7) = Gout;
row(17+7) = 1/2 * (Gout + Gcell);
row(17-1) = 1/2 * (Gout + Gcell);
row(17+1) = Gout;
row(17)   = -sum(row);
G(17, :)  = row;
% c19
row       = zeros(1, 49);
row(19-7) = Gout;
row(19+7) = 1/2 * (Gout + Gcell);
row(19+1) = 1/2 * (Gout + Gcell);
row(19-1) = Gout;
row(19)   = -sum(row);
G(19, :)  = row;
% c24
row       = zeros(1, 49);
row(24-7) = 1/2 * (Gout + Gcell);
row(24+7) = Gcell;
row(24-1) = Gcell;
row(24+1) = 1/2 * (Gout + Gcell);
row(24)   = -sum(row);
G(24, :)  = row;
% c25
row       = zeros(1, 49);
row(25-7) = Gout;
row(25+7) = Gcell;
row(25-1) = 1/2 * (Gout + Gcell);
row(25+1) = 1/2 * (Gout + Gcell);
row(25)   = -sum(row);
G(25, :)  = row;
% c26
row       = zeros(1, 49);
row(26-7) = 1/2 * (Gout + Gcell);
row(26+7) = Gcell;
row(26+1) = Gcell;
row(26-1) = 1/2 * (Gout + Gcell);
row(26)   = -sum(row);
G(26, :)  = row;
% row 7 edges
for ii = 44:48
  row         = zeros(1, 49);
  row(ii-7)   = Gcell;
  row(ii-1)   = 1/2 * Gcell;
  row(ii+1)   = 1/2 * Gcell;
  row(ii)     = -sum(row) - Ginfy;
  G(ii, :)    = row;
end
% c44
row         = zeros(1, 49);
row(44-7)   = 1/2 * Gcell;
row(44+1)   = 1/2 * Gcell;
row(44)     = -sum(row) - 1/2 * (Ginfx + Ginfy);
G(44, :)    = row;
% c49
row         = zeros(1, 49);
row(44-7)   = 1/2 * Gcell;
row(44-1)   = 1/2 * Gcell;
row(44)     = -sum(row) - 1/2 * (Ginfx + Ginfy);
G(44, :)    = row;


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
