function a = ratelifn(N,x)
%
% Name: ratelifn
%
% Inputs:
%    N - A struct, representing a LIF neuron
%    x - A scalar value, to be encoded 
% Outputs:
%    a - LIF neuron spiking rate (spikes/sec)
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Calculate the spiking rate of an LIF neuron
%               given a specified value

% Determine soma currents
   J_d = N.phi * N.alpha * x;
   J_sum = J_d + N.J_bias;

% Determine spiking rates
   if J_sum < N.J_th
      a = 0;
   else
      a = 1 / (N.tau_ref - N.tau_RC * (1 - (N.J_th / J_sum)));
   end

return
%eof