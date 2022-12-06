function N = updatelifn(x,N,Fs)
%
% Name: updatelifn
%
% Inputs:
%    x - a (scalar) physical value, to be encoded
%    N - a struct, representing an LIF neuron to be updated
%    Fs - a (scalar) sampling rate, in Hz
% Outputs:
%    N - a struct, representing the updated LIF neuron
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Update the membrane voltage an LIF neuron, 
%               on the basis of its parameters and a physical value 

tau = 1/Fs; % simulation time step in seconds

if N.state == 1 % The neuron is exhibiting super-threshold behavior
    
    % <your code below>

	if N.refc == 0
		N.V = 1;
	else
		N.V = 0;
	end

	if N.refc < N.tau_ref
		N.refc = N.refc + tau;
	else
		N.state = -1;
		N.refc = 0;
	end

    % If the refractory period "clock" has been reset (==0)
		% Set membrane voltage to '1' (spike)
	% Else
		% Set membrane voltage to "0" (refractory period voltage)

	% If the refractory period "clock" his less than the absolute refractory period
		% Add time to the "clock" equal to one simulation time step
	% Else (i.e., the refractory period is over)
		% Change state to '-1' - the neuron resumes sub-threshold behavior
		% Reset the refractory period "clock" (=0)
    
else % The neuron is exhibiting sub-threshold behavior
    
    % <your code below>

    J = N.alpha*N.phi*x + N.J_bias; % Determine soma current of the neuron (see 'ratelifn.m')
	Vd = - (1/N.tau_RC) * (N.V - J * N.R); % Determine change in membrane voltage (see Eliasmith 4.4)
	N.V = N.V + Vd*tau; % Update membrane voltage
	% If membrane voltage is above threshold
		% Change state to '1' - the neuron initiates super-threshold behavior

	if N.V > N.Vth
		N.state = 1;
	end

end
            

return
%eof