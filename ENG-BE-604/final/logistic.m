function y = logistic(beta, x1, x2)

  y = 1 ./ (1 + exp(-(beta(1) + beta(2)*x1 + beta(3)*x2)));

end
