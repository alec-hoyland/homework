
%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate pulses for a CIS Cochear Implant

%%%%%%%%%%%%%%%%%%%%%%
% CI Setup

Fs = 16000; % sampling frequency
ne = 4; % number of electrodes
len = 100; % number of samples to simulate

%%%%%%%%%%%%%%%%%%%%%%
% Pulse Generator Setup

fp = 800; % pulse frequency (pulses/sec)
tau = 2*pi/ne; % pulse duration (rad)
thetadot = (2*pi*fp)/Fs; % radial velocity (rad/sample)
Phi = linspace(0,(2*pi)-tau,ne)'+tau/2; % electrode phases (rad)

% Create Vector Bank
VECS = zeros(ne,1);
for j = 1:ne
    VECS(j) = makerotvec(1,Phi(j));
end

%%%%%%%%%%%%%%%%%%%%%%
% Simulate Pulses Over Time

P = zeros(len,ne);

for i = 1:len
    
    for j = 1:ne
        
        %%%%%%%%%%%%%%%%%%%%%%
        % Pulse Train Updating
        
        VECS(j) = rotatevec(VECS(j),thetadot);
                
        %%%%%%%%%%%%%%%%%%%%%%
        % Determine Pulse Status
        
        p = determinepulse(VECS(j),tau);
        
        %%%%%%%%%%%%%%%%%%%%%%
        % Record Pulse State
        P(i,j) = p;
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%
% Viz Pulses

plot(P)

%eof