function [] = LevenbergMarquardt(t, y, fcn, Jacobian, params, mu, mu_scale, initial)
  % nonlinear least-squares fitting

  x       = NaN(2,1000);
  x(:,1)  = vectorise(initial);
  norm00  = NaN;

  for ii = 2:16
    % compute deviance and Jacobian
    b0    = y - fcn(x(:,ii-1));
    J0    = Jacobian(x(:,ii-1));
    % compute residual
    dx    = mldivide(J0' * J0 + mu * eye(length(J0)), J0' * b0);
    r0    = b0 - J0 * dx;
    norm0 = sum(r0.^2);

    % evaluate norm-squared of residual
    for qq = 1:5
      xtemp     = x(:,ii-1) + dx;
      residual  = y - fcn(xtemp);
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
        dx      = mldivide(J0' * J0 + mu * eye(length(J0)), J0' * b0);
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


end % function
