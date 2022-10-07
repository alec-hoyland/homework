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
theta = %<your code goes here>

% Calculate feedforward coefficients
% Store them in the filter struct

%<your code goes here>
%<your code goes here>
%<your code goes here>

% Calculate feedback coefficients
% Store them in the filter struct

%<your code goes here>
%<your code goes here>
%<your code goes here>

return
%eof