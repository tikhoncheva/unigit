% this script does excercise 9 part 3
% Markus Döring, Thomas Reckow

Lmax = 200;
% Lmax = 1;
a = 0.01;

% fill matrix with image vectors
X = getimgs();

% initialize weights
c = normrnd(0,1,size(X,2),1);
c = c/norm(c);

for L=1:Lmax
    fprintf('Lernschritt %d\n', L);
    for j=1:size(X,1)
        
        % adjust learning rate
        d = a*(1-(L-1)/Lmax);
        
        % perform hebb step
        c = c + d*X(j,:)'*(X(j,:)*c);
    end
    
end

I = vec2img(c);
imshow(I)

imwrite(I, 'eigenface_hebb.png');