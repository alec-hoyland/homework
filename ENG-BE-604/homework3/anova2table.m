function T = anova2table(tbl)
  % because MATLAB is terrible at this for some reason

  lhs = {'Groups', 'Error', 'Total'};

  inner = NaN(3,5);
  for ii = 1:3
    for qq = 1:5
      try
        inner(ii, qq) = tbl{ii+1, qq+1};
      catch
        inner(ii,qq) = NaN;
      end
    end
  end


  T = table(lhs', inner(:,2), inner(:,1), inner(:,3), inner(:,4), NaN(3,1), inner(:,5));
  T{1,6} = finv(0.95, T{1,2}, T{2,2});
  T.Properties.VariableNames = {'Source', 'DOF', 'SS', 'MS', 'F', 'Fc', 'prob'};

end % function
