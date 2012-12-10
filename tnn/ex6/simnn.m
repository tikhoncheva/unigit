function [u,spikes] = simnn(x)
% simulate a fully connected pool of 100*2 neurons
% Markus Doering, Thomas Reckow
%
% Input:
%	x		constant input for all neurons
%
% Output: 
%	u		dendritic potential (200x5001)
%	spikes	logical-matrix indicating spikes (200x5000)
%



%% initialization
% some universal constants
n = 200;
dt = .0001;
tau = .02;
rho = dt/tau;
nsteps = 5000;

% reverse potential 
U_1 = 75;
U_2 = -25;
U = [ones(n/2,1)*U_1; ones(n/2,1)*U_2];

% initialize equally distributed on [10,15] resp. [8,13]
u0 = [rand(n/2,1)*5 + 10; rand(n/2,1)*5 + 8]; 

% weight sub-matrices
Clow = ones(n/2)*.058;
Chigh = ones(n/2)*.1;

% weight matrix
C = [Clow Clow;Chigh Chigh];

%% reserve some memory for calculation

% spike memory
spikes = false(n, nsteps);
lastspike = NaN(n,1);

% dendritic potential
u = zeros(n,nsteps+1);
u(:,1) = u0;


%% start the simulation
for step=1:nsteps
	% increment the time since the last spike
	lastspike = lastspike + 1;
	
	% calculate current thresholds
	T = thresh(lastspike);
	
	% check whether neurons spiking
	spikes(:,step) = T <= u(:,step);
	lastspike(spikes(:,step)) = 0;
	
	% calculate new dendritic potentials
	resp = response(lastspike);
	% single activities
	a_ij = bsxfun(@times, C, resp');
	% total activity per channel type
	a_1 = sum(a_ij(1:n/2,:), 1);
	a_2 = sum(a_ij(n/2+1:end,:), 1);
	
	% current input
	currx = getinput(n,x);
	for j = 1:n
		
		u(j,step+1) = (1-rho)*u(j,step) + rho*[a_1(j) a_2(j)]*([U_1;U_2]-u(j,step)) + rho*currx(j);
	end
end

end

function x = getinput(n,x)
% add randomness to input
x = [(rand(n/2,1)-.5)*16; (rand(n/2,1)-.5)*12] + x;
end

function theta = thresh(nsteps)
% determine threshold as a function of the steps since last spike
thetaRest = 13;

if any(nsteps<eps)
	error('Unexpected number of steps (must be positive)');
end

theta = 2500./(nsteps.^2) + thetaRest;

theta(isnan(theta)) = thetaRest;

end

function r = response(nsteps)
% spike response function

if any(nsteps<0)
	error('Unexpected number of steps (must be positive)');
end

r = zeros(size(nsteps));
r(nsteps<10) = .1;

end