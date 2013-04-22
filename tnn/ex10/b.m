% Reckow, Döring

% Formel sh. Abgabe

T = [1, -1, 1, -1];
M = length(T);
simple_x = [1,1;1,-1;-1,-1;-1,1];

phi = @(x) [1, sqrt(2)*x(1), sqrt(2)*x(2), sqrt(2)*x(1)*x(2), x(1)^2, x(2)^2];

x = zeros(M,6);

for i=1:size(simple_x,1)
    x(i,:) = phi(simple_x(i,:));
end

A = zeros(M);
for row=1:M
    for col=1:M
        v = x(row,:);
        w = x(col,:);
        A(row,col) = T(row)*T(col)*v*w';
    end
end

% B = eye(M) - A;
B = A;

[V,D] = eig(B);

sqrtB = V*sqrt(D)*V';

alpha = quadprog(sqrtB, ones(4,1), -eye(4), zeros(4,1));

close all
hold on
xn = x([2,4],2:4)';
xp = x([1,3],2:4)';
plot3(xn(1,:),xn(2,:),xn(3,:),'r*'); % x(3,[2,4]), x(4,[2,4]),'r*')
plot3(xp(1,:),xp(2,:),xp(3,:),'b*'); % x(3,[2,4]), x(4,[2,4]),'r*')

xlabel('2')
ylabel('3')
zlabel('4')


% wild assumption:
w = zeros(6,1);
w(4) = 1/sqrt(2);



F =@(new_x) sign(new_x*w);

absurd_x = [+.7 pi];
even_more_absurd_x = phi(absurd_x);

F(even_more_absurd_x)