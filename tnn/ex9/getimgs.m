function [X] = getimgs()
% get all image vectors for excercise 9 with normalized rows and 
% feature-mean 0

nPers = 40;
nImg = 10;
% nPers = 1;
% nImg = 3;

wxh = [92 112];
nPix = prod(wxh);

X = zeros(nPers*nImg, nPix);

for i=1:nPers
	for j=1:nImg
		% load image as row
		imname = sprintf('orl_faces/s%d/%d.pgm', i, j);
		fprintf('Loading image %s\n',imname); 
        
		row = loadimg(imname);
		s = norm(row);
		
		% check if row is normalizable
		if s < eps
			error('encountered all-zero image');
		end
		
		% insert normalized row
		X((i-1)*nImg + j, :) = row/s;
	end
end

% subtract the mean row
disp('Subtracting Mean')
X = bsxfun(@minus, X, mean(X,1));

% less efficient
% m = mean(X,1);
% for i=1:size(X,1)
% 	X(i,:) = X(i,:) - m;
% end


end

function X = loadimg(p)
% load image vector from file
%
% input: 
%	p	image path
% output:
%	X	image vector 1xN [double]

X = imread(p);

X = double(reshape(X, 1, numel(X)));

end


