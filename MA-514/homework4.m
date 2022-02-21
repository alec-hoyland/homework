%% Problem #1
%   Do 11.3.

[x, A, b] = problem_11_3();

% (a)
disp('11.3 (a)')
x(:, 1)

% (b)
disp('11.3 (b)')
x(:, 2)

% (d)
disp('11.3 (d)')
x(:, 4)

% (e)
disp('11.3 (e)')
x(:, 5)

% (f)
disp('11.3 (f)')
x(:, 6)

%% Problem #2
    % Do 11.3c

% (c)
disp('11.3 (c)')
x(:, 3)

%% Problem #3
%   I didn't notice any of these being overly off.
%   I plotted them and found them to be basically on top of each other.

plot(x)
sum(diff(x))

%% Problem #4
    % Truncated svd with p = 6, 8, 10
    % We see that singular values decay sharply after p = 6
    % so that singular values 7-10 don't add much to the reconstruction.

% Compute reduced SVD
[U, S, V] = svd(A, 'econ');

figure
hold on
for p = [6, 8, 10]
    c_svd = truncated_svd(U, S, V, b, p);
    plot(A * c_svd)
end
legend({'p=6', 'p=8', 'p=10'})

figure
subplot(1, 2, 1)
plot(diag(S))
axis square

xlabel('index')
ylabel('singular value')
subplot(1, 2, 2)
plot(diag(S))
axis square
set(gca, 'YScale', 'log')
xlabel('index')
ylabel('singular value')

%% Problem #5
    % Randomized projection

m = 10000;
n = 100;
t = linspace(0, 1, m);
A = vander(t);
A = A(:, 1:n);

tic;
svd(A, 'econ');
t_svd = toc;

k = 10; p = 5;
tic;
rsvd(A, k, p);
t_rsvd = toc;

disp(['rsvd is ', num2str(round(t_svd / t_rsvd, 2)) 'x faster than svd.'])

function [U,S,V] = rsvd(A, K, P)
    %-------------------------------------------------------------------------------------
    % random SVD
    % Extremely fast computation of the truncated Singular Value Decomposition, using
    % randomized algorithms as described in Halko et al. 'finding structure with randomness
    %
    % usage : 
    %
    %  input:
    %  * A : matrix whose SVD we want
    %  * K : number of components to keep
    %
    %  output:
    %  * U,S,V : classical output as the builtin svd matlab function
    %-------------------------------------------------------------------------------------
    % Antoine Liutkus  (c) Inria 2014
    [M,N] = size(A);

    if nargin < 3
        P = min(2*K,N);
    end
    X = randn(N,P);
    Y = A*X;
    W1 = orth(Y);
    B = W1'*A;
    [W2,S,V] = svd(B,'econ');
    U = W1*W2;
    K=min(K,size(U,2));
    U = U(:,1:K);
    S = S(1:K,1:K);
    V=V(:,1:K);
end % rsvd
function c = truncated_svd(U, S, V, b, p)
    c = zeros(size(U, 2), 1);
    for ii = 1:p
        c = c + (1 / S(ii, ii)) * V(:, ii) * U(:, ii)' * b;
    end
end % truncated_svd

function [x, A, b] = problem_11_3()
    format long;
    m = 50; n = 12;
    t = linspace(0,1,m);
    A = fliplr(vander(t));
    A = A(:,1:12);
    b = cos(4*t)';
    %(a) Normal equations
    R = chol(A'*A);
    x1 = R\(R'\(A'*b));
    %(b) QR factorization computed by mgs
    [Q, R] = mgs(A);
    x2 = R\(Q'*b);
    %(c) QR factorization computed by house
    [W, R] = house(A);
    Q = formQ(W);
    Q = Q(:,1:n);
    x3 = R\(Q'*b);
    %(d) QR factorization
    [Q, R] = qr(A);
    x4 = R\(Q'*b);
    %(e) x = A\b in MATLAB
    x5 = A\b;
    %(f) SVD
    [U, S, V] = svd(A,0);
    x6 = V*(S\(U'*b));
    x = [x1, x2, x3, x4, x5, x6];
end %poly_apprx

function [W, R] = house(A)
    % Householder triangularization
    [m, n] = size(A);
    if (m<n)
        error('number of rows cannot be smaller than number of columns.');
    end
    
    W = zeros(m,n);
    
    for k=1:n
        x = A(k:m, k);
        if (x(1)>=0)
        sgn = 1;
        else
        sgn = -1;
        end
        v = sgn*norm(x,2)*eye(m-k+1,1)+x;
        v = v/norm(v,2);
        A(k:m, k:n) = A(k:m, k:n) - 2*(v*v')*A(k:m, k:n);
        W(k:m,k) = v;
    end

    R = A(1:n,:);
end % house


function [Q, R] = mgs(A)
    % Modified Gram-Schmidt
    [m, n] = size(A);

    if (m<n)
        error('number of rows must be no less than number of columns.');
    end

    Q = zeros(m,n);
    R = zeros(n,n);
    for i=1:n
        Q(:, i) = A(:, i);
    end

    for i=1:n
        R(i,i) = norm(Q(:,i),2);
        Q(:,i) = Q(:,i)/R(i,i);
        for j = (i+1):n
            R(i,j) = Q(:,i)'*Q(:,j);
            Q(:,j) = Q(:,j) - R(i,j)*Q(:,i);
        end
    end

end % function

function Q = formQ(W)
    [m, n] = size(W);
    
    if (m<n)
        error('number of rows cannot be smaller than number of columns.');
    end
    
    Q = eye(m,m);
    
    for k = 1:m
        Q(:,k) = formQx(W,Q(:,k));
    end
end %formQ

function y = formQx(W, x)
    [m, n] = size(W);

    if (m<n)
        error('number of rows cannot be smaller than number of columns.');
    end

    if (~isvector(x))
        error('x must be a vector.');
    elseif (length(x) ~= m)
        error('length of x must agree with the number of rows for W.');
    end

    for k = n:-1:1
        x(k:m) = x(k:m)-2*W(k:m,k)*(W(k:m,k)'*x(k:m));
    end
    y = x;
end %formQx