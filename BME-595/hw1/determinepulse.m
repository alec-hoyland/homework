function p = determinepulse(V,tau)
%
% Name: determinepulse
%
% Inputs:
%    V - A complex number, representing a rotating vector 
%        in rectangular form
%    tau - a scalar value representing pulse duration in radians
% Outputs:
%    p - a scalar value representing the pulse state
%
% Created by: Adam C. Lammert (2022)
% Author: ??? (you)
%
% Description: Determine the pulse state associated with rotating vector V.
%              The pulse begins at angle -tau/2, remains high (1) until 0,
%              and then becomes low (-1) until tau/2. The pulse remains off
%              (0) between tau/2 and -tau/2.
%

phase_angle = angle(V);
p = zeros(length(V), 1);

p((phase_angle > (-tau/2)) & (phase_angle < 0)) = 1;
p((phase_angle > 0) & (phase_angle < (tau/2))) = -1;
return
%eof