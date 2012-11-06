classdef NeuralNetwork < handle
	%NEURONNET Summary of this class goes here
	%   Detailed explanation goes here
	
	properties %(Access = private)
		% number of neurons
		n
		
		% neurons (size==n1, type: Neuron)
		neuron
		
		% number of membrane types
		k
	
		% reverse potentials per membrane type (size==kx1)
		U
		
		% adjacency matrix (size==nxn)
		C 
		
		% delay matrix (size=nxn)
		D
		
		% response function objects (size==kx1, type: ResponseInterface)
		response
		
		% threshold function objects (size==kx1, type: ThresholdInterface)
		threshold
		
		% discrete time increment delta t
		dt
		
		% start potentials (size==nx1)
		u0
	end
	
	methods
		
		function obj = NeuralNetwork()
			obj.setupSimple();
		end %NeuralNetwork
		
		function setupSimple(obj)
		% prepare a simple working example
			obj.n = 1;
			obj.neuron = SimpleNeuron();
			
			obj.k = 1;
			obj.C = 0;
			obj.D = 0;
			obj.dt = .001;
			obj.U = 1;
			
			obj.u0 = 0;

			obj.threshold = SimpleThreshold();
			obj.response = SimpleResponse();
			
			obj.selfCheck();
		end %setupSimple
		
		function selfCheck(obj)
		% check validity of properties
			assert(isa(obj.threshold, 'ThresholdInterface'));
			assert(isa(obj.response, 'ResponseInterface'));
			
			assert(numel(obj.neuron) == obj.n);
			assert(numel(obj.u0) == obj.n);
			assert(numel(obj.U) == obj.k);
			assert(numel(obj.response) == obj.k);
			assert(numel(obj.threshold) == obj.k);
			
			assert(all(size(obj.C) == [obj.n obj.n]));
			assert(all(size(obj.D) == [obj.n obj.n]));
			
			assert(obj.dt > 0);
			
			for i=1:obj.n
				assert(any(obj.neuron(i).membrane == 1:obj.k));
				assert(any(obj.neuron(i).channel == 1:obj.k));
				assert(obj.neuron(i).tau > 0);
				try
					x = 1:5;
					y = obj.neuron(i).input(x);
					if ~all(size(y) == size(x))
						error('%s != %s', evalc('disp(size(y))'), evalc('disp(size(x))'));
					end
				catch e
					error('input of neuron %d cannot be used (%s).', i, e.message);
				end
			end
		end % selfCheck
		
		function [pot,thresh,spike] = simulate(obj, T)
			obj.selfCheck();
			
			if ~exist('T', 'var')
				T = 1;
			end
			
			t = 0:obj.dt:T;
			
			u = zeros(obj.n, length(t));
			thresh = u;
			spike = cell(obj.n,1);
			
			u(:,1) = obj.u0;
			for i = 1:length(t)
				% update threshold at i
				for j=1:obj.n
					thresh(j,i) = obj.threshold(obj.neuron(j).membrane).getThresh(t(i), spike{j});
				end
				
				% check for spikes at i
				for j=1:obj.n
					if thresh(j,i) <= u(j,i)
						spike{j}(end+1) = t(i);
					end
				end
				
				if i<length(t)
					% update potential for i+1
					for j=1:obj.n
						A = 0;
						for m = 1:obj.n
							%TODO
						end
						s = obj.dt / obj.neuron(j).tau;
						u(j,i+1) = (1-s) * u(j,i) + s*A + s*obj.neuron(j).input(t(i));
					end
				end
				
			end
			
			pot = u;
		end
	end
	
end

