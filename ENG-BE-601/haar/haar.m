function B = haar(N, norm)
  % create the matrix operation version of the top/bottom bin operations

  % Arguments:
    % N is the size of the matrix, size(B) = [N, N]
    % iteratively produces the Haar matrix using the Kronecker tensor product
    % norm determines the type of normalization
      % 'root' : iteratively normalizes by 1 / sqrt(2)
      % 'half' : normalizes each row individually
      % 'none' : no normalization
  % Outputs:
    % B is the N x N non-normalized haar matrix

  B = [1];

  LP = [1 1];
  HP = [1 -1];

  if nargin < 2
    norm = 'none';
  end

  switch norm
  case 'root'
    norm_const = 1 / sqrt(2);
    for ii = 1:log2(N)
      B = norm_const * [kron(B, LP); kron(eye(size(B)), HP)];
    end
  case 'half'
    for ii = 1:log2(N)
      B = [kron(B, LP); kron(eye(size(B)), HP)];
    end
    norm_const = 1 ./ sum(abs(B)')';
    B = norm_const .* B;
  case 'none'
    for ii = 1:log2(N)
      B = [kron(B, LP); kron(eye(size(B)), HP)];
    end
  end % switch

end % function
