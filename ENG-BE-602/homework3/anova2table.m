function T = anova2table(tbl)
  % because MATLAB is terrible at this for some reason

  lhs = {'Groups', 'Error', 'Total'};

  inner = NaN(3,4);
  for ii = 1:5
    for qq = 1:3
      inner(qq, ii) = tbl{ii+1, qq+1};
    end
  end

  inner(3,3)      = NaN;
  inner(3:4,4:5)  = NaN;

  T = table(lhs, inner(:,1), inner(:,2), inner(:,3), inner(:,4), inner(:,5));
  T.Properties.VariableNames = {'Source', 'SS', 'dF', 'MS', 'F', 'Prob>F'};

end % function
