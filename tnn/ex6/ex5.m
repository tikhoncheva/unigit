% Markus Doering, Thomas Reckow

%% Ueberblick verschaffen

clear all
close all
clc
format compact

xs = 6:15;

spikefig = figure;
neurons = figure;

mu = zeros(size(xs));

for i=1:length(xs)
	subplot(3,4,i)
	[u,spikes] = simnn(xs(i));
	mu(i) = sum(u(:))/numel(u);
	spy(spikes(:,1:500));
	
	title(sprintf('Spike plot for input x=%d', xs(i)));
	xlabel('time steps')
	ylabel('neuron index')
	
end

subplot(3,4,length(xs)+1)
plot(xs,mu)
xlabel('input x')
ylabel('mean dendritic potential')


%% ausgewaehlte x

clear all
close all
clc
format compact

xs = [8 12 15];


for i=1:length(xs)
	[u,spikes] = simnn(xs(i));
	
	figure;
	
	%spike plot
	subplot(1,3,1)
	spy(spikes(:,1:500));

	title(sprintf('Spike plot for input x=%d', xs(i)));
	xlabel('time steps')
	ylabel('neuron index')
	
	
	%potentials
	for t=0:1
		subplot(1,3,2+t)
		ind = 1:5;
		if t
			ind = ind + 100;
		end
		plot(u(ind,:)')
		xlabel('time steps')
		ylabel('dendritic potential')
		legend('1', '2', '3', '4', '5', 'Location', 'Best')
		title(sprintf('Dendritic potential in pool %d', t+1));
	end

	
end