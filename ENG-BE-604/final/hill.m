function [rate, J] = hill(S, n, k)
  % computes the hill equation with data S
  % and parameters n and k

  rate    = S.^n ./ (S.^n + k^n);

  J       = NaN(2, length(S));
  J(1,:)  = k^n * s.^n .* (log(S) - log(k)) ./ (s.^n + k^n).^2;
  J(2,:)  = - n * s.^n * k^(n-1) ./ (s.^n + k^n).^2;

end
