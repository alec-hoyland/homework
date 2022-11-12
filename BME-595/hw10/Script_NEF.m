
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

N1 = makelifn(ALPHA(1), PHI0(1), J_BIAS(1));
N2 = makelifn(ALPHA(2), PHI0(2), J_BIAS(2));
N3 = makelifn(ALPHA(3), PHI0(3), J_BIAS(3));
N4 = makelifn(ALPHA(4), PHI0(4), J_BIAS(4));
N5 = makelifn(ALPHA(5), PHI0(5), J_BIAS(5));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2/4: Encoding with a Population of Neurons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record Physical Value (or, in this case, generate a random value)

x = rand(1,1); % "stimulus recording"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encode Physical Value Into Spike Rates (ratelifn)

a1 = ratelifn(N1, x);
a2 = ratelifn(N2, x);
a3 = ratelifn(N3, x);
a4 = ratelifn(N4, x);
a5 = ratelifn(N5, x);

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

[A1, X] = responselifn(N1, minval, maxval, res);
[A2, X] = responselifn(N2, minval, maxval, res);
[A3, X] = responselifn(N3, minval, maxval, res);
[A4, X] = responselifn(N4, minval, maxval, res);
[A5, X] = responselifn(N5, minval, maxval, res);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compile activation functions into a single matrix
%   appropriate as input to 'determinedecoders'

A = [A1, A2, A3, A4, A5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Decoders for Population (determinedecoders)

PHI = determinedecoders(A, X);

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

Ax = [a1, a2, a3, a4, a5]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode Recorded Spike Rates (decodespikerate)

x_hat = decodespikerate(Ax, PHI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print Results of Decoding

fprintf('The recorded physical value was: %5.4f\n',x)
fprintf('The decoded estimate of that value is: %5.4f\n',x_hat)

%eof