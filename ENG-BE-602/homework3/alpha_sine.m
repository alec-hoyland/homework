function [y, J] = alpha_sin(t, alpha, omega)


  y       = t .* exp(-alpha * t) .* sin(omega * t);

  J       = NaN(2,length(t));
  J(1,:)  = -alpha * t .* exp(-alpha * t) .* sin(omega * t);
  J(2,:)  = omega * t .* exp(-alpha * t) .* cos(omega * t);

end % function
