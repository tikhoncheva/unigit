classdef ThresholdInterface < handle
	%THRESHOLDINTERFACE Summary of this class goes here
	%   Detailed explanation goes here
	
	properties (Abstract = true)
	end
	
	methods (Abstract = true)
		%spikes is real time array
		thresh = getThresh(t, spikes)
	end
	
end

