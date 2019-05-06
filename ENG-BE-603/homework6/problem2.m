%% Homework #6
% Problem 2
% Alec Hoyland
% 2019-5-6 11:23

pdflib.header;



%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

% function u = solution(x, t, varargin)
% 	p = struct;
% 	p.L				= 50; 			% cm
% 	p.tau 		= 7000;			% kg * cm / s^2
% 	p.sigma  	= 0.36e-5;	% kg / m
% 	p.b 			= 10;				% cm
% 	p.epsilon = 2.5;			% cm
% 	p.u0 			= 0.1;			% cm
% 	p.n 			= 60; 			% unitless
%
% 	p 				= corelib.parseNameValueArguments(p, varargin{:});
% 	c 				= sqrt(p.tau / p.sigma);
% 	u 				= zeros(length(x), length(t));
%
% 	for ii = 1:length(x)
% 		for qq = 1:length(t)
% 			for nn = 1:p.n
% 				a = 2 / (pi * nn) * (cos(nn * pi * (p.b - p.epsilon) / p.L) - cos(nn * pi * (p.b + p.epsilon) / p.L));
% 				u(ii, qq) = u(ii, qq) + a * cos(nn * pi * c * t(qq) / p.L) * sin(nn * pi * x(ii) / p.L);
% 			end
% 		end
% 	end
% end % function
