function [] = saveimg(X, p, d)
% save image vector to file
%
% input: 
%	X	image vector
%	p	save path with known image extension
%	d	vector of [width, height]

X = reshape(X, d(2), d(1));

imwrite(X, p);


end

