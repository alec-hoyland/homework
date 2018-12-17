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
warning('off', 'all')
chem1_smooth    = fLOESS(chem1, 0.02);
chem2_smooth    = fLOESS(chem2, 0.02);

wavenumber  = wavenumber * 1e3;

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
scatter(wavenumber, chem1, 'filled', 'k', 'SizeData', 100)
alpha(0.2)
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
scatter(wavenumber, chem2, 'filled', 'k', 'SizeData', 100)
alpha(0.2)
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

%% 3. Which chemical is which?
% Chemical #1 is Mr. Stinky (aka para-divinylbenzene). The high wavenumbers (~1600) correspond
% to the aromatic bond stretching and the lower wavenumbers (700-1000) correspond to
% alkene stretching and bending. Chemical #2 is methyl methacrylate. The peak at
% ~1700 refers to the C=O ester bond stretching. Similarly, the peak at ~1100 refers
% to the C-O ester bond stretching. The lower wavenumber peaks correspond to alkene
% stretching and bending. The major difference between the two IR spectra is the presence
% of C=O and C-O signatures in the 1700-1100 wavenumbe range in the second spectrum.

%% Version Info
pFooter;

t = toc;

%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
