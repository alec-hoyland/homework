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

prettyFig()

if being_published
  snapnow
  delete(gcf)
end



%% Version Info
pFooter;
time = toc;

%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
