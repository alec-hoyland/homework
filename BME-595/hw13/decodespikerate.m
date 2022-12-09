function x_t_hat = decodespikerate(At,PHI)
%
% Name: decodespikerate
%
% Inputs:
%    At - p-by-n vector of LIF temporal activation functions,
%         columns corresponding to the n individual neurons in the pop'ln,
%         rows corresponding to the p samples in the temporal activation function.
%    PHI - n-by-1 vector of decoders,
%          rows corresponding to the n individual neurons in the pop'ln
% Outputs:
%    x_t_hat - p-by-1 estimate of the time-varying value encoded by the 
%               population of neurons      
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Estimate the value encoded by a population of neurons on
%              the basis of their temporal activation functions, 
%              as well as their determined decoders

% Determine Estimate of Time-Varying Physical Value x_t
   x_t_hat = At * PHI;

return
%eof