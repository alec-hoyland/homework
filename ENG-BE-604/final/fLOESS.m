function [smoothed] = fLOESS(noisy,span)

if length(noisy)*span<4
    error('myApp:argChk','input arg "span" is too low')
end
% Default x-data
if size(noisy,2)<2
    noisy = [(1:1:length(noisy))',noisy];
end
%% Smooth the data points
% define variables
x = noisy(:,1);
y = noisy(:,2);
n = length(noisy);
r = x(end) - x(1);
hlims = [span,x(1);...
    (span)/2,x(1)+r*span/2;...
    (span)/2,x(1)+r*(1-span/2);...
    span,x(end)];
% Find the LOESS fit to the data
smoothed = zeros(n,1); % pre-allocate space
for i = 1:n

    % define the tricube weight function
    h = interp1(hlims(:,2),hlims(:,1),x(i));
    w = (1-abs((x./max(x)-x(i)./max(x))/h).^3).^3;

    % data points outwith the defined span can be ignored (for speed)
    w_idx = w>0;
    w_ = w(w_idx);
    x_ = x(w_idx);
    y_ = y(w_idx);

    % Calculate the weighted coefficients
    XX =   [nansum(w_.*x_.^0), nansum(w_.*x_.^1), nansum(w_.*x_.^2);...
            nansum(w_.*x_.^1), nansum(w_.*x_.^2), nansum(w_.*x_.^3);...
            nansum(w_.*x_.^2), nansum(w_.*x_.^3), nansum(w_.*x_.^4)];

    YY =   [nansum(w_.*y_.*(x_.^0));...
            nansum(w_.*y_.*(x_.^1));...
            nansum(w_.*y_.*(x_.^2))];

    CC = XX\YY;

    % calculate the fitted data point
    smoothed(i) = CC(1) + CC(2)*x(i) + CC(3)*x(i).^2;

end
end
