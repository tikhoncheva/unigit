% das ist ein skript, keine funktion (aufruf trotzdem mit "aufgabe2"
% möglich)
%function [] = aufgabe2()

clc
clear all
close all

%Initialisierung der Variablen
tau       = 0.01;
deltaT    = 0.0001;
thetaREST = 10;
thetaABS = 1000;
rho             = deltaT / tau;
AnzGesSchritte  = 10000;
GesZeit         = AnzGesSchritte*deltaT;
zeit = linspace(0,GesZeit,AnzGesSchritte+1);

RefZeitSchritte = 20;
anzahl_neuronen = 10;
dX = 1;
input_range = 8:dX:20;
anzahl_spikes = zeros(input_range,1);

col = lines;
coli = 1;
leg = {};

auserwaehlt = 8:3:20;


% schleife über die verschiedenen inputs 
for k = 1:size(input_range,2)
	
	% Berechne die Eingabe für diesen Eingabewert
	x = input_range(k) + 4*rand(anzahl_neuronen,AnzGesSchritte) - 2;
	
	% haben ein Anfangspotential und dann nach jedem Schritt ein neues, daher die +1
	u = zeros(anzahl_neuronen,AnzGesSchritte + 1); % Init Membranpotential
	% dendritische potentiale: startwerte
	u(:,1) = rand(anzahl_neuronen,1)*10;
	y = zeros(anzahl_neuronen,AnzGesSchritte + 1); % Init Axonales Potential
	theta = thetaREST * ones(anzahl_neuronen,AnzGesSchritte+1); % Init Schwellenpotential

	
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
% 				[theta, letzter_spike]   = set_theta(theta,t+1,RefZeitSchritte, ...
% 					thetaREST, thetaABS, j, letzter_spike);
				letzter_spike(neuron) = step;
			end
			
			% update dendritisches potential
			u(neuron,step+1) = (1.0-rho)*u(neuron,step) + rho*x(neuron,step);
			
		end
	end
	
	anzahl_spikes(k) = nnz(y);
	
	if any(input_range(k)==auserwaehlt)
		spike = any(y>0,1);
		if ~any(spike)
			fprintf(1, 'No spikes at x=%d\n', input_range(k));
		else
			hold on
			plot(zeit(spike), sum(y(:,spike),1), '.', 'Color', col(coli, :))
			leg{coli} = sprintf('x = %d', input_range(k));
			coli = coli+1;
		end
	end
end

legend(leg, 'Location', 'SE')
xlabel('time')
ylabel('# spikes');
title(sprintf('%d neurons spiking', anzahl_neuronen));

figure;
plot(input_range, anzahl_spikes/(GesZeit*anzahl_neuronen), 'rx')
xlabel('x')
ylabel('spikes per time unit per neuron');

