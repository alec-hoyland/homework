function [y, F] = applyfilt(input, F)
%
% Name: applyfilt
%
% Inputs:
%    input - scalar input
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

% Add new input (M+1 x 1 vector)
inputs = [input; F.in];

% Compute the new output
F.out = sum(F.b .* inputs) / F.a;

% Set y to be the latest output
y = F.out(1);

% Shift inputs right by one step
F.in(2:end) = F.in(1:end-1);

% Add new most recent input
F.in(1) = input;

return
%eof