%% Homework #5
% Alec Hoyland
% 09:33 2018-10-9

pHeader;
tic

%% Problem 1.1
% find the eigenvalues and eigenvectors of matrix A.
% <</code/homework/ENG-BE-601/homework5_1_fig.eps>>

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
%   if 6 == nnz([C2(1, combs(ii, 1)) C2(1, combs(ii, 2)) C2(2, combs(ii, 1)) C2(2, combs(ii, 2)) C2(3, combs(ii, 1)) C2(3, combs(ii, 2))]) &&
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
