%% Theorie neuronaler Netze - Aufgabenblatt 1
% Markus Döring
% Thomas Reckow
%




%% simulate (a)-(c)

clear all
close all
clc

% get a new neural network
NN = NeuralNetwork();
NN.setupSimple();

% define current excercise
section = 'c';

% sensoric input
switch section
	case 'a'
		x = 5:.5:15;
	case 'b'
		x = 9;
	case 'c'
		x = 9;
	otherwise 
		error('Don''t know what section you''re talking about');
end

for i=1:length(x)
	
	% choose input x depending on current excercise
	switch section
		case 'a'
			NN.neuron(1).input = @(t) x(i)*ones(size(t));
		case 'b' 
			if abs(x(i)-9)<eps
				NN.neuron(1).input = @(t) x(i)*ones(size(t)) + randn(size(t));
			else
				NN.neuron(1).input = @(t) x(i)*ones(size(t));
			end
		case 'c' 
			if abs(x(i)-9)<eps
				NN.neuron(1).input = @(t) x(i)*ones(size(t)) + 3*randn(size(t));
			else
				NN.neuron(1).input = @(t) x(i)*ones(size(t));
			end
		otherwise 
			error('Don''t know what section you''re talking about');
	end
	
	% simulate over 20 time units
	[u,thresh,spike] = NN.simulate(20);
	
	% save for later 
	U{i} = u;
	T{i} = thresh;
	S{i} = spike{1};
	
end

save(sprintf('ex_%s.mat', section), 'U', 'T', 'S', 'x');

%% simulate (d)
clear all
close all

% get a new neural network
NN = NeuralNetwork();
NN.setupReset();

% sensoric input
x = 5:.5:15;

for i=1:length(x)
	NN.neuron(1) = ResetNeuron();
	if abs(x(i)-9)<eps
		NN.neuron(1).input = @(t) x(i)*ones(size(t)) + 3*randn(size(t));
	else
		NN.neuron(1).input = @(t) x(i)*ones(size(t));
	end
	
	% simulate over 20 time units
	[u,thresh,spike] = NN.simulate(20);
	
	% save for later 
	U{i} = u;
	T{i} = thresh;
	S{i} = spike{1};
	
end

save('ex_d.mat', 'U', 'T', 'S', 'x');

%% analyze section (a)
clear all
close all
load ex_a.mat
	
rate = zeros(size(x));
for i=1:length(x)
	if abs(x(i)-11)<eps
		% save index
		ind = i;
	end
	spike = S{i};
	u = U{i};
	thresh = T{i};
	temprate=zeros(20,1);
	for j=1:20
		temprate(j) = nnz(spike>j-1 & spike<=j);
	end
	rate(i) = mean(temprate);
end

subplot(1,2,1)
plot(x, rate)
xlabel('sensoric input x');
ylabel('spike rate');
axis([min(x) max(x) -1 max(rate)*1.1])

subplot(1,2,2)
u = U{ind};
thresh = T{ind};
t = 0:.001:1;
semilogy(t, u(1:length(t)), 'b');
hold on
semilogy(t, thresh(1:length(t)), 'k');
xlabel('time');
ylabel('potentials');
% axis([0 1 0 11])
legend('dendritic potential', 'threshold function', 'Location', 'SE');

print -dpng ex_a.png

%% analyze section (b)
clear all
close all

load ex_b.mat
ub = U{1};
tb = T{1};
sb = S{1};

load ex_a.mat
	
rate = zeros(size(x));
for i=1:length(x)
	if abs(x(i)-9)<eps
		spike = sb;
	else
		spike = S{i};
	end
	temprate=zeros(20,1);
	for j=1:20
		temprate(j) = nnz(spike>j-1 & spike<=j);
	end
	rate(i) = mean(temprate);
end

subplot(1,2,1)
plot(x, rate)
xlabel('sensoric input x');
ylabel('spike rate');
axis([min(x) max(x) -1 max(rate)*1.1])

subplot(1,2,2)
u = ub;
thresh = tb;
t = 0:.001:1;
plot(t, u(1:length(t)), 'b');
hold on
plot(t, thresh(1:length(t)), 'k');
xlabel('time');
ylabel('potentials');
axis([0 1 0 11])
legend('dendritic potential', 'threshold function', 'Location', 'SE');

print -dpng ex_b.png

%% analyze section (c)
clear all
close all

load ex_c.mat
ub = U{1};
tb = T{1};
sb = S{1};

load ex_a.mat
	
rate = zeros(size(x));
for i=1:length(x)
	if abs(x(i)-9)<eps
		spike = sb;
	else
		spike = S{i};
	end
	temprate=zeros(20,1);
	for j=1:20
		temprate(j) = nnz(spike>j-1 & spike<=j);
	end
	rate(i) = mean(temprate);
end

subplot(1,2,1)
plot(x, rate)
xlabel('sensoric input x');
ylabel('spike rate');
axis([min(x) max(x) -1 max(rate)*1.1])

subplot(1,2,2)
u = ub;
thresh = tb;
t = 0:.001:1;
semilogy(t, u(1:length(t)), 'b');
hold on
semilogy(t, thresh(1:length(t)), 'k');
xlabel('time');
ylabel('potentials');

legend('dendritic potential', 'threshold function', 'Location', 'SE');

print -dpng ex_c.png

%% analyze section (d)
clear all
close all

load ex_d.mat
	
rate = zeros(size(x));
for i=1:length(x)
	
	spike = S{i};
	temprate=zeros(20,1);
	for j=1:20
		temprate(j) = nnz(spike>j-1 & spike<=j);
	end
	rate(i) = mean(temprate);
end

subplot(1,2,1)
plot(x, rate)
xlabel('sensoric input x');
ylabel('spike rate');
axis([min(x) max(x) -1 max(rate)*1.1])

subplot(1,2,2)
u = U{13};
thresh = T{13};
t = 0:.001:1;
semilogy(t, u(1:length(t)), 'b');
hold on
semilogy(t, thresh(1:length(t)), 'k');
xlabel('time');
ylabel('potentials');

legend('dendritic potential', 'threshold function', 'Location', 'SE');

print -dpng ex_d.png
