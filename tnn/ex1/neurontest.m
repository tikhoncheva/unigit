clear all
close all
clc

NN = NeuralNetwork();

NN.neuron(1).input = @(t) 11*ones(size(t));

[u,t,s] = NN.simulate(1);

semilogy(u, 'b')
hold on
semilogy(t, 'k')