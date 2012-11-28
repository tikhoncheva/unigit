% Übungsblatt 3 Aufgabe 4
% Thomas Reckow, Markus Döring


clear all
close all
clc
format compact

ci = 0;

arange = [1 2];
brange = [.5, 1, 2];

t = 0:.01:50;

u0 = [1;1];


for i=1:length(arange)
	a = arange(i);
	for j=1:length(brange)
		b = brange(j);
		ci = ci+1;
		subplot(length(arange), length(brange), ci);
		C = [a b;-b 0] - eye(2);
		[u,success] = solve_twodim(C, u0);
		
		plot(u(t)');
		title(sprintf('\\alpha = %.1f, \\beta = %.1f', a, b));
		legend('u_1', 'u_2');
		
	end
end
