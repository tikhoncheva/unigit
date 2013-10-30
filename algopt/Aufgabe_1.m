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

%TODO auf 50 setzen
% maximale betrachtete Dimension
N = 50;

% Vorbelegen der Ausgabevektoren
fval_ga(1,N) = 0;
fval_fminsearch(1,N) = 0;
fval_fminunc(1,N) = 0;

% Startwert für fminsearch und fminunc
x0 = zeros(N,1);
	
% iteriere über die Dimension des Rosenbrockproblems
for i=2:1:N
	
    % Finde Minimum der Rosenbrock-Funktion mit Hilfe des Genetischen
    % Algorithmus (Optimieren einer Fitnessfunktion über mehrere
    % Generationen)
	options = gaoptimset('Display', 'off');
    [~, fval_ga(1,i)] = ga(@rosenbrock_for_ga, N, options);
	

    % Finde Minimum per 'Nelder-Mead Simplex Method'
    options = optimset('Display','Off');
    [~, fval_fminsearch(1,i)] = fminsearch(@rosenbrock, x0(1:i), options);

    % Finde Minimum per 'interior-reflective Newton method'
    options = optimoptions('fminunc','GradObj','on','Display','Off');
    [~, fval_fminunc(1,i)]=fminunc(@rosenbrock, x0(1:i), options);
end

figure;
hold on
plot(1:N, fval_ga, '-*g');
plot(1:N, fval_fminsearch, '-*r');
plot(1:N, fval_fminunc, '-*b');
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
%
function [f, df]= rosenbrock(x)
% Funktion rosenbrock(x) berechnet den Funktionswert $f(x)$ und den Gradientwert von der Rosenprockfunktion im Punkt $x$

% Dimension des Vektors
N= length(x);

% berechne den Fuktionswert
f = rosenbrock_for_ga(x);

% berechne den Gradientwert

xh = x(3:end);
xm = x(2:end-1);
xl = x(1:end-2);

df(N,1) = 0;

% generell: $2\leq i \leq N-1$
df(2:end-1) = -400*(xh-xm.^2).*xm - 2*(1-xm) + 200*(xm - xl.^2);

% speziell: $i=1$
df(1) = -400*(x(2)-x(1)^2)*x(1) - 2*(1-x(1));

% speziell: $i=N$
df(N) = 200*(x(N)-x(N-1).^2);

end


%% Zusammenfassung
%
% Anhand der Ergebnisse lässt sich schließen, dass die Methode fminsearch
% die beste Approximation von $x^{*}$ liefert. Das schlechteste Ergebnis
% rechnet die Funktion ga aus. Bei den größeren Dimensionen sind alle drei
% Approximationen sehr weit vom Optimum entfernt.
