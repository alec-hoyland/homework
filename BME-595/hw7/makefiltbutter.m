function F = makefiltbutter(fc,Fs)
%
% Name: makefiltbutter
%
% Inputs:
%    fc - Cutoff frequency (Hz)
%    Fs - Sampling frequency (Hz)
% Outputs:
%    F - a struct, representing a 2nd-order butterworth digital filter
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Create a 2nd-order low-pass FIR digital filter
%              a populate its coefficients in accordance with a
%              Butterworth filter with the specified cutoff frequency
%              at sampling rate Fs
%

% Make a 2nd-order digital filter
F = makefilt(2);

% Determine filter cutoff frequency, as a proportion of the sampling frequency
theta = fc / Fs;

% Calculate feedforward coefficients
% Store them in the filter struct

cotp2t = cot(pi / 2 * theta);
alpha = 1 / (1 + sqrt(2) * cotp2t + cotp2t .^2)

F.b(1) = alpha;
F.b(2) = 2 * alpha;
F.b(3) = alpha;

% Calculate feedback coefficients
% Store them in the filter struct

F.a(1) = 1;
F.a(2) = 2 * alpha * (1 - cotp2t .^ 2); 
F.a(3) = alpha * (1 - sqrt(2) * cotp2t + cotp2t .^ 2);

return
%eof