clear all
close all
clc

imOriginala = imread('cub3.jpg');
figure
imshow(imOriginala);

ImGray = imsubtract(imOriginala(:,:,1), rgb2gray(imOriginala));
figure
imshow(ImGray);

ImFiltrata = medfilt2(ImGray, [3 3]);
ImBinara = im2bw(ImFiltrata, 0.18);

figure
imshow(ImBinara);

[labeled,nrObiecte]=bwlabel(ImBinara,4);
proprietatiObiecte = regionprops(labeled,'Area','Perimeter','Centroid');

Obiect1 = proprietatiObiecte(1);

spatiuNegru = 0.42;

latura = Obiect1.Perimeter/4;

distantaMin = latura + 0.42*latura;

centroids = cat(1, proprietatiObiecte.Centroid);

distante = zeros ((nrObiecte-1)*nrObiecte/2,8);

w = 1;

for i=1:(nrObiecte-1)  
    for j=i+1:nrObiecte
         dist = fix(sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2));
         distante(w,:) = [i j dist centroids(i,1) centroids(i,2) centroids(j,1) centroids(j,2) -1];
         w = w+1;
    end
end

for i=1:(nrObiecte-1)  
    for j=i+1:nrObiecte
         dist = fix(sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2));
         distante(w,:) = [j i dist centroids(j,1) centroids(j,2) centroids(i,1) centroids(i,2) -1];
         w = w+1;
    end
end

[m,n] = size(distante);

for i=1:m
    if distante(i,3) < distantaMin+20
        if abs(distante(i,6)-distante(i,4))<15 & distante(i,7) > distante(i,5)
            distante(i,8) = 6;
        end
        if abs(distante(i,6)-distante(i,4))<15 & distante(i,7) < distante(i,5)
            distante(i,8) = 2;
        end
        if abs(distante(i,5)-distante(i,7))<15 & distante(i,6) > distante(i,4)
            distante(i,8) = 0;
        end
        if abs(distante(i,5)-distante(i,7))<15 & distante(i,6) < distante(i,4)
            distante(i,8) = 4;
        end
    end
    if distante(i,3) < distantaMin*sqrt(2)+20 & distante(i,3) > distantaMin+20
        if distante(i,6) > distante(i,4) & distante(i,7) < distante(i,5)
            distante(i,8) = 1;
        end
        if distante(i,6) < distante(i,4) & distante(i,7) < distante(i,5)
            distante(i,8) = 3;
        end
        if distante(i,6) < distante(i,4) & distante(i,7) > distante(i,5)
            distante(i,8) = 5;
        end
        if distante(i,6) > distante(i,4) & distante(i,7) > distante(i,5)
            distante(i,8) = 7;
        end
    end
    if distante(i,3) > distantaMin*sqrt(2)+20
        distante(i,8) = -1;
    end
end

cubRubik = zeros(7,7);
cubRubik(4,4) = 1;
coordonate = zeros(nrObiecte,3);
coordonate(1,:) = [1 4 4];

for i=1:m
    es = distante(i,1);
    estop = distante(i,2);
    pi = coordonate(es,2);
    pj = coordonate(es,3);
    if pi == 0 | pj ==0
        i=i+1;
        es = distante(i,1);
        estop = distante(i,2);
        pi = coordonate(es,2);
        pj = coordonate(es,3);
    end
    if distante(i,8) == 0
        cubRubik(pi,pj+1) = estop;
        coordonate(estop,:) = [estop pi pj+1];
    end
    if distante(i,8) == 1
        cubRubik(pi-1,pj+1) = estop;
        coordonate(estop,:) = [estop pi-1 pj+1];
    end
    if distante(i,8) == 2
        cubRubik(pi-1,pj) = estop;
        coordonate(estop,:) = [estop pi-1 pj];
    end
    if distante(i,8) == 3
        cubRubik(pi-1,pj-1) = estop;
        coordonate(estop,:) = [estop pi-1 pj-1];
    end
    if distante(i,8) == 4
        cubRubik(pi,pj-1) = estop;
        coordonate(estop,:) = [estop pi pj-1];
    end
    if distante(i,8) == 5
        cubRubik(pi+1,pj-1) = estop;
        coordonate(estop,:) = [estop pi+1 pj-1];
    end
    if distante(i,8) == 6
        cubRubik(pi+1,pj) = estop;
        coordonate(estop,:) = [estop pi+1 pj];
    end
    if distante(i,8) == 7
        cubRubik(pi+1,pj+1) = estop;
        coordonate(estop,:) = [estop pi+1 pj+1];
    end
end

contorC = 0;
contorL = 0;
coloaneComplete = 0;
liniiComplete = 0;

for i=1:7
    for j=1:7
        if cubRubik(j,i) > 0
            contorC = contorC + 1;
        end
        if cubRubik(i,j) > 0
            contorL = contorL + 1;
        end
    end
    if contorC == 3
        coloaneComplete = coloaneComplete + 1;
        contorC = 0;
    end
    if contorL == 3
        liniiComplete = liniiComplete + 1;
        contorL = 0;
    end
    contorC = 0;
    contorL = 0;
end

figure
imshow(ImBinara); hold on
for i=1:7
    if (cubRubik(i,4) > 0 & cubRubik(i,5) > 0 & cubRubik(i,6) > 0)
        pos = cubRubik(i,4);
        rectangle('Position',[centroids(pos,1)-(latura/2), centroids(pos,2)-(latura/2), latura*4, latura],...
            'EdgeColor','r', 'LineWidth', 1);
    end
end

for j=1:7
    for i=1:5
        if (cubRubik(i,j) > 0 & cubRubik(i+1,j) > 0 & cubRubik(i+2,j) > 0)
            pos = cubRubik(i,j);
            rectangle('Position',[centroids(pos,1)-(latura/2), centroids(pos,2)-(latura/2), latura, latura*4],...
            'EdgeColor','r', 'LineWidth', 1);
        end
    end
end


distante
cubRubik

X = sprintf('Numar coloane rosii complete: %d',coloaneComplete);
disp(X);
Y = sprintf('Numar linii rosii complete: %d',liniiComplete);
disp(Y);

