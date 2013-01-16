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

% V is around 800MB, let's reduce it
V = V(:,1:k);

save result.mat X d V wxh k ind

%%

load result.mat

disp('=========')
disp('Plotting')

figure;
for i=1:k
	subplot(2,5,i)
	I = vec2img(V(:,i));
	imshow(I)
end

print -dpng eigenfaces_new.jpg