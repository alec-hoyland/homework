%% Homework #2
% Problem 2
% Alec Hoyland
% 2018-11-15 16:49

pHeader;
tic

%% 2.1 Constants

a = 1; b = 0.5; c = 3; d = 4;

% dx1/dt = -ax1 + x2
% dx2/dt = cx1^2 / (x12 + d) - bx2

x1 		= [-10:0.01:10];
x2 		= x1;

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x1, a*x1, 'k');
plot(x1, 1/b*c*x1.^2./(x1.^2+d), 'r');
legend({'x_1''=0', 'x_2''=0'}, 'Location', 'best')

xlabel('x_1')
ylabel('x_2')
title('phase plot of a dynamical system')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 2.2 Newton's Method

% dx/dt
f 			= cell(2,1);
f{1} 		= @(x1,x2) -a*x1 + x2;
f{2} 		= @(x1,x2) c*x1^2/(d+x1^2) -b*x2;

% Jacobian
J 			= cell(2);
J{1,1}	= @(x1,x2) -a;
J{1,2}	= @(x1,x2) -a*x1;
J{2,1}	= @(x1,x2) 2*c*d*x1/(x1^2+d)^2;
J{2,2}	= @(x1,x2) -b;

% initial conditions
x0 			= [3.5, 3.7]';
x(1,1)	= x0(1);
x(2,1)	= x0(2);

for ii = 2:100

	% evaluate the Jacobian
	jj 						= zeros(2,2);
	ff 						= zeros(2,1);
	for qq = 1:2
		ff(qq) 		= f{qq}(x(1,ii-1), x(2,ii-1));
		for ww = 1:2
			jj(qq,ww) = J{qq,ww}(x(1,ii-1), x(2,ii-1));
		end
	end

	% evaluate the new fixed point estimate
	x(:,ii) 			= x(:,ii-1) - inv(jj) * ff;

	% compute the tolerance
	tol 					= max(abs(x(:,ii) - x(:,ii-1)));

	% display
	disp(['[INFO] iteration # ' num2str(ii-1)])
	disp(['[INFO] fixed point estimate: ' mat2str(x(:,ii)')])
	disp(['[INFO] tolerance: ' num2str(tol)])

	% check for convergence
	if tol < 0.0001
		break
	end

end

x1 		= [-10:0.01:10];
x2 		= x1;

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x1, a*x1, 'k');
plot(x1, 1/b*c*x1.^2./(x1.^2+d), 'k');
leg = cell(size(x,2), 1);
leg{1} = 'dx_1/dt = 0';
leg{2} = 'dx_2/dt = 0';
for ii = 1:size(x, 2)
	plot(x(1,ii), x(2,ii), 'o')
	leg{ii+2} = ['#' num2str(ii)];
end

legend(leg, 'Location', 'best')

xlabel('x_1')
ylabel('x_2')
title('phase plot of a dynamical system')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%%
% If you make a bad guess, the assumption of linear approximations in the Jacobian
% is not valid. This sometimes works out, but sometimes doesn't. Specifically, if
% the Jacobian is not positive-definite, which occurs if the Jacobian has complex
% eigenvalues (as in this case). The jump from $x_0$ to $x_1$ is a good one though.

%% 3.1 Other Root
clear x

% initial conditions
x0 			= [1, 7]';
x(1,1)	= x0(1);
x(2,1)	= x0(2);

for ii = 2:100

	% evaluate the Jacobian
	jj 						= zeros(2,2);
	ff 						= zeros(2,1);
	for qq = 1:2
		ff(qq) 		= f{qq}(x(1,ii-1), x(2,ii-1));
		for ww = 1:2
			jj(qq,ww) = J{qq,ww}(x(1,ii-1), x(2,ii-1));
		end
	end

	% evaluate the new fixed point estimate
	x(:,ii) 			= x(:,ii-1) - inv(jj) * ff;

	% compute the tolerance
	tol 					= max(abs(x(:,ii) - x(:,ii-1)));

	% display
	disp(['[INFO] iteration # ' num2str(ii-1)])
	disp(['[INFO] fixed point estimate: ' mat2str(x(:,ii)')])
	disp(['[INFO] tolerance: ' num2str(tol)])

	% check for convergence
	if tol < 0.0001
		break
	end

end

x1 		= [-10:0.01:10];
x2 		= x1;

figure('OuterPosition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
plot(x1, a*x1, 'k');
plot(x1, 1/b*c*x1.^2./(x1.^2+d), 'k');
leg = cell(size(x,2), 1);
leg{1} = 'dx_1/dt = 0';
leg{2} = 'dx_2/dt = 0';
for ii = 1:size(x, 2)
	plot(x(1,ii), x(2,ii), 'o')
	leg{ii+2} = ['#' num2str(ii)];
end

legend(leg, 'Location', 'best')

xlabel('x_1')
ylabel('x_2')
title('phase plot of a dynamical system')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end


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
