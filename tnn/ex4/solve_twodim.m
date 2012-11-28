function [u, success] = solve_twodim(C,u0)
%compute u(t) for a linear system of 2 neurons without external input
%
% Input: 
%	C	system matrix (i.e. C-I)
%	u0	initial conditions
%
% Output:
%	u	function handle (one parameter)
%	success	false, if initial conditions could not be met
%
% Übungsblatt 3 Aufgabe 4
% Thomas Reckow, Markus Döring


success = true;

% compute eigenvectors and eigenvalues
[V, D] = eig(C);

% create vector of eigenvalues
lambda = diag(D);

if any(imag(V(:,1)))
	% we got imaginary eigenvectors, let's use a combination of
	% the real and imaginary parts 
	mu = real(lambda(1));
	nu = imag(lambda(1));
	lambda = [mu;nu];
	a = real(V(:,1));
	b = imag(V(:,1));
	
	% solution base
	V1 = @(t) exp(mu*t)*(a*cos(nu*t) - b * sin(nu*t));
	V2 = @(t) exp(mu*t)*(a*sin(nu*t) + b * cos(nu*t));
else
	% solution base
	V1 = @(t) exp(lambda(1)*t)*V(:,1);
	V2 = @(t) exp(lambda(2)*t)*V(:,2);
end


V0 = [V1(0) V2(0)];

% V0 is now the base for solutions at t=0, we just have to combine its 
% columns to meet the initial conditions


if rcond(V0) < .001
	% uh-oh, seems like it could be difficult to combine these columns 
	% (they are linearly dependent)
	% let's combine one initial condition and hope for the best
	if V0(1,2) > eps
		s = [0; u0(1)/V0(1,2)];
	else
		s = [u0(1)/V0(1,1); 0];
	end
	
	if abs(u0(2)-V0(2,:)*s) > eps
		% yep, didn't work
		disp('Warning: initial conditions not met.')
		%disp(u0')
		%disp( (V0*s)' )
		success = false;
	end
else
	% straightforward 
	s = V0\u0;
end
	
% the ultimate function handle
u = @(t) combine(s, V1, V2, t);

end

function v = combine(s, V, W, t)
% linear combination s of two function handles V and W evaluated at t
n = length(t);
v = zeros(2, n);
for i=1:n
	v(:,i) = [V(t(i)) W(t(i))] * s;
end

end
