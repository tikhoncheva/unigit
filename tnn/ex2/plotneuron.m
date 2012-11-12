function [] = plotneuron(t, Y, varargin)
%PLOTNEURON Summary of this function goes here
%   Detailed explanation goes here

n = 10;
nt = linspace(t(1),t(end),n);
Y = sum(Y,1);
ny = zeros(n-1,size(Y,3));
for i=1:n-1
	for d=1:size(Y,3)
		a = t>nt(i);
		b = t<nt(i+1);
		c = a & b;
		ny(i,d) = mean(Y(:, c, d));
	end
end
for i=1:n-1
	nt(i) = mean(nt(i:i+1));
end
nt = nt(1:end-1);
	

bar(nt,ny);

end

