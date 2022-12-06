function [A X] = responselifn(N,minval,max_val,res)
%
% Name: responselifn
%
% Inputs:
%    N - A struct, representing a LIF neuron
%    minval - The minimum relevant value, to be encoded
%    maxval - The maximum relevant value, to be encoded
%    res - The number of relevant values (evenly-spaced) 
%           to be encoded over the range specified by minval and maxval
% Outputs:
%    A - res-by-1 vector of LIF neuron spiking rates (spikes/sec),
%         corresponding to evenly-spaced values between minval and maxval
%    X - a res-by-1 vector of values, to be encoded
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Calculate the spiking rate of an LIF neuron given
%               a specified range of values and
%               a number of evenly-spaced values over that range

% Create a vector of relevant values
   X = linspace(minval, max_val, res);

% Initialize vector of spiking rates
   A = zeros(res, 1);
   
% Iterate over relevant values, record spiking rate
   for ii = 1:length(A)
      A(ii) = ratelifn(N, X(ii));
   end
      
return
%eof