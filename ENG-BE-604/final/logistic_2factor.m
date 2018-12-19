function [y, J] = logistic_2factor(beta, x1, x2)

  polynomial = beta(1) + beta(2) * x1 + beta(3) * x2 + ...
              beta(4) * x1.^2 + beta(5) * x1 .* x2 + beta(6) * x2.^2;

  y = 1 ./ (1 + exp(-polynomial));

  J         = NaN(6, length(x1));
  kernel    = exp(polynomial) ./ ((exp(polynomial) + 1) .^2);
  J(1, :)   = kernel;
  J(2, :)   = x1 .* kernel;
  J(3, :)   = x2 .* kernel;
  J(4, :)   = x1 .* x1 .* kernel;
  J(5, :)   = x1 .* x2 .* kernel;
  J(6, :)   = x2 .* x2 .* kernel;

end
