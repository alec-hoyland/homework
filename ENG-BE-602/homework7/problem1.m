%% Homework #7
% Problem 1
% Alec Hoyland
% 2019-3-16 13:52

pdflib.header;
tic

%% Boundary Conditions
% $u \rightarrow 0$ as $z \rightarrow \infty$. $u = 0$ at $r = b= 10, z \neq 0$. Finally, at $z=0, r=b$,
% $u(r,\phi,0) = 50 - 0.004r^4 \cos(2\phi) - 0.015r^3\sin(\phi)$.
%
% $C_{m,p} = \frac{2}{\pi b^2[J_{m+1}(k_{m,p}b)]^2} \int_0^{2\pi} h_{cos}(\phi) cos(m\phi) d\phi$


%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))
