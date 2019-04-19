function R = ccmat(data)
  % Returns the pearson correlation coefficient matrix for the columns in data.
  
  [n, m] = size(data);
  covmat = cov(data);
  stds = std(data);
  stdx = repmat(stds, m, 1);
  stdy = repmat(stds', 1, m);
  stdprod = stdx.*stdy;
  i_n0 = stdprod ~= 0.0;
  R = zeros(m, m);
  R(i_n0) = covmat(i_n0) ./ stdprod(i_n0);