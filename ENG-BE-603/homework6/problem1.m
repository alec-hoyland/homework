%% Homework #6
% Problem 1
% Alec Hoyland
% 2019-5-6 10:52

pdflib.header;

x_ext 	= 50;				% cm
t_final = 10e-3; 		% s
dx 			= 1;				% cm
dt 			= 0.01e-3; 	% s

x 			= 0:dx:x_ext;
t 			= dt:dt:t_final;

%% Solution to wave equation

u 			= solution(x, t);
[X, T] 	= meshgrid(x, t);

figure;
surf(X, T, u', 'EdgeColor', 'none');
c = colorbar('Location', 'EastOutside');
xlabel('x-position (cm)')
ylabel('time (s)')
c.Label.String = 'y-position (cm)';

figlib.pretty;
figlib.tight;

pdflib.snap;
delete(gcf)

%% Audible frequency
% The audible frequency is $f = \frac{n}{2 L} \sqrt{\frac{\tau}{\sigma}}$.

p = struct;
p.L				= 50; 			% cm
p.tau 		= 7000;			% kg * cm / s^2
p.sigma  	= 0.36e-5;	% kg / m
p.b 			= 10;				% cm
p.epsilon = 2.5;			% cm
p.u0 			= 0.1;			% cm
p.n 			= 60; 			% unitless

disp(['The audible frequency is: ' num2str(1/(2 * p.L) * sqrt(p.tau / p.sigma)) ' Hz'])
disp('This is a fourth octave ''A'' note')

%% Version Info
pdflib.footer;
time = toc;

%%
% This document was built in:
disp(strcat(strlib.oval(time,3),' seconds.'))

function u = solution(x, t, varargin)
	p = struct;
	p.L				= 50; 			% cm
	p.tau 		= 7000;			% kg * cm / s^2
	p.sigma  	= 0.36e-5;	% kg / m
	p.b 			= 10;				% cm
	p.epsilon = 2.5;			% cm
	p.u0 			= 0.1;			% cm
	p.n 			= 60; 			% unitless

	p 				= corelib.parseNameValueArguments(p, varargin{:});
	c 				= sqrt(p.tau / p.sigma);
	u 				= zeros(length(x), length(t));

	for ii = 1:length(x)
		for qq = 1:length(t)
			for nn = 1:p.n
				a = 2 / (pi * nn) * (cos(nn * pi * (p.b - p.epsilon) / p.L) - cos(nn * pi * (p.b + p.epsilon) / p.L));
				u(ii, qq) = u(ii, qq) + a * cos(nn * pi * c * t(qq) / p.L) * sin(nn * pi * x(ii) / p.L);
			end
		end
	end
end % function
