%% Homework #1
% Alec Hoyland
% September 10th, 2018

pHeader;
tic


%% Problem #2
%% Part A
disp('PROBLEM #2')
disp('PART A')

% set up the vectors pointing to the vertices and centroid
M   = [1 4 1];
N   = [5 2 1];
P   = [6 6 1];
b   = [4 4 1];

bigArea = det([M; N; P])/2;

% the area of a triangle is 1/2 * det(A)
bPN = [b; P; N];
disp('The determinant of the matrix which specifies the coordinates of triangle bPN is')
disp(det(bPN))
disp('The area of triangle bPN is')
disp(det(bPN)/2)

bMP = [b; M; P];
disp('The determinant of the matrix which specifies the coordinates of triangle bMP is')
disp(det(bMP))
disp('The area of triangle bMP is')
disp(det(bMP)/2)

bMN = [b; M; N];
disp('The determinant of the matrix which specifies the coordinates of triangle bMN is')
disp(det(bMN))
disp('The area of triangle bMN is')
disp(det(bMN)/2)

%% Part B
disp('PART B')

b   = [4.5 3 1];
bPN = [b; P; N];
disp('The determinant of the matrix which specifies the coordinates of triangle bPN is')
disp(det(bPN))
disp('The area of triangle bPN is')
disp(det(bPN)/2)

bMP = [b; M; P];
disp('The determinant of the matrix which specifies the coordinates of triangle bMP is')
disp(det(bMP))
disp('The area of triangle bMP is')
disp(det(bMP)/2)

bMN = [b; M; N];
disp('The determinant of the matrix which specifies the coordinates of triangle bMN is')
disp(det(bMN))
disp('The area of triangle bMN is')
disp(det(bMN)/2)

% calculate the percent area of each of the smaller triangles
c = [1/6 2/3 1/6];
area = [det(bPN) det(bMP) det(bMN)] / 2 / bigArea;
disp('The area of the little triangles')
disp(area)
disp('which is suspiciously similar to the fractional contributions towards the barycenter')
disp(c)

%% Problem #3

A = [2 3 7; 1 1 2; 2 2 4];
% find the determinant of A
disp('The determinant of A is')
disp(det(A))
disp('If the determinant of a matrix is zero, the column vectors that comprise the matrix are linearly dependent; no inverse matrix exists.')

a1  = [2 1 2];
a2  = [3 1 2];
a3  = [7 2 4];

disp('A possible zero test vector is [1 -3 1], since a1 + -3a2 + a3 = [0 0 0]')
a1 + -3 * a2 + a3

disp('The vectors span a plane in 2 dimensions')


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
