function V = makerotvec(r,theta)
%
% Name: makerotvec
%
% Inputs:
%    r - a scalar value, representing the length of a rotating vector
%    theta - a scalar value, representing the angle of a rotating vector 
%            in radian
% Outputs:
%    V - A complex number, representing a rotating vector 
%        in rectangular form
%
% Created by: Adam C. Lammert (2022)
%
% Description: Creates a rotating vector, represented in rectangular form,
%              based on inputs specifying the length and angle of the vector
%

j = sqrt(-1); % Define the imaginary unit

V = r*cos(theta) + j*r*sin(theta); % Define rotating vector

return
%eof