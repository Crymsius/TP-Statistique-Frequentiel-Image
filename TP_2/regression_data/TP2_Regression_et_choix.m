%image Ia et Ibglobal Ia = double(imread('keble_a.jpg'));global Ib = double(imread('keble_b.jpg'));%points choisis sur les 2 imagesrx1 = [[590 369 1] [0 0 0] [-299*590 -299*369 -299]];ry1 = [[0 0 0] [590 369 1] [-364*590 -364*369 -364]];rx2 = [[405 295 1] [0 0 0] [-115*405 -115*295 -115]];ry2 = [[0 0 0] [405 295 1] [-293*405 -293*295 -293]];rx3 = [[652 112 1] [0 0 0] [-364*652 -364*112 -364]];ry3 = [[0 0 0] [652 112 1] [-123*652 -123*112 -123]];rx4 = [[340 92 1] [0 0 0] [-49*340 -49*92 -49]];ry4 = [[0 0 0] [340 92 1] [-77*340 -77*92 -77]];M = [rx1;ry1;rx2;ry2;rx3;ry3;rx4;ry4][U,S,V] = svd(M);V0 = transpose(V(:,end));%matrice de l'homographieH = [ [V0(1:3)] ; [V0(4:6)] ; [V0(7:9)] ];%coins de l'image (on suppose 2 images de même dimension)A = [0;0;1];B = [size(Ia,2);0;1];C = [size(Ia,2);size(Ia,1);1];D = [0;size(Ia,1);1];%coins de l'image par l'homographieA2 = H*A;B2 = H*B;C2 = H*C;D2 = H*D;%calcul des min et max des coins de l'image totalePoints = [A2/A2(3) B2/B2(3) C2/C2(3) D2/D2(3) A B C D];X1 = min(Points(1,:));X2 = max(Points(1,:));Y1 = min(Points(2,:));Y2 = max(Points(2,:));%calcul de l'image transforméeIma1 = vgg_warp_H(Ia, H, 'linear',[X1, X2, Y1, Y2]);Imb1 = vgg_warp_H(Ib, eye(3), 'linear',[X1, X2, Y1, Y2]);Ima2 = vgg_warp_H(Ia, eye(3), 'linear',[X1, X2, Y1, Y2]);Imb2 = vgg_warp_H(Ib, inv(H), 'linear',[X1, X2, Y1, Y2]);Imtotal1= max(Ima1,Imb1);Imtotal2= max(Ima2,Imb2);%affichageimage(uint8(Imtotal1),'Parent',subplot(1,2,1));axis equal;image(uint8(Imtotal2),'Parent',subplot(1,2,2));axis equal;