function [y, J] = alpha_sin(t, alpha, omega)
  % compute the alpha * sine function
  % and the associated Jacobian matrix
  % for parameters alpha and omega
  % and data t

  % NOTE: alpha is negative and omega is positive (or negative)

  y       = t .* exp(alpha * t) .* sin(omega * t);

  J       = NaN(2,length(t));
  J(1,:)  = alpha * t .* exp(alpha * t) .* sin(omega * t);
  J(2,:)  = omega * t .* exp(alpha * t) .* cos(omega * t);

end % function
