function [X,d] = loadimg(p)
% load image vector from file
%
% input: 
%	p	image path
% output:
%	X	image vector
%	d	vector of [width, height]

X = imread(p);

d = fliplr(size(X));

X = reshape(X, 1, numel(X));


end

