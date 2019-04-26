function [x] = LevenbergMarquardt(t, y, fcn, mu, mu_scale, initial, nIters)
  % nonlinear least-squares fitting

  if ~exist('nIters', 'var')
    nIters = 100;
  end

  x       = NaN(2,nIters);
  x(:,1)  = corelib.vectorise(initial);
  norm00  = NaN;

  for ii = 2:nIters
    % unpack outputs from input function
    [yhat, J] = fcn(t, x(1, ii-1), x(2, ii-1));
    J0    = J';
    % compute deviance
    b0    = y - yhat;
    % compute residual
    dx    = mldivide(J0' * J0 + mu * eye(size(J0,2)), J0' * b0);
    r0    = b0 - J0 * dx;
    norm0 = sum(r0.^2);

    % evaluate norm-squared of residual
    for qq = 1:5
      xtemp     = x(:,ii-1) + dx;
      residual  = y - fcn(t, xtemp(1), xtemp(2));
      res_norm  = sum(residual.^2);

      if res_norm < norm0
        % update the x-vector
        x(:,ii) = xtemp;
        % decrease trust factor
        mu      = mu / mu_scale(2);
        % terminate inner loop
        break
      else
        % increase trust factor
        mu      = mu * mu_scale(1);
        % compute residual
        dx      = mldivide(J0' * J0 + mu * eye(size(J0, 2)), J0' * b0);
        r0      = b0 - J0 * dx;
        norm0   = sum(r0.^2);

        % give up if qq = 5
        if qq == 5
          % update x regardless
          x(:,ii) = xtemp;
          % terminate inner loop
          break
        end % qq == 5

      end % res_norm < norm0

    end % qq

    % print results
    disp(['[ITER #' num2str(ii-1) '] x: ' mat2str(x(:,ii)) ' norm(r): ' num2str(norm0) ' m: ' num2str(qq) ' mu: ' num2str(mu)])

    % check for convergence
    if abs(norm0 - norm00) < 0.0001
      disp('[INFO] solution converged')
      break
    else
      norm00 = norm0;
    end

  end %% ii

  % post-processing
  x     = reshape(nonnans(x), 2, []);

end % function
