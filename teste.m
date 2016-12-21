clear all
close all
clc

imOriginala = imread('real4.tiff');
figure
imshow(imOriginala);

ImGray = imsubtract(imOriginala(:,:,1), rgb2gray(imOriginala));
figure
imshow(ImGray);

ImFiltrata = medfilt2(ImGray, [3 3]);
threshold = graythresh(ImFiltrata);

ImBinara = im2bw(ImFiltrata, threshold);
figure
imshow(ImBinara);

se = strel('square',11);
ImBinara = imclose(ImBinara,se);
figure
imshow(ImBinara);

[ImEtichetata,nrObiecte]=bwlabel(ImBinara,4);
proprietatiObiecte = regionprops(ImEtichetata,'all');

for i=1:nrObiecte
%     rectangle('Position', [proprietatiObiecte(i).BoundingBox(1), proprietatiObiecte(i).BoundingBox(2), proprietatiObiecte(i).BoundingBox(3), proprietatiObiecte(i).BoundingBox(4)],...
% 	'EdgeColor','r', 'LineWidth', 1);
     x = proprietatiObiecte(i).BoundingBox(1);
     y = proprietatiObiecte(i).BoundingBox(2);
     xwidth = proprietatiObiecte(i).BoundingBox(3);
     ywidth = proprietatiObiecte(i).BoundingBox(4);
     compactitate = proprietatiObiecte(i).Perimeter^2/proprietatiObiecte(i).Area;
    if compactitate > 17 | compactitate < 13
        ImBinara(floor(y):round(y+ywidth),floor(x):round(x+xwidth))=0;
    end
end

% for i=1:nrObiecte
%      x = proprietatiObiecte(i).BoundingBox(1);
%      y = proprietatiObiecte(i).BoundingBox(2);
%      xwidth = proprietatiObiecte(i).BoundingBox(3);
%      ywidth = proprietatiObiecte(i).BoundingBox(4);
%      compactitate = proprietatiObiecte(i).Perimeter^2/proprietatiObiecte(i).Area;
%     if compactitate > 17 | compactitate < 13
%         ImBinara(y:y+ywidth,x:x+xwidth)=0;
%     end
% end

figure
imshow(ImBinara);
