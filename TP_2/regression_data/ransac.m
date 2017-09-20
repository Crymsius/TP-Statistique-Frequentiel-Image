function H = ransac(data, N, k, seuil)%data : matrice des paires de points%N : le nombre de paires à tester%k : nombre d'iterationsscore = 0;H = zeros(3,3);for j = 0 : k  %Selection de N paires  idx = randperm(size(data,1), N);  n_paires_rand = data(idx,:); % donne N points random de data    %calcul de H  Htemp = homographie(n_paires_rand);    %Test de H  result = 0;  for i = 1 : size(result,1)    A = [data(i,1);data(i,2);1];    A2 = Htemp * A;    dist = (A2(1)/A2(3)-data(i,3)).^2 + (A2(2)/A2(3)-data(i,4)).^2;    if dist < seuil      result++;    end  end  if sum(result) > score    score = sum(result)    H = Htemp;  endendendreturn