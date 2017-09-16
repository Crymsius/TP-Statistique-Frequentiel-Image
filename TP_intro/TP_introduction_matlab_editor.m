A = double(imread('flower1.jpg'));
newmap = jet(5);
imwrite(uint8(A), newmap, 'test.png');
colormap(gray);
B = rgb2gray(uint8(A));
C = A;
%1
max(max(B));
min(max(B));
%2
C(C>200) = 200;
%3
C(C<100)= 50;
%4 ->étirer sur les côtés pour utiliser les 50 et 55 restants

%5
r=randperm(256)-1;
r(A); %il faut décaller les indices !
D=r(A+1);
image(uint8(D));


