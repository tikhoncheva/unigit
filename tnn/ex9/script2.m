% this script does excercise 9 part 2
% Markus Döring, Thomas Reckow

error('Don''t execute this!')

k = 10;
wxh = [92 112];

disp('=========')
disp('Getting Images')

X = getimgs();

disp('=========')
disp('Getting Eigenvalues')
[V,D] = eig(X'*X);
d = diag(D);


disp('=========')
disp('Sorting')
[d,ind] = sort(d,'descend');

V = V(:,ind);


disp('=========')
disp('Plotting')

figure;
for i=1:k
	subplot(2,5,i)
	I = V(:,i);
	I = I - min(I);
	I = I/max(I);
	I = reshape(I,wxh(2),wxh(1));
	imshow(I)
end

save result.mat X d V wxh k ind

%%

load result.mat

figure;
for i=1:k
	subplot(2,5,i)
	I = V(:,i);
	I = I - min(I);
	I = I/max(I);
	I = reshape(I,wxh(2),wxh(1));
	imshow(I)
end

print -dpng eigenfaces_new.jpg