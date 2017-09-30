%K : nombre de classes
%global K = 4;

%image I
global I = double(imread('../Data/flower1.jpg'));

%vecteur (X), nombre de la classe K
global X = load('../Data/gmm2d.asc');

%random yk from Xi
%global Y = rand (K, size(X,2)); %size de x,2 pour le nombre de colones
%Y = [Y(:,1)*(max(X(:,1))-min(X(:,1)))+ min(X(:,1)) Y(:,2)*(max(X(:,2))-min(X(:,2)))+ min(X(:,2))];

%getY2D
function Y = getY2D(X, K) % X : image
  Y = rand (K, size(X,2)); %size de x,2 pour le nombre de colones
  Y = [Y(:,1)*(max(X(:,1))-min(X(:,1)))+ min(X(:,1)) Y(:,2)*(max(X(:,2))-min(X(:,2)))+ min(X(:,2))];
end
%getY
function Y = getY(X, K) % X : image
  Y = rand (K, size(X,3)); %size de x,3 pour le nombre de colones
  Y = [Y(:,1)*(max(X(:,1))-min(X(:,1)))+ min(X(:,1)) Y(:,2)*(max(X(:,2))-min(X(:,2)))+ min(X(:,2)) Y(:,3)*(max(X(:,3))-min(X(:,3)))+ min(X(:,3))];
  Y = uint8(Y);
end


%distance2D
function dist = distance2D(A,B) %A et B, vecteurs (x,y)
  dist = (B(:,1)-A(:,1))*(B(:,1)-A(:,1)) + (B(:,2)-A(:,2))*(B(:,2)-A(:,2));
end
%distance
function dist = distance(A,B) %A et B, vecteurs (r,g,b)
  dist = (B(:,1)-A(:,1))*(B(:,1)-A(:,1)) + (B(:,2)-A(:,2))*(B(:,2)-A(:,2)) + (B(:,3)-A(:,3))*(B(:,3)-A(:,3));
end

%findNearest2D
function nearestLabel = findNearestLabel2D(X, Y, K) %X: vecteur (x,y), Y matrice de vecteurs
  v = 1:K;
  for j = 1:K
    v(:,j) = distance2D(X, Y(j,:));
  end
  
  [val, nearestLabel] = min(v); %fait nearest = indice du min(v) (soit le label)
end
%findNearest
function nearestLabel = findNearestLabel(X, Y, K) %X: vecteur (r,g,b), Y matrice de vecteurs
  v = 1 : K;
  for j = 1 : K
    v(:,j) = distance(X, Y(j,:));
  end
  
  [val, nearestLabel] = min(v); %fait nearest = indice du min(v) (soit le label)
end

%findNearestLabel(X(1,:),Y,K)

%mykmeans2D :
%img: image en double
%ncluster: nombre de clusters
%niter: nombre d'iterations
%centroids: matrice ncluster x 3 où chaque ligne est un centroid
%labels: image d' un seul canal dont la valeur est le label attribué au pixel
function [labels, centroids] = mykmeans2D(img, ncluster, niter)
  X = img;
  W = img(:,1);
  Y = getY2D(img, ncluster);
  for a = 1 : niter
    for i = 1 : size(img,1)
      W(i) = findNearestLabel2D(img(i,:),Y, ncluster);
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
  ind = find(W.' == 4);
  plot(X(ind,1),X(ind,2),'.r');
  ind = find(W.' == 3);
  plot(X(ind,1),X(ind,2),'.c');
end

%mykmeans :
%img: image en double
%ncluster: nombre de clusters
%niter: nombre d'iterations
%centroids: matrice ncluster x 3 où chaque ligne est un centroid
%labels: image d' un seul canal dont la valeur est le label attribué au pixel
function [labels, centroids] = mykmeans(img, ncluster, niter)
  X = img;
  W = img(:,:,1); % matrice de la taille de img
  Y = getY(img, ncluster); % matrice RGB du nbr de clusters
  R = img(:,:,1); %composante R de img
  G = img(:,:,2); % composante G de img
  B = img(:,:,3); % composante B de img
  for a = 1 : niter
    for i = 1 : size(img,1)
      for j = 1 : size(img,2)
        W(i,j) = findNearestLabel(X(i,j,:),Y, ncluster);
      end
    end
    for k = 1 : ncluster
      ind = find(W == k); %vecteur des indices des lignes de label k
      
      Y(k,1) = sum(R(ind)) / size(ind,1);
      Y(k,2) = sum(G(ind)) / size(ind,1);
      Y(k,3) = sum(B(ind)) / size(ind,1);
    end
  end
  %hold on;
  ind = find(W == 1);
  R(ind) = 10; %Y(ind,1);
  G(ind) = 10; %Y(ind,2);
  B(ind) = 10; %Y(ind,3);
  ind = find(W == 2);
  R(ind) = 150; %Y(ind,1);
  G(ind) = 150; %Y(ind,2);
  B(ind) = 150; %Y(ind,3);
  ind = find(W == 3);
  R(ind) = 200; %Y(ind,1);
  G(ind) = 30; %Y(ind,2);
  B(ind) = 200; %Y(ind,3);
  final = cat(3,R,G,B);
  image(uint8(final));
end

%M = reshape (I, size(I,1)*size(I,2), 3);
%reshape (M, [size(I,1) size(I,2) 3]);
%pareil pour les labels

%paire = [[590 369] [299 364]]