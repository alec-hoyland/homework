function [A X] = characterizelifn(N,minval,maxval,res,Fs)
%
% Name: characterizelifn
%
% Inputs:
%    N - A struct, representing a LIF neuron
%    minval - The minimum relevant value, to be encoded
%    maxval - The maximum relevant value, to be encoded
%    res - The number of relevant values (evenly-spaced) 
%           to be encoded over the range specified by minval and maxval
%    Fs - a (scalar) sampling rate, in Hz
% Outputs:
%    A - res-by-1 vector of LIF neuron spiking rates (spikes/sec),
%         corresponding to evenly-spaced values between minval and maxval
%    X - a res-by-1 vector of values, to be encoded
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Estimate the spiking rate of an LIF neuron 
%               by directly observing spiking behavior, given
%               a specified range of values and
%               a number of evenly-spaced values over that range

nsamp = floor(Fs./10); % Calculate the number of samples required 
                       % for good estimate of spiking rate

X = linspace(minval,maxval,res)'; % Create a vector of relevant values

A = zeros(res,1); % Initialize vector of probed spiking rates

% <your code below>
%For all relevant values in X
	%Initialize a spike counter (=0)
	%For the required number of samples (nsamp)
		%Update the parameters of neuron N (updatelifn)
		%If the membrane voltage of N indicates a spike (==1)
			%Increment the spike counter
	%Record the spike total in spikes/second in A

for ii = 1:length(X)
	counter = 0;
	for qq = 1:nsamp
		N = updatelifn(X(ii), N, Fs);
		if N.V == 1
			counter = counter + 1;
		end
	end
	A(ii) = counter / nsamp * Fs;
end

return
%eof