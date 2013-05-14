
%% 4c

clear all
close all
clc

col = lines;

c = 1;
Fh_exact = @(w) 1i.*w.*(abs(w)<=c);
h_exact = @(x)1/pi*(c.*x.*cos(c.*x)-sin(c.*x))./x.^2;
ns = [3 5 7 15 21];
ws = linspace(-c,c);
plot(ws,abs(Fh_exact(ws)),'k')
hold on
leg = {'exact filter'};
for i=1:length(ns)
	n = ns(i);
	ks = -n:n;
	
	% h_exact is 0 at k=0
	ks = ks([1:n n+2:end]);
	
	h_approx = 0;
	for j=1:length(ks)
		h_approx = h_approx + h_exact(ks(j))*exp(-1i*ks(j)*ws);
	end
	plot(ws, abs(h_approx), 'color', col(i,:))
	leg{end+1} = sprintf('approximated filter (n=%d)', n);
end

legend(leg, 'location', 'best')

