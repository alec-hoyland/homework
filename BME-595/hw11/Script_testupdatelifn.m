
% A simple script to visualize how/whether 'updatelifn' is working

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter of the neuron
alpha = 0.1;
phi = 1.0;
J_bias = 0.5;

% Parameters of the tuning function
minval = -5;
maxval = +5;
res = 100;

% General Simulation Parameters
Fs = 16000;
nsamp = 400;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make a neuron
N = makelifn(alpha,phi,J_bias);

% % Calculate tuning function
% [A X] = responselifn(N,minval,maxval,res);

% % Plot the tuning function
% figure
% plot(X,A,'linewidth',2)
% xlabel('Stimulus Value','fontsize',18)
% ylabel('Firing Rate','fontsize',18)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = -1; % Ideally, this value is between minval and maxval.
        % I recommend trying -4 and 2, for contrast in visualization.

V = zeros(nsamp,1); % This vector will hold membrane voltages 
                    % throughout the simulation

for ktor = 1:nsamp
    N = updatelifn(x,N,Fs); % Call the function 'updatelifn'
    V(ktor) = N.V; % Record the membrane voltage of the neuron
end

% Plot the membrane voltage as a fuction of sample number
figure
plot(V,'linewidth',2)
xlabel('Sample','fontsize',18)
ylabel('Membrane Voltage','fontsize',18)

%eof