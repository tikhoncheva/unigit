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
mittleres_potential = zeros(size(input_range));

cin_range = 0:.2:4;
selektion = [2 5 10 15 20];
coli = 0;
col = lines;
leg = cell(length(selektion),1);

subplot(1,2,1)
for k=1:length(cin_range)
	cin = cin_range(k);
	
	% Berechne die Eingabe
	x = 11 + 4*rand(anzahl_neuronen,AnzGesSchritte) - 2;
	
	% haben ein Anfangspotential und dann nach jedem Schritt ein neues, daher die +1
	u = zeros(anzahl_neuronen+1,AnzGesSchritte + 1); % Init Membranpotential
	% dendritische potentiale: startwerte
	u(:,1) = rand(anzahl_neuronen+1,1)*10;
	y = zeros(anzahl_neuronen,AnzGesSchritte + 1); % Init Axonales Potential
	theta = thetaREST * ones(anzahl_neuronen,AnzGesSchritte+1); % Init Schwellenpotential
	Uk = [ones(100,1)*60;ones(100,1)*(-20)];
	c = [ones(100,1)*1.2;ones(100,1)*cin];
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
		
		% wie weit zurück müssen wir schauen?
		minind=max(1,step-10);
		% response ergibt sich aus .05 pro spike in den letzten 10 Schritten
		response = sum(y(:,minind:step), 2)*.05;
		
		% Spezialbehandlung für unser Neuron
		u(201,step+1) = (1.0-rho)*u(201,step) + sum(Uk.*c.*response); %+ rho*x(neuron,step);
	end
	
	if any(k==selektion)
		hold on
		coli = coli+1;
		plot(u(201,:), 'Color', col(coli, :))
		leg{coli} = sprintf('c_{in} = %f', cin); 
	end
	mittleres_potential(k) = mean(u(201,:));
end

xlabel('Zeit');
ylabel('dendritisches Potential');
legend(leg, 'Location', 'SE');

subplot(1,2,2)
plot(cin_range, mittleres_potential)
xlabel('c_{in}');
ylabel('mittleres Potential');

% wie groß darf c_in höchstens sein um im Mittel Spikes zu erhalten?
cin_range = cin_range';
mittleres_potential = mittleres_potential';

ab = [ones(size(mittleres_potential)) cin_range] \ mittleres_potential;
min_fuer_spikes = -(ab(1)-10)/ab(2)
