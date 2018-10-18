function gamma = shifted_inverse_power(A, x, verbose)
	dist 			= 1;
	gamma0 		= 1 + x' * A * x; % on iteration #1, the difference is 1
	iter 			= 0;

	if nargin < 3
		verbose = false;
	end
	
	while dist >= 0.001
		% update the iterator count
		iter 		= iter + 1;
		% compute the new Rayleigh factor
		gamma 	= x' * A * x;
		% solve the eigenvalue equation to update the vector estimate
		x 			= inv(A - gamma*eye(length(A))) * x;
		% normalize the vector
		x 			= x / (x'*x);
		% compute the difference between the new and old values
		dist 		= abs(gamma - gamma0);
		% the new value becomes the old value
		gamma0 	= gamma;
		% display the results
		if verbose
			disp(['[INFO] Iteration #' num2str(iter) '	Gamma = ' mat2str(gamma, 2) '		distance = ' oval(dist,2)])
		end % if
	end % while
end % function
