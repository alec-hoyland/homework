%% Final
% Alec Hoyland
% 2018-12-17 10:11

pHeader;
tic

%% Load data
[wavenumber, chem1, chem2] = textread('data_problem2.txt', '%f%f%f', 'headerlines', 1);

% pre-process the wavenumber
wavenumber = wavenumber / 1e3;

%% 1. Using LOESS to smooth data

chem1_smooth    = fLOESS(chem1, 0.02);
chem2_smooth    = fLOESS(chem2, 0.02);

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(wavenumber, chem1, 'o', 'Color', [0 0 0 0.2])
plot(wavenumber, chem1_smooth, 'k')
xlabel('wavenumber')
ylabel('IR signal')
set(gca, 'XDir', 'reverse')
title('Chemical #1')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(wavenumber, chem2, 'o', 'Color', [0 0 0 0.2])
plot(wavenumber, chem2_smooth, 'k')
xlabel('wavenumber')
ylabel('IR signal')
set(gca, 'XDir', 'reverse')
title('Chemical #2')

prettyFig();

if being_published
  snapnow
  delete(gcf)
end

%% 2. Pre-LOESS and Post-LOESS points

tbl = table(wavenumber(1:20), chem1(1:20), chem1_smooth(1:20), chem2(1:20), chem2_smooth(1:20));
tbl.Properties.VariableNames = {'wavenumber', 'chem1', 'chem1smooth', 'chem2', 'chem2smooth'};

disp(tbl)



%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
