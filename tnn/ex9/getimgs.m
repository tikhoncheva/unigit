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
		[v,~] = loadimg(imname);
		s = norm(double(v));
		
		% check if row is normalizable
		if s<eps
			error('encountered all-zero image');
		end
		
		% insert normalized row
		X((i-1)*nImg + j, :) = v/s;
	end
end

% subtract the mean row
disp('Subtracting Mean')
m = mean(X);
for i=1:size(X,1)
	X(i,:) = X(i,:) - m;
end


end

