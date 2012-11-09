function [] = aufgabe1()

%Initialisierung der Variablen
tau       = 0.01;
deltaT    = 0.001;
thetaABS  = 1000;
thetaREL  = 50;
thetaREST = 10;
rho             = deltaT / tau;
GesZeit         = 20;
AnzGesSchritte  = GesZeit / deltaT;
count           = 0;
output          = zeros(size(5:0.5:15));
RefZeitSchritte = 2;

%Variablen, die geaendert werden muessen
alpha           = 0;    % Noise, wichtig fuer Teil b,c,d
input = [5:0.5:15]; % fuer Teil a
%input = [9]; % fuer Teil b,c,d x = 9

for x = input 
	u = zeros(1,AnzGesSchritte); % Init Membranpotential
	y = zeros(1,AnzGesSchritte); % Init Axonales Potential
	theta = thetaREST * ones(1,AnzGesSchritte); % Init Schwellenpotential

    for t = 2:AnzGesSchritte
        u(t) = (1.0-rho)*u(t-1) + rho*(x + alpha*randn);
        if  u(t) >= theta(t)
            y(t) = 1;
            %u(t) = 0; %wichtig fuer Teil d
            theta  = set_theta(theta,t+1,RefZeitSchritte,thetaABS,...
                               thetaREL,thetaREST);
        end
    end 

    count = count + 1;
	output(count) = sum(y)/GesZeit;
    
    %fuer Teil a
    if x==11
        u11 = u;
        theta11 = theta;
    end
    
end

% nur bei a
if 1
    figure(1);
    plot(5:0.5:15,output);
    title(['Mittlere Spikerate,  noise = ',num2str(alpha)]);
    xlabel('x');
    ylabel('Mittlere Spikerate');

    figure(2);
    plot(u11(1:1000));
    title('Dendritisches Potential bei x = 11');
    xlabel('Schritte');
    ylabel('u(t)');

    figure(3);
    plot(theta11(1:1000));
    title('Schwellenfunktion bei x = 11');
    xlabel('Schritte');
    ylabel('theta(t)');
end

% bei b,c,d
if 0
    figure(2);
    plot(u(1:1000));
    title(['Dendritisches Potential bei x = 9 und noise = ',num2str(alpha)]);
    xlabel('Schritte');
    ylabel('u(t)');

    figure(3);
    plot(theta(1:1000));
    title('Schwellenfunktion bei x = 9');
    xlabel('Schritte');
    ylabel('theta(t)');
end
end


function theta = set_theta(theta, zeit, RefZeitSchritte, thetaABS, ...
                           thetaREL, thetaREST)
z = zeit;
%RefZeitSchritte = 2, also ist zwei Schritte lang theta = thetaABS
    while  z < zeit + RefZeitSchritte && z <= size(theta,2)
        theta(z) = thetaABS;
        z = z + 1;
    end
% Schwellenfunktion beginnt bei thetaREL und sinkt dann bis thetaREST
v = thetaREL; 
a = 0.9;
    while  v >= thetaREST && z <= size(theta,2)
        theta(z) =  v;
        z    = z + 1;
        v    = a * v;
    end
end


%b) Bei einem festen Input von x=9 reicht das zusaetzliche Rauschen nicht
%aus um im Simulationszeitraum Spikes zu verursachen. Das dendritische
%Potential schwankt, erreicht aber die Schwelle nicht.
%c) Durch das Erhoehen des Rauschens um den Faktor 3 werden immer wieder
%Spikes ausgeloest. Die Interspike-Intervalle sind sehr ungleichmaessig
%verteilt.
%d)Auch hier werden unregelmaessig Spikes ausgeloest. Allerdings dauert es
%nach einem Spike etwas bis das dedritische Potential wieder genug
%angestiegen ist, um einen neuen Spike auszuloesen.