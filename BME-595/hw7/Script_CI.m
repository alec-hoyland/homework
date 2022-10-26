
%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate a single channel of the CIS Cochear Implant
%
% NOTE: need to expand this script to allow for multichannel filterbank

% Waveform in free field, near the pinna
[waveform, Fs] = audioread('sa2.wav');
waveform = waveform./max(abs(waveform));

%%%%%%%%%%%%%%%%%%%%%%
% CI Setup

ne = 1; % number of electrodes

%%%%%%%%%%%%%%%%%%%%%%
% Filterbank Setup

% CI Setup Parameters
len = length(waveform);

% Create Gammatone Filter Cascade
fc = 1000;
bw = 0.1765*fc + 18.3085;
GTa = makefiltgt(fc,bw,Fs);
GTb = makefiltgt(fc,bw,Fs);
GTc = makefiltgt(fc,bw,Fs);

% Create Lowpass Filter Cascade
fc = 200;
LPa = makefiltbutter(fc,Fs);
LPb = makefiltbutter(fc,Fs);
LPc = makefiltbutter(fc,Fs);
LPd = makefiltbutter(fc,Fs);

%%%%%%%%%%%%%%%%%%%%%%
% Pulse Generator Setup

fp = 800; % pulse frequency (pulses/sec)
tau = 2*pi/ne; % pulse duration (rad)
thetadot = (2*pi*fp)/Fs; % radial velocity (rad/sample)
Phi = linspace(0,(2*pi)-tau,ne)'+tau/2; % electrode phases (rad)

% Create Phasor Bank
VEC = makerotvec(1,Phi(1));

%%%%%%%%%%%%%%%%%%%%%%
% Simulate CI Over Time

Y = zeros(len,ne);
V = zeros(len,ne);
S = zeros(len,ne);
P = zeros(len,ne);

for i = 1:len
    
    curr = waveform(i);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Initial Gain
    
    curr = 10 * curr;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Gammatone Filter Cascade
    
    [curr, GTa] = applyfilt(curr, GTa);
    [curr, GTb] = applyfilt(curr, GTb);
    [curr, GTc] = applyfilt(curr, GTc);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Full-Wave Rectification
    
    curr = abs(curr);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Lowpass Filter Cascade
    
    [curr, LPa] = applyfilt(curr, LPa);
    [curr, LPb] = applyfilt(curr, LPb);
    [curr, LPc] = applyfilt(curr, LPc);
    [curr, LPd] = applyfilt(curr, LPd);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Nonlinear Compression
    
    curr = real(curr ^ 0.9);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Record Stim Magnitude
    
    Y(i,1) = curr;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Pulse Train Updating
    
    VEC = rotatevec(VEC, thetadot);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Determine Pulse Status
    
    p = determinepulse(VEC, tau);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Record Pulse State
    P(i,1) = p;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Record Final Output
    
    S(i,1) = max([0, curr]) * P(i, 1);
    
end

%eof