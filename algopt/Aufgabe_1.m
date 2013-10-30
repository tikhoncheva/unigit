%% Programmieraufgabe 1: Optimierungsverfahren benutzen
%
% Wir betrachten das verallgemeinerte N-dimansionale Rosenbrockproblem
%
% $$\min_{x\in\rm{I}\!R^N} f(x) = \sum_{i=1}^{N-1}[100(x_{i+1}-x_{i}^2)^2+(1-x_i)^2].$$
%
% Offensichtlich ist $f(x)\ge 0$. d.h. als Optimum käme ein Punkt in Frage,
% an dem $f(x)=0$ gilt. 
% Die Summe von Quadraten kann ist genau dann gleich 0, wenn jeder
% Summand gleich 0 ist. Daraus folgt, dass $x^{*}=(1,\ldots,1)$ ein globales
% Optimum von $f$ ist. 
%

%% function Aufgabe_1()
%
% Funktion vergleicht drei verschiedene Methoden zur Optimierung von $f$.
%
function Aufgabe_1()

% aufräumen
clear all
close all
clc

%maximale betrachtete Dimension
N = 5;

% Vorbelegen der Ausgabevektoren
fval_ga(1,N) = 0;
fval_fminsearch(1,N) = 0;
fval_fminunc(1,N) = 0;

% iteriere über die Dimension des Rosenbrockproblems
for i=2:1:N
	
    % Finde Minimum der Rosenbrock-Funktion mit Hilfe des Genetischen
    % Algorithmus (Optimieren einer Fitnessfunktion über mehrere
    % Generationen)
	options = gaoptimset('Display', 'off');
    [~, fval_ga(1,i)] = ga(@rosenbrock_for_ga, N, options);
	
    % Startwert für fminsearch und fminunc
    x0 = zeros(N,1);
	
	% Finde Minimum per 'Nelder-Mead Simplex Method'
    options = optimset('Display','Off');
    [~, fval_fminsearch(1,i)] = fminsearch(@rosenbrock, x0, options);
	
	%TODO Funktioniert auf meinem R2009b nicht
    %options = optimoptions('fminunc','GradObj','on','Display','Off');
    %[~, fval_fminunc(1,i)]=fminunc(@rosenbrock, x0, options);
end

figure;
hold on
plot(1:N, fval_ga, '-*g');
plot(1:N, fval_fminsearch, '-*r');
% plot(1:N, fval_fminunc, '-*b');
legend('ga','fminsearch','fminunc');

end

%% function f = rosenbrock_for_ga(x)

function f = rosenbrock_for_ga(x)
% Funktion rosenbrock_for_ga(x) berechnet den Funktionswert $f(x)$
%

x = reshape(x, numel(x),1);

% verschiebe x um eine Stelle nach oben
xpp = x(2:end);
x = x(1:end-1);

f = sum(100 * (xpp - x.^2).^2 + (1 - x).^2);

end
%% function [f, df] = rosenbrock(x)
%
% Funktion rosenbrock(x) berechnet den Funktionswert $f(x)$ und den Gradientwert von der Rosenprockfunktion im Punkt $x$
%
function [f, df]= rosenbrock(x)
% Dimension des Vektors
N= length(x);

% berechne den Fuktionswert
f = rosenbrock_for_ga(x);

% berechne den Gradientwert
%TODO geht schneller, sh. rosenbrock_for_ga
df(N,1)=0;
df(1,1)=-200*(x(2)-x(1))*2*x(1)-2*(1-x(1));
df(N,1)= 200*(x(N)-x(N-1)*x(N-1));
for i=2:1:N-1
   df(i,1)=-200*(x(i+1)-x(i))*2*x(i)-2*(1-x(i))+200*(x(i)-x(i-1)*x(i-1));
end
end
%% Zusammenfassung
%
% Anhand der Ergebnisse laesst sich schliessen, dass die Methode fminsearch
% die beste Approximation von $x^{*}$ liefert. Das schlechteste Ergebnis
% rechnet die Funktion ga aus. Bei den groesseren Dimensionen sind alle drei
% Approximationen sehr weit vom Optimum entfernt.