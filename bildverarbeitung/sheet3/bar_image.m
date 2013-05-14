function [img] = bar_image(b,theta,c, n)
%BAR create a "bar" image

js = 1:n;
ks = 1:n;

[J,K] = meshgrid(js,ks);

temp = cos(theta)*(J-b(1)) + sin(theta)*(K-b(2));

img = zeros(n);
img(abs(temp) <= c/2) = 1;


end

