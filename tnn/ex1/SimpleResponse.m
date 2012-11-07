classdef SimpleResponse < handle %ResponseInterface
	%SIMPLERESPONSE Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
	end
	
	methods
		function response = getResponse(t)
			response = zeros(size(t));
			for i=1:length(t)
				if t(i) > 0
					response(i) = exp(-t(i));
				else
					response(i) = 0;
				end
			end
		end
	end
	
end

