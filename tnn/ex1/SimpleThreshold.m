classdef SimpleThreshold < handle %ThresholdInterface
	%SIMPLETHRESHOLD Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		ref = 1000;
		rel = 50;
		rest = 10;
		t_ref = .002;
		fac = 0.9;
	end
	
	methods
		function thresh = getThresh(obj, t, spikes)
			if isempty(spikes)
				thresh = obj.rest;
				return
			end
			
			s_max = max(spikes);
			if t<s_max
				error('Consider dusting this ancient "t"');
			end
			if numel(t) ~= 1
				error('One "t" at a time.');
			end
			
			thresh = obj.ref;
			if t - s_max > obj.t_ref
				for i=obj.t_ref:obj.t_ref/2:t-s_max
					thresh = thresh * obj.fac;
				end
			end
			
			if thresh < obj.rest 
				thresh = obj.rest;
			end
		end
	end
	
end

