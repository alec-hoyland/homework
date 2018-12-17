function y = logistic_2factor(beta, x1, x2)

  polynomial = beta(1) + beta(2) * x1 + beta(3) * x2 + ...
              beta(4) * x1.^2 + beta(5) * x1 .* x2 + beta(6) * x2.^2;

  y = 1 ./ (1 + exp(-polynomial));

end
