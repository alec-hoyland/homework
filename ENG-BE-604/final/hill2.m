function F = hill2(x, xdata)

  % an alternative formulation where the parameters are in a vector, x
  F = xdata.^(x(1)) ./ (xdata.^(x(1)) + x(2)^(x(1)));

end
