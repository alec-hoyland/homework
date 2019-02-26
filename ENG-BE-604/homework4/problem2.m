%% Homework #4
% Problem 2
% Alec Hoyland
% 2018-12-6 13:23

pHeader;
tic

%% Load data
[x1, x2, y] = textread('data_problem2.txt', '%f%f%f', 'headerlines', 1);

[r,I] = sort(sqrt(x1.^2 + x2.^2));
y     = y(I);
p     = 1:14;

for ii = 1:14
  yfit    = polyfit(r, y, ii);
  res(ii) = norm(y - polyval(yfit, r));
end

disp([p' res'])

%%

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
leg = cell(14,1);
plot(r, y, 'ok')
leg{1} = 'data';
for ii = 1:14
  plot(r, polyval(polyfit(r, y, ii), r));
  leg{ii+1} = ['p = ' num2str(ii)];
end
xlabel('r')
ylabel('y')
legend(leg)

figlib.pretty()

if being_published
  snapnow
  delete(gcf)
end

%%

PE = NaN(20,14);

for ii = 1:20
  for qq = 1:14
    yfit    = polyval(polyfit(r, y, qq), r);
    res     = 0;
    for ww = 1:5
      samplepoint = randsample(length(y), 1);
      res     = res + (y(samplepoint) - yfit(samplepoint))^2;
    end
    PE(ii,qq) = res/5;
  end
end

disp('PE matrix')
disp(PE)

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(p, PE', '-o')
xlabel('polynomial order')
ylabel('PE values')
title('PE values with LOO CV')

figlib.pretty()

if being_published
  snapnow
  delete(gcf)
end

%%
% For a really good fit, an eighth order polynomial fit produces great results for
% a minimum of terms. Lower-order fits don't get the oscillations correct and diverge
% as $r$ increases. If I wanted a more rigorous measure, I would compute the likelihood
% of a given data point value given the model as a predictor and compute the Bayesian
% information criterion from that.

%%
% <</home/ahoyland/code/homework/ENG-BE-604/homework4/untitled.png>>

% [x1, x2, y] = textread('data_problem2.txt', '%f%f%f', 'headerlines', 1);
% x           = -20:20;
% yfit        = NaN(length(x), length(x));
% poly8       = polyfit(r, y, 8);
% for ii = 1:length(x)
%   for qq = 1:length(x)
%     yfit(ii,qq) = polyval(poly8, x(ii)^2 + x(qq)^2);
%   end
% end
%
% figure; hold on
% plot3(x1, x2, y, 'o', 'MarkerSize', 10);
% surf(x, x, yfit, 'EdgeColor', 'none');
% xlabel('x1')
% ylabel('x2')
% zlabel('y')
% zlim([-1, 1])
%
% figlib.pretty()
%
% if being_published
%   snapnow
%   delete(gcf)
% end

%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
