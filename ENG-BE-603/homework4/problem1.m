%% Homework #4
% Problem 1
% Alec Hoyland
% 2019-4-24 17:17

pdflib.header;
tic

ra = 2e6;
rm = 10e3;
Cm = 150e-9;
D = 1 / (ra * Cm);
B = 1 / (rm * Cm);

b = 1;
h = get_h(x, b);

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function h = get_h(x, b)
	h = zeros(length(x),1);
	h(-b < x | x < 0) = -1;
	h(0 < x | x < b) = 1;
end
