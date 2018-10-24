function A = spectralSums(n, U, S, V)

  A = U(:, 1:n) * S(1:n, 1:n) * V(:, 1:n)';

end % function
