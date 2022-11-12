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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are at least three viable solutions to this function,
% depending on which type of Matlab syntax is employed:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option #1: Using Iteration - e.g., a for-loop

%%% Determine Estimate of Physical Value x
n = size(PHI,1); % number of neurons/decoders
x_hat = 0; % the estimate will be accumulated here
for itor = 1:n
    % add the product of one neuron's encoding 
    % and its corresponding decoder to the accumulating estimate
    x_hat = x_hat + Ax(itor)*PHI(itor);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option #2: Using Element-Wise Operations - e.g., Matlab's "." syntax

% %%% Determine Estimate of Physical Value x
% x_hat = sum(Ax.*PHI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option #3: Using Vector Operations - e.g., the inner product

% %%% Determine Estimate of Physical Value x
% x_hat = Ax'*PHI;

return
%eof