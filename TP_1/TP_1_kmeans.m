%K : nombre de classes
%global K = 4;

%image I
global I = double(imread('../Data/flower1.jpg'));

%vecteur (X), nombre de la classe K
global X = load('../Data/gmm2d.asc');

%random yk from Xi
%global Y = rand (K, size(X,2)); %size de x,2 pour le nombre de colones
%Y = [Y(:,1)*(max(X(:,1))-min(X(:,1)))+ min(X(:,1)) Y(:,2)*(max(X(:,2))-min(X(:,2)))+ min(X(:,2))];

%getY
function Y = getY(X, K) % X : image
  Y = rand (K, size(X,2)); %size de x,2 pour le nombre de colones
  Y = [Y(:,1)*(max(X(:,1))-min(X(:,1)))+ min(X(:,1)) Y(:,2)*(max(X(:,2))-min(X(:,2)))+ min(X(:,2))];
end

%distance
function dist = distance(A,B) %A et B, vecteurs (x,y)
  dist = (B(:,1)-A(:,1))*(B(:,1)-A(:,1)) + (B(:,2)-A(:,2))*(B(:,2)-A(:,2));
end

%findNearest
function nearestLabel = findNearestLabel(X, Y, K) %X: vecteur (x,y), Y matrice de vecteurs
  v = 1:K;
  for j = 1:K
    v(:,j) = distance(X, Y(j,:));
  end
  
  [val, nearestLabel] = min(v); %fais nearest = indice du min(v) (soit le label)
end

%findNearestLabel(X(1,:),Y,K)

%mykmeans :
%img: image en double
%ncluster: nombre de clusters
%niter: nombre d'iterations
%centroids: matrice ncluster x 3 où chaque ligne est un centroid
%labels: image d' un seul canal dont la valeur est le label attribué au pixel
function [labels, centroids] = mykmeans(img, ncluster, niter)
  X = img;
  W = img(:,1);
  Y = getY(img, ncluster);
  for a = 1 : niter
    for i = 1 : size(img,1)
      W(i) = findNearestLabel(img(i,:),Y, ncluster);
    end
    for k = 1 : ncluster
      ind = find(W == k); %vecteur des indices des lignes de label k
      Y(k,1) = sum(X(ind,1)) / size(ind,1);
      Y(k,2) = sum(X(ind,2)) / size(ind,1);
    end
  end
  hold on;
  %plot(X(:,1),X(:,2),'.r');
  ind = find(W.' == 1);
  plot(X(ind,1),X(ind,2),'.b');
  ind = find(W.' == 2);
  plot(X(ind,1),X(ind,2),'.g');
  ind = find(W.' == 3);
  plot(X(ind,1),X(ind,2),'.c');
  nd = find(W.' == 4);
  plot(X(ind,1),X(ind,2),'.r');
  
  
  

end