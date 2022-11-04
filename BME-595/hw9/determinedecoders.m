function PHI = determinedecoders(A,X)
%
% Name: determinedecoders
%
% Inputs:
%    A - p-by-n matrix of LIF neuron spiking rates (spikes/sec),
%         rows corresponding to the p physical values contained in X,
%         columns corresponding to the n individual neurons in the pop'ln.
%    X - p-by-1 vector of physical values, 
%         encoded in spiking rates in A (one for each row)
% Outputs:
%    PHI - n-by-1 vector of decoders
%          rows corresponding to the n individual neurons in the pop'ln
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Determine decoders for a population of neurons, on the
%              basis of their activation functions - i.e., their 
%              spiking rates measured at a range of physical values

% Determine Upsilon
   Upsilon = A' * X;

% Determine Gamma
% - "similarity" among neural activation functions
   Gamma = A' * A;

% Determine Decoders
   PHI = inv(Upsilon) * Gamma;

return
%eof