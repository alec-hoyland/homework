%% Take-Home Final
% Alec Hoyland
% 15:32 2018-10-29

pHeader;
tic

[wavenumber, arabica1, arabica2, arabica3, arabica4, arabica5, …
 robusta1, robusta2, robusta3, robusta4, robusta5 ] …
 = textread(‘Problem2_coffee_FTIR_data.txt’, …
 '%f%f%f%f%f %f%f%f%f%f', 'headerlines', 3 )

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

t = toc;


%%
% This file has the following external dependencies:
showDependencyHash(mfilename);


%%
% This document was built in:
disp(strcat(oval(t,3),' seconds.'))
