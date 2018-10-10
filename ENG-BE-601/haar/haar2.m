function [I2, I1] = haar2(I)
  k = 1;

  for ii = 1:2:size(I,2)
    I1(:, k) = (I(:,ii) + I(:,ii+1)) / 2;
    k = k + 1;
  end

  for ii = 1:2:size(I,2)
    I1(:, k) = (I(:,ii) - I(:, ii+1)) / 2;
    k = k + 1;
  end

  I1 = round(I1);

  k = 1;
  for ii = 1:2:size(I,1)
    I2(k,:) = (I1(ii,:) - I1(ii+1,:)) / 2;
    k = k + 1;
  end

  for ii = 1:2:size(I,1)
    I2(k,:) = (I1(ii,:) - I1(ii+1,:)) / 2;
    k = k + 1;
  end

  I2 = round(I2);
