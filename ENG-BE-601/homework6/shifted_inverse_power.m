function [gamma, x] = shifted_inverse_power(A, x, verbose)
	dist 				= 1;
	gamma 			= zeros(2,1);

	% initial condition
	gamma(1) 		= x' * A * x;

	if nargin < 3
		verbose 	= false;
	end

	for ii = 2:100
		% update the iterator count
		iter 			= iter + 1;
		% solve the eigenvalue equation to update the vector estimate
		x 				= inv(A - gamma(1) * eye(length(A))) * x;
		% normalize the vector
		x 				= x / (x'*x);
		% use that vector to generate a new Rayleigh quotient
		gamma(2)	= x' * A * x;
		% compute the difference between the new and old values
		dist 			= abs(gamma(2) - gamma(1));
		% the new value becomes the old value
		gamma(1)	= gamma(2);

		% display the results
		if verbose
			disp(['[INFO] Iteration #' num2str(iter) '	gamma = ' mat2str(gamma(2), 2) '		distance = ' oval(dist,2)])
		end % if

		% termination conditions
		if dist < 0.0001
			disp(['[INFO] convergence at < 0.0001 after' num2str(iter) 'iterations'])
			break
		end

		if ii == 100
			disp('[INFO] terminating after 100 iterations')
			break
		end % if

	end % for

	gamma = gamma(2);

end % function
