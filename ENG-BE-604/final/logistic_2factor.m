function [y, J] = logistic_2factor(beta, xdata)

  % beta is a 1x6 matrix

  polynomial = beta(1) + beta(2) * xdata(:,1) + beta(3) * xdata(:,2) + ...
              beta(4) * xdata(:,1).^2 + beta(5) * xdata(:,1) .* xdata(:,2) + beta(6) * xdata(:,2).^2;

  y = 1 ./ (1 + exp(-polynomial));

  if nargout > 1

    J         = NaN(length(y), 6);
    kernel    = exp(polynomial) ./ ((exp(polynomial) + 1) .^2);
    J(:, 1)   = kernel;
    J(:, 2)   = xdata(:,1) .* kernel;
    J(:, 3)   = xdata(:,2) .* kernel;
    J(:, 4)   = xdata(:,1) .* xdata(:,1) .* kernel;
    J(:, 5)   = xdata(:,1) .* xdata(:,2) .* kernel;
    J(:, 6)   = xdata(:,2) .* xdata(:,2) .* kernel;

  end

end
