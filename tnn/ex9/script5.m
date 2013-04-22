% this script does excercise 9 part 5
% Markus Döring, Thomas Reckow

Lmax = 200;
a = 0.01;
numPrincipalComponents = 10;

% fill matrix with image vectors
X = getimgs();
imSize = size(X,2);
numImgs = size(X,1);

% initialize weights
c = normrnd(0,1,imSize,numPrincipalComponents);
for i=1:numPrincipalComponents
    c(:,i) = c(:,i)/norm(c(:,i));
end

for L=1:Lmax
    fprintf('Lernschritt %d\n', L);
    
    % adjust learning rate
    Lt = a*(1-(L-1)/Lmax);
    for sample=1:numImgs
        x = X(sample,:)';
        y = (x'*c);
        
        delta_c = zeros(size(c));
        
        for j=1:numPrincipalComponents
            s = x - c(:,1:j)*y(1:j)';
            delta_c(:,j) = Lt*y(j)*s;
        end
        
        c = c + delta_c;
    end
end

figure;
for i=1:10
    subplot(2,5,i);
    I = vec2img(c(:,i));
    imshow(I)
end

print -dpng eigenfaces_sanger.png