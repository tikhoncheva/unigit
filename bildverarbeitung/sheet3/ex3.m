clear all
close all
clc


%% plain subsampling (3a)
X = imread('Tile0001.png');
sampling = 8;
subX = X(1:sampling:end,1:sampling:end);

subplot(1,2,1)
imshow(X)
title('original image')
subplot(1,2,2)
imshow(subX)
title('subsampled image')

% the subsampled image resembles tiles from an 80's adventure game, i.e.
% it is pixelated and the higher frequency areas are just random black dots

%% lowpass subsampling (3b)

% with a lowpass filter first, the image is less pain, but it does get
% blurry

close all
clc

F = fft2(X);

c = size(F)/2;
width = size(F,1)/8;
mask = zeros(size(F));
mask(floor(c(1)-width/2):ceil(c(1)+width/2), floor(c(1)-width/2):ceil(c(1)+width/2)) = 1;

F = fftshift(F);
F = F .* mask;
F = ifftshift(F);

Y = abs(ifft2(F));
Y = Y/max(Y(:));
subY = Y(1:sampling:end,1:sampling:end);

subplot(1,3,1)
imshow(X)
title('original image')
subplot(1,3,2)
imshow(subX)
title('subsampling only')
subplot(1,3,3)
imshow(subY)
title('subsampling with lowpass')

%% gaussian subsampling (3c)

% we want to subsample an 8th, so using a 9th lowpass filter sounds
% reasonable. I cannot justify the sigma choice right now, but the result
% looks quite anti-aliased

h = fspecial('gaussian', round(size(X,1)/3), 4);
FH = fft2(h);
Z = imfilter(X,h);
subZ = Z(1:sampling:end,1:sampling:end);


figure;
subplot(1,3,1)
imshow(X)
title('original image')
subplot(1,3,2)
imshow(subY)
title('subsampling with perfect lowpass')
subplot(1,3,3)
imshow(subZ)
title('subsampling with gaussian lowpass')

%% visualization of filter (3d)

close all

% the filter mask is a Gauss kernel like its FT
% with larger sigma, the filter is wider in the spatial domain and narrower
% in the frequency domain

sigmas = [1 5 10];
n = length(sigmas);

for i=1:n
	subplot(1,n,i)
	h = fspecial('gaussian', round(size(X,1)/3), sigmas(i));
	imagesc(h)
	axis equal
end
