%% Homework #5
% Alec Hoyland
% 09:33 2018-10-9

pHeader;
tic

%% Problem #1
% find the eigenvalues and eigenvectors of matrix A.
% The eigenvectors cause a flattening of the shape. This is because one of the eigenvalue/vector pairs is zero.
% This flattens the shape into 2 dimensions. Since the other two eigenvalues are equal, the flattening is symmetric.
% Two of the vertices are compressed into a single one at the origin. In addition, because two of the eigenvalues
% are 1, the shape is shifted in space one unit in those two dimensions, resulting in a recentering over the origin.
%
% <</home/ahoyland/code/homework/ENG-BE-601/homework5_1_fig.png>>

A = 1/3 * [2, -1, -1; -1, 2, -1; -1, -1, 2]
disp('The eigenvalues are:')
disp(eig(A))
disp('The diagonal matrix of eigenvalues is:')
[V, D] = eig(A);
disp(V)
disp('The right eigenvectors (columns) are:')
disp(D)

% set up a matrix representation of a cube
C = [0 1 1 0 0 1 1 0; 0 0 0 0 1 1 1 1; 0 0 1 1 0 0 1 1] + [1; 1; 1];

%% Problem #2
% Markov chain for a zombie apocalypse scenario

disp('columns are total exit transition probabilities')
A = [3/5, 1/5, 1/10, 0; 1/5, 2/5, 0, 0; 0, 1/5, 8/10, 1/10; 1/5, 1/5, 1/10, 9/10]

% set up our time-evolution matrix
u = zeros(4, 101);
u(:, 1) = [98, 0, 2, 0];

% evolve with time
for ii = 2:length(u)
  u(:, ii) = A * u(:, ii-1);
end

figure;
plot(0:100, u')
xlabel('time')
ylabel('population')
title('the walking dead at steady-state')
legend({'well', 'sick', 'zombie', 'dead'})

prettyFig()

if being_published
  snapnow
  delete(gcf)
end


disp(['It takes ' num2str(find(sum(transpose(diff(transpose(u)) < 0.0001)) >= 4, 1)) ' time steps to reach 4-decimal steady-state precision'])

s = eig(A);
s = s ./ min(s);
x = 100 / sum(s);
u_inf = x * s;


% figure;
%
% % plot the vertices of the cube
% scatter3(C(1,:), C(2,:), C(3,:), 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
% hold on;
%
% % plot the edges of the cube
% combs = combnk(1:length(C), 2);
% for ii = 1:length(combs)
%   if 2 <= single(C(1, combs(ii, 1)) == C(1, combs(ii, 2))) + single(C(2, combs(ii, 1)) == C(2, combs(ii, 2))) + single(C(3, combs(ii, 1)) == C(3, combs(ii, 2)))
%     line([C(1, combs(ii, 1)) C(1, combs(ii, 2))], [C(2, combs(ii, 1)) C(2, combs(ii, 2))], [C(3, combs(ii, 1)) C(3, combs(ii, 2))], 'Color', 'k')
%   end
% end
%
% % color the surfaces
% vert = C';
% fac = [1 2 6 5;3 4 8 7;1 2 3 4;];
% patch('Vertices', vert, 'Faces', fac, 'FaceAlpha', 0.4)
%
% % plot the unit line
% plot3([0 1], [0 1], [0 1], '--k')
%
% % plot the transformed vertices
% C2 = A * C;
% scatter3(C2(1,:), C2(2,:), C2(3,:), 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
%
% % plot the transformed edges
% combs = combnk(1:length(C2), 2);
% for ii = 1:length(combs)
%   if 6 == nnz([C2(1, combs(ii, 1)) C2(1, combs(ii, 2)) C2(2, combs(ii, 1)) C2(2, combs(ii, 2)) C2(3, combs(ii, 1)) C2(3, combs(ii, 2))])
%     disp('ping')
%     line([C2(1, combs(ii, 1)) C2(1, combs(ii, 2))], [C2(2, combs(ii, 1)) C2(2, combs(ii, 2))], [C2(3, combs(ii, 1)) C2(3, combs(ii, 2))], 'Color', 'k')
%   end
% end
%
% % color the transformed surfaces
% vert = C2';
% fac = [1 2 6 5;3 4 8 7;1 2 3 4;];
% patch('Vertices', vert, 'Faces', fac, 'FaceAlpha', 0.4, 'EdgeColor', 'none')
%
% % make red what must be
% scatter3([0 1], [0 1], [0 1], 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
%
% xlabel('x-axis')
% ylabel('y-axis')
% zlabel('z-axis')

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
