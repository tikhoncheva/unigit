classdef Neuron < handle
	%NEURON Summary of this class goes here
	%   Detailed explanation goes here
	
	properties (Abstract = true)
		tau
		membrane
		channel
		% function handle @(t)
		input 
	end
	
	methods (Abstract = true)
		
	end
	
end

