
% A simple script to visualize how/whether 'characterizelifn' is working

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Neurons

ALPHA = 1.3088;
PHI0 = 1;
J_BIAS = 0.100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Neuron (makelifn)

N = makelifn(ALPHA,PHI0,J_BIAS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Neural "Probe"

Fs = 20000; % sampling frequency
res = 100; % resolution of values implemented in "probing"
minval = -2.0; % minimum considered value
maxval = 2.0; % maximum considered value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Characterize Activation Function (responselifn)

[A_resp X] = responselifn(N,minval,maxval,res);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Characterize Activation Function (characterizedlifn)

A_char = characterizelifn(N,minval,maxval,res,Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualize Neuron Response Functions

figure
plot(X,A_resp,'k','linewidth',2)
hold all
plot(X,A_char,'b--','linewidth',2)
axis([minval maxval 0 900])
xlabel('Stimulus Value','fontsize',18)
ylabel('Firing Rate','fontsize',18)
legend('from ResponseLIFN','from CharacterizeLIFN','fontsize',18,'location','NW')

%eof