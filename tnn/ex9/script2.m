% does excercise 9 part 2
% Markus Döring, Thomas Reckow

k = 10;
wxh = [112 92];

disp('=========')
disp('Getting Images')

X = getimgs();

disp('=========')
disp('Getting Eigenvalues')
[V,D] = eig(X'*X);
d = diag(D);


disp('=========')
disp('Sorting')
[d,ind] = sort(d);

V = V(:,ind);
W = V(:,1:k);


disp('=========')
disp('Plotting')
subplot(1,2,1)
imshow(reshape(X(:,1),wxh(2),wxh(1)))
subplot(1,2,2)
imshow(reshape(X(:,1)*W,wxh(2),wxh(1)))

