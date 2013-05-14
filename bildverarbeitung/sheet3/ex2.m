clear all
close all
clc




img = bar_image([200;200], pi/4, 40,500);

subplot(1,2,1)
imagesc(img)
subplot(1,2,2)
imagesc(log(abs(fftshift(fft2(img)))))


%% Interpretation (2a)
%
% we know that 
%  - a translation in space is a modulation in reciprocal space, therefore
%    variation of x shifts the pase of F(img)
%  - a rotation in space is a rotation in reciprocal space, therefore a
%    variation of theta rotates the fourier transform
%  - a contraction of the image (say, replacing the bar by a bar half its
%    length) dilates the fourier transform

close all
clc

theta = pi/4;
c = 40;
b = [250;250];

dtheta = pi/4;
dc = -20;
db = [50;50];



subplot(2,4,1)
img = bar_image(b, theta, c, 500);
imagesc(img)
title('Original image')

subplot(2,4,5)
imagesc(log(abs(fftshift(fft2(img)))))
title('absolute log of FFT')

subplot(2,4,2)
img = bar_image(b+db, theta, c, 500);
imagesc(img)
title('shifted image')

subplot(2,4,6)
imagesc(log(abs(fftshift(fft2(img)))))
title('absolute log of FFT')



subplot(2,4,3)
img = bar_image(b, theta+dtheta, c, 500);
imagesc(img)
title('rotated image')

subplot(2,4,7)
imagesc(log(abs(fftshift(fft2(img)))))
title('absolute log of FFT')

subplot(2,4,4)
img = bar_image(b, theta, c+dc, 500);
imagesc(img)
title('contracted image')

subplot(2,4,8)
imagesc(log(abs(fftshift(fft2(img)))))
title('absolute log of FFT')


%% bandpass for n (2b) 

% bandpass == lowpass + highpass
% doing this later

X = imread('Tile0001.png');
imshow(X)
