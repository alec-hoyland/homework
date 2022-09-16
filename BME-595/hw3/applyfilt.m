function [y F] = applyfilt(in,F)
%
% Name: applyfilt
%
% Inputs:
%    in - Cutoff frequency (Hz)
%    F - a struct, representing a digital filter
% Outputs:
%    y - the current filter output
%    F - a struct, representing the input filter, updated
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Apply digital filter F to input in, in accordance with 
% the generic filter equation: 
% a(1)*y(i) = b(1)*x(i) + b(2)*x(i-1) + ... + b(n+1)*x(i-n)
%

% Determine output on basis of recent inputs (including 'in')
% and the filter coefficients
y = %<your code goes here>

% Update recent inputs
%    'in' is now the most recent
%    least recent is discarded
F.in = %<your code goes here>

return
%eof