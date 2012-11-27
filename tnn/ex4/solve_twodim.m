function [u] = solve_twodim(C,u0)
%compute u(t) 

[V, D] = eig(C);

lambda = diag(D);

if any(imag(V(:,1)))
	mu = real(lambda(1));
	nu = imag(lambda(1));
	lambda = [mu;nu];
	a = real(V(:,1));
	b = imag(V(:,1));
	
	V1 = @(t) exp(mu*t)*(a*cos(nu*t) - b * sin(nu*t));
	V2 = @(t) exp(mu*t)*(a*sin(nu*t) + b * cos(nu*t));
else
	V1 = @(t) exp(lambda(1)*t)*V(:,1);
	V2 = @(t) exp(lambda(2)*t)*V(:,2);
end

V0 = [V1(0) V2(0)];

if rcond(V0) < .001
	
	if V0(1,2) > eps
		s = [0; u0(1)/V0(1,2)];
	else
		s = [u0(1)/V0(1,1); 0];
	end
	
	if abs(u0(2)-V0(2,:)*s) > eps
		disp('Warning: initial conditions not met.')
		disp(u0')
		disp( (V0*s)' )
	end
else
	s = V0\u0;
end
	


u = @(t) combine(s, V1, V2, t);

end

function v = combine(s, V, W, t)
n = length(t);
v = zeros(2, n);
for i=1:n
	v(:,i) = [V(t(i)) W(t(i))] * s;
end

end