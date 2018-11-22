%% Homework #3
% Problem 2
% Alec Hoyland
% 2018-11-21 20:44

pHeader;
tic

A = [ 363 907 1319 1729; ...
    413 2218 2064 1930; ...
    483 1316 1644 1065; ...
    362 923 841 2724; ...
    741 2211 2272 3083; ...
    721 2386 2873 1706; ...
    483 1553 1541 1673; ...
    240 1335 1336 2166; ...
    630 1496 2657 1729];

A(2,2) = NaN;
A(3,4) = NaN;
A(4,3) = NaN;
A(5,2) = NaN;
A(6,2) = NaN;

dataTable 	= table(A(:,1), A(:,2), A(:,3), A(:,4));
dataTable.Properties.VariableNames = {'year2013', 'year2014', 'year2015', 'year2016'};

%% 1. The data table

disp(dataTable)

%% 2. Mean cases of scarlet fever by year

mean(dataTable{:,:}, 1, 'omitnan')

%% 3. Mean cases of scarlet fever by region

mean(dataTable{:,:}, 2, 'omitnan')

%% 4. Plot Data

%% 5. ANOVA

[~, cel] 	= anova1(A, dataTable.Properties.VariableNames, 'off');
ANOVA 		= anova2table(cel);

disp(ANOVA)

%% Version Info
% The file that generated this document is called:
disp(mfilename)


%%
% and its md5 hash is:
Opt.Input = 'file';
disp(dataHash(strcat(mfilename,'.m'),Opt))


%%
% This file should be in this commit:
[status,m]=unix('git rev-parse HEAD');
if ~status
	disp(m)
end

time = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(time,3),' seconds.'))
