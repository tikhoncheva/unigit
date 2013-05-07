clear all
close all
clc

format short
format compact

%%
n = 9;
inds = 0:(n-1);
F = exp(2*pi*1i*(inds'*inds)/n)/sqrt(n);

%% ex1
clear g h H
clc
g = [0,0,0,0,1,1,1,0,0,0];
h = [0,0,0,0,1,2,1,0,0,0];
mat2tex(h)
%h = h/sum(h);
gh = conv(g,h, 'same');
%gh = gh(6:15);
ghh = conv(gh,h);
ghh = ghh(6:15);
hold on
plot(g, 'r')
plot(gh, 'g')
plot(ghh, 'b')

h = h';
for i=1:length(h)
	H(:,i) = h;
	h = circshift(h,1);
end
%mat2tex(H)

g = [0,0,0,0,1,1,1,0,0,0];
h = [0,0,0,0,1,2,1,0,0,0];
gh = conv(g,h, 'same');
%gh = gh(6:15);
[gh;g*H]
mat2tex(g*H)

%% ex2
G = zeros(n,1);
G(3) = 1;
G(n-1) = -1;
G = sqrt(n)*1i/2*G;

disp(G.')
g = F*G;
disp( (g).')

h = (-sin(4*pi*(0:(n-1))/n))';

norm(h-g)