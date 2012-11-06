classdef ResponseInterface < handle
	%RESPONSEINTERFACE Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
	end
	
	methods (Abstract = true)
		response = getResponse(t)
	end
	
end

