clc
% clear all
close all

%Initialisierung der Variablen
tau       = 0.01;
deltaT    = 0.0001;
thetaREST = 10;
thetaABS = 1000;
rho             = deltaT / tau;
AnzGesSchritte  = 20000;
GesZeit         = AnzGesSchritte*deltaT;
zeit = linspace(0,GesZeit,AnzGesSchritte+1);

RefZeitSchritte = 20;
anzahl_neuronen = 200;
dX = 1;
input_range = 8:dX:20;

cin_range = 0:.1:2;


cin = .55;
% Berechne die Eingabe für diesen Eingabewert
x = 11 + 4*rand(anzahl_neuronen,AnzGesSchritte) - 2;

% haben ein Anfangspotential und dann nach jedem Schritt ein neues, daher die +1
u = zeros(anzahl_neuronen+1,AnzGesSchritte + 1); % Init Membranpotential
% dendritische potentiale: startwerte
u(:,1) = rand(anzahl_neuronen+1,1)*10;
y = zeros(anzahl_neuronen,AnzGesSchritte + 1); % Init Axonales Potential
theta = thetaREST * ones(anzahl_neuronen,AnzGesSchritte+1); % Init Schwellenpotential
Uk = [ones(100,1)*60;ones(100,1)*(-20)];
c = [ones(100,1)*1.2;ones(100,1)*cin];
r = zeros(anzahl_neuronen,1);

%Variablen, die geaendert werden muessen
letzter_spike = NaN(anzahl_neuronen,1);

for step = 1:AnzGesSchritte
	% schleife über die neuronen im NN
	for neuron = 1:anzahl_neuronen
		
		% prüfe wie die schwelle liegt
		if step - letzter_spike(neuron) <= 20 % ist false wenn NaN vorkommt
			theta(neuron,step) = thetaABS;
		elseif ~isnan(letzter_spike(neuron))
			theta(neuron,step) = 100/(step - letzter_spike(neuron) -10) + 10;
		end
		
		% prüfe ob spike auftritt
		if  u(neuron,step) >= theta(neuron,step)
			y(neuron,step) = 1;
			letzter_spike(neuron) = step;
		end
		
		% update dendritisches potential
		u(neuron,step+1) = (1.0-rho)*u(neuron,step) + rho*x(neuron,step);
		
	end
	
	% hier wird unser spezielles neuron behandelt
	m=max(1,step-10);
	r = sum(y(:,m:step), 2)*.05;
	u(201,step+1) = (1.0-rho)*u(201,step) + sum(Uk.*c.*r); %+ rho*x(neuron,step);
end

plot(u(201,:))
