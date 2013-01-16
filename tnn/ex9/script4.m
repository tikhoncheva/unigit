% this script does excercise 9 part 4
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
        x = X(j,:)';
        
        % adjust learning rate
        d = a*(1-(L-1)/Lmax);
        
        % compute output
        y = x'*c;

        % perform oja step
        c = c + d*y*(x-y*c);
    end
    
end

I = vec2img(c);
imshow(I)

imwrite(I, 'eigenface_oja.png');