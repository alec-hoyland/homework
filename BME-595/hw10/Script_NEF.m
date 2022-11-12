
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1/4: Generating a Population of Neurons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Neurons

ALPHA = [0.3088 0.4297 0.4027 0.2884 0.0915];
PHI0 = [1 1 1 1 1];
J_BIAS = [0.1200 0.4433 0.0143 0.2450 0.0840];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Neurons - Neurogenesis?!? (makelifn)

N1 = % <your code here: create neuron #1>
N2 = % <your code here: create neuron #2>
N3 = % <your code here: create neuron #3>
N4 = % <your code here: create neuron #4>
N5 = % <your code here: create neuron #5>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2/4: Encoding with a Population of Neurons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record Physical Value (or, in this case, generate a random value)

x = rand(1,1); % "stimulus recording"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encode Physical Value Into Spike Rates (ratelifn)

a1 = % <your code here: record spiking rate - neuron #1>
a2 = % <your code here: record spiking rate - neuron #2>
a3 = % <your code here: record spiking rate - neuron #3>
a4 = % <your code here: record spiking rate - neuron #4>
a5 = % <your code here: record spiking rate - neuron #5>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3/4: Probe & Determine Decoders For a Population of Neurons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Neural "Probe"

res = 100; % resolution of values implemented in "probing"
minval = 0.0; % minimum considered value
maxval = 1.0; % maximum considered value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Characterize Activation Functions of Population (responselifn)

[A1 X] = % <your code here: characterize spiking behavior - neuron #1>
[A2 X] = % <your code here: characterize spiking behavior - neuron #2>
[A3 X] = % <your code here: characterize spiking behavior - neuron #3>
[A4 X] = % <your code here: characterize spiking behavior - neuron #4>
[A5 X] = % <your code here: characterize spiking behavior - neuron #5>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compile activation functions into a single matrix
%   appropriate as input to 'determinedecoders'

A = % <your code here: compile activation functions of all neurons>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Decoders for Population (determinedecoders)

PHI = % <your code here: determine decoders for neural population>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualize Neuron Response Functions

figure
plot(X,A,'k','linewidth',2)
axis([minval maxval 0 600])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 4/4: Decode Value Encoded By the Neural Population

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compile recorded spiking rates (above) into a vector
%   appropriate as input to 'decodespikerate'

Ax = % <your code here: compile recorded spiking rates of all neurons>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode Recorded Spike Rates (decodespikerate)

x_hat = % <your code here: decode the encoded value>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print Results of Decoding

fprintf('The recorded physical value was: %5.4f\n',x)
fprintf('The decoded estimate of that value is: %5.4f\n',x_hat)

%eof