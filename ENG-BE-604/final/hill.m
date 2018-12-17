function rate = hill(S, n, k)
  % computes the hill equation with data S
  % and parameters n and k

  rate = S.^n ./ (S.^n + k^n);

end
