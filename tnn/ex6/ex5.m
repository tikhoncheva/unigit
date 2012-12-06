clear all
close all
clc
format compact

xs = 6:15;


for i=1:length(xs)
	subplot(2,5,i)
	[u,spikes] = simnn(xs(i));
	
	spy(spikes(:,1:500));
	
	title(sprintf('Spike plot for input x=%d', xs(i)));
	xlabel('time steps')
	ylabel('neuron index')
	
end