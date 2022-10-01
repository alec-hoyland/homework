function [y F] = applyfilt(input,F)
%
% Name: applyfilt
%
% Inputs:
%    in - a scalar, the current filter input
%    F - a struct, representing a digital filter
% Outputs:
%    y - a scalar, the current filter output
%    F - a struct, representing the input filter, updated
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Apply digital filter F to input in, in accordance with 
% the generic filter equation: 
% a(1)*y(i) = b(1)*x(i) + b(2)*x(i-1) + ... + b(n+1)*x(i-n)
%             - a(2)*y(i-1) - ... - a(n+1)*y(i-n)
%

% Add new input (M+1 x 1 vector)
inputs = [input; F.in];

% New output
% NOTE: these are just inner products
% so I should just multiply a column vector
% by a row vector
% but I don't remember what the dimensions are
% and I am lazy, so...
y = (sum(F.b .* inputs) - sum(F.a(2:end) * F.out)) / F.a(1);

% Update recent inputs
%    'in' is now the most recent
%    least recent is discarded
F.in(2:end) = F.in(1:end-1);
F.in(1) = input;

% Update recent outputs
%    'y' is now the most recent
%    least recent is discarded
F.out(2:end) = F.out(2:end-1);
F.out(1) = y;

return
%eof