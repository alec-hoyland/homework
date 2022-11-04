function x_hat = decodespikerate(Ax,PHI)
%
% Name: decodespikerate
%
% Inputs:
%    Ax - n-by-1 vector of LIF neuron spiking rates (spikes/sec),
%         elements corresponding to the n individual neurons in the pop'ln,
%         values representing recorded spiking rates.
%    PHI - n-by-1 vector of decoders,
%          rows corresponding to the n individual neurons in the pop'ln
% Outputs:
%    x_hat - estimate of the value encoded by the population of neurons      
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Estimate the value encoded by a population of neurons on
%              the basis of their spiking rates recorded at a common
%              physical value, as well as their determined decoders

% Determine Estimate of Physical Value x
   x_hat = Ax' * PHI;

return
%eof