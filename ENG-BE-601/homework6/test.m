% define a simple matrix
A = [1, 0; 1, 0];
disp('A simple matrix:')
disp(A)

disp('with eigenvalues:')
disp(eig(A))

% define two arbitrary test vectors
v1 = [0.1, 0.9]';
v2 = [0.9, 0.1]';

disp('for test vector v1:')
disp(v1)
gamma = shifted_inverse_power(A, v1, true)

disp('for test vector v2:')
disp(v2)
gamma = shifted_inverse_power(A, v2, true)
