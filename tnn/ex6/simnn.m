function [u,spikes] = simnn(x)
% simulate a fully connected pool of 100*2 neurons
% Markus Doering, Thomas Reckow
%
% Input:
%	x		constant input for all neurons
%
% Output: 
%	u		dendritic potential (200x5001)
%	spikes	1-or-0-matrix indicating spikes (200x5000)
%



%% initialization
% some universal constants
n = 200;
dt = .0001;
tau = .02;
nsteps = 5000;

% reverse potential 
U = [ones(n/2,1)*75; -ones(n/2,1)*25];

% initialize equally distributed on [10,15] resp. [8,13]
u0 = [rand(n/2,1)*5 + 10; rand(n/2,1)*5 + 8]; 

% weight sub-matrices
Clow = ones(n/2)*.058;
Chigh = ones(n/2)*.1;

% weight matrix
C = [Clow Clow;Chigh Chigh];

%% reserve some memory for calculation

% steps since last spike
nsteps = zeros(n,1);

% spike memory
spikes = zeros(n, nsteps);

% dendritic potential
u = zeros(n,nsteps+1);
u(:,1) = u0;


%% start the simulation
for step=1:nsteps
	%@Tom
	%bipetibapetibu
end

end

function x = getinput(n,x)
% add randomness to input
x = [(rand(n/2,1)-.5)*16; (rand(n/2,1)-.5)*12] + x;
end

function theta = thresh(nsteps)
% determine threshold as a function of the steps since last spike
thetaRest = 13;

if any(nsteps)<eps
	error('Unexpected number of steps (must be positive)');
end

theta = 2500./(nsteps.^2) + thetaRest;

end

function r = response(nsteps)
% spike response function

if any(nsteps)<0
	error('Unexpected number of steps (must be positive)');
end

r = zeros(size(nstep));
r(nstep<10) = .1;

end