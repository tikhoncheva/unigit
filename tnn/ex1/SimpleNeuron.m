classdef SimpleNeuron < Neuron
	%SIMPLENEURON Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		tau = .01;
		membrane = 1;
		channel = 1;
		input
	end
	
	methods
		function obj = SimpleNeuron()
			obj.input = @(t) zeros(size(t));
		end
	end
	
end

