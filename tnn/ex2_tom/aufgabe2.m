function [] = aufgabe2()

%Initialisierung der Variablen
tau       = 0.01;
deltaT    = 0.0001;
thetaABS  = 1000;
thetaREL  = 50;
thetaREST = 10;
rho             = deltaT / tau;
GesZeit         = 20;
AnzGesSchritte  = GesZeit / deltaT;
count           = 0;
RefZeitSchritte = 20;
anzahl_neuronen = 1;
input_range = [8:1:20];

%Variablen, die geaendert werden muessen
input = zeros(anzahl_neuronen, size(input_range,2));
output = zeros(anzahl_neuronen, size(input_range,2));
letzter_spike = 0;

for k = 1:size(input_range,2)
    for j = 1:anzahl_neuronen
        input(j,k) = 12*rand+8;
    end
end

for j = 1:anzahl_neuronen
    
    for x = input(j,:) 
        u = zeros(anzahl_neuronen,AnzGesSchritte); % Init Membranpotential
        y = zeros(anzahl_neuronen,AnzGesSchritte); % Init Axonales Potential
        theta = thetaREST * ones(anzahl_neuronen,AnzGesSchritte); % Init Schwellenpotential

        for t = 2:AnzGesSchritte
            u(j,t) = (1.0-rho)*u(j,t-1) + rho*(x + (4*randn-2));
            if  u(j,t) >= theta(j,t)
                y(j,t) = 1;
                [theta, letzter_spike]   = set_theta(theta,t+1,RefZeitSchritte, ...
                                   thetaREST, j, letzter_spike);
            end
        end 

        count = count + 1;
        output(j,count) = sum(y(j,:))/GesZeit;
    
    end
    
 end


    figure(1);
    plot(y);



end


function [theta, letzter_spike]  = set_theta(theta, zeit, RefZeitSchritte,  ...
                            thetaREST, neuron, letzter_spike)
z = zeit;
v = thetaREST;
%RefZeitSchritte = 20, also ist 20 Schritte lang theta = thetaABS
    while  z < zeit + RefZeitSchritte && z <= size(theta,2)
        theta(neuron,z) =  v;
        z    = z + 1;
        if(letzter_spike ~= 10)
            v    = 100 / (letzter_spike-10);
        end
        if(v < 0)
            v    = 0;
        end
    end
    
    letzter_spike = zeit;
end
