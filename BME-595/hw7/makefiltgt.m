function F = makefiltgt(fc,bw,Fs)
%
% Name: makefiltgt
%
% Inputs:
%    fc - Center frequency (Hz)
%    bw - Filter bandwidth (Hz)
%    Fs - Sampling frequency (Hz)
% Outputs:
%    F - a struct, representing a 2nd-order gammatone digital filter
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Create a 2nd-order IIR digital filter
%              and populate its coefficients in accordance with a
%              gammatone filter with the specified cutoff frequency
%              and bandwidth at sampling rate Fs
%

% Make a 2nd-order digital filter
F = makefilt(2);

% Determine filter center frequency and bandwidth 
% as a fraction of the Nyquist frequency
theta = 2 * pi * fc / Fs; 
beta = 2 * pi * bw / Fs;
r = exp(-beta);

% Calculate feedback coefficients
% Store them in the filter struct

F.a = [1, -2 * r * cos(theta), r^2]';

% Calculate feedforward coefficients
% Store them in the filter struct

F.b(1) = abs((1 + F.a(1) * exp(- i * theta) + F.a(3) * exp(-2 * j * theta)) / (1 - r * cos(theta) * exp(i * theta)));
F.b(2) = - F.b(1) * r * cos(theta);

return
%eof