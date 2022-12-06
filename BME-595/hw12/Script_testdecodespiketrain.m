
% A simple script to visualize how/whether 'decodespiketrain' is working

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General Simulation Parameters

Fs = 10000;
nsamp = 4000;
t = linspace(0,2,nsamp)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Neuron (makelifn)

N = makelifn(1,1,0.2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Time-Varying Stimulus

X = -0.2*cos(2*pi*t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate Dynamic Neuron (updatelifn)

D = zeros(nsamp,1); % This vector will hold a spike train

for ktor = 1:nsamp
    N = updatelifn(X(ktor),N,Fs); % Call the function 'updatelifn'
    D(ktor) = (N.V==1); % Record the presence of any spike
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtain Temporal Activation Function (decodespiketrain)

x_hat_j = decodespiketrain(N,0.1*D,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualize Stimulus, Spike Train & Temp Activ Fn

figure
plot(t,X,'k','linewidth',2)
hold all
plot(t,D,'r')
plot(t,x_hat_j(1:length(X)),'b','linewidth',2)
xlabel('Time (sec)','fontsize',18)
ylabel('Stimulus/Voltage','fontsize',18)

%eof