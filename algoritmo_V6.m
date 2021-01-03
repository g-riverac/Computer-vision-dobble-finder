clear

imagen_pc1=imread('dobble_42.jpg');
imagen_pc2=imread('dobble_44.jpg');

I222= imagen_pc2;
Irgb=I222;
%////////////////Mejorar el contraste//////////////
I333= rgb2ycbcr(I222);
J = imadjust(I333(:,:,1));
I333(:,:,1)=J;
I222=ycbcr2rgb(I333);
%/////////////////////////////////////////////////
BW12=imbinarize(I333(:,:,1),.70);figure;imshow(BW12);
rt=0;
[centersBright,radiiBright] = imfindcircles(BW12,[350 400],'ObjectPolarity','bright','Sensitivity',0.99);

% [centersBright,radiiBright] = imfindcircles(I222,[300 400],'ObjectPolarity','bright','Sensitivity',0.99)
% [centersBright,radiiBright] = imfindcircles(I222,[150 175],'ObjectPolarity','bright','Sensitivity',0.99);

figure;imshow(I222);
hBright = viscircles(centersBright, radiiBright,'Color','b');

figure;
  % Create a logical image of a circle with specified
  % diameter, center, and image size.
  % First create the image.
  mask = false(size(I222,1), size(I222,2));
  [columnsInImage,rowsInImage] = meshgrid(1:size(I222,2), 1:size(I222,1));
  % Next create the circle in the image.
  centerX = centersBright(1, 1);
  centerY = centersBright(1, 2);
  radius = radiiBright(1);
  circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= (radius-0.05*radius).^2;
  % circlePixels is a 2D "logical" array.
  % Now, display it.
  imshow(circlePixels) ;
  mask(circlePixels) = true;
  imshow(mask);
  drawnow;
title('Binary image mask', 'fontSize');
figure;
maskedRgbImage = bsxfun(@times, I222, cast(mask, 'like', I222));
imshow(maskedRgbImage);
n=imcomplement(mask);figure;imshow(n);
maskedRed=maskedRgbImage(:,:,1) ;
maskedGreen=maskedRgbImage(:,:,2) ;
maskedBlue=maskedRgbImage(:,:,3) ;
maskedRed(n) = 255;
maskedGreen(n) = 255;
maskedBlue(n) = 255;
maskedRgbImage4 = cat(3, maskedRed, maskedGreen, maskedBlue);
maskedRgbImage4=rgb2ycbcr(maskedRgbImage4);
figure;imshow(maskedRgbImage4);

% return
t=2;
umbral=0.85;
valor=5;
centroids=0;
while(size(centroids,1)<8)
BW15=imbinarize(maskedRgbImage4(:,:,1),umbral);figure;imshow(BW15)
nn=imcomplement(BW15);figure;imshow(nn);
% se = strel('line',4,180);
se = strel('sphere',valor);
BW20 = imdilate(nn,se); imshow(BW20), title('Original')
BW2 = imfill(BW20,'holes');
s = regionprops(BW2,'centroid','MajorAxisLength','MinorAxisLength','BoundingBox','Orientation');
centroids = cat(1,s.Centroid);

 if (size(centroids,1)<8)
        umbral=umbral-0.01;
        valor=valor-1;
 end

end

b=bwboundaries(BW2);


for r2=1:size(b)
bn(r2,1)=(size(b{r2},1));
end

[m1,sn]=sort(bn,'descend');

w=sn(1:8,:);
imshow(BW2); hold on ;plot(centroids(:,1),centroids(:,2),'b*') ;hold off

% return
iconos = cell(size(w,1));
for k=1:size(w,1)

po=false(size(BW2));
u=b{w(k)};

for j9=1:size(u,1)
po(u(j9,1),u(j9,2))=true;
end

mask2 = imfill(po,'holes');

Mask_m(:,:,:,k)=mask2;
figure;imshow(mask2);
maskedRgbImage3 = bsxfun(@times, Irgb, cast(mask2, 'like', Irgb));

binaryImage=imbinarize(maskedRgbImage3(:,:,1),.20);
verticalProfile = sum(binaryImage, 2); % Sum along columns in each row.
row1 = find(verticalProfile, 1, 'first');
row2 = find(verticalProfile, 1, 'last');
horizontalProfile = sum(binaryImage, 1); % Sum along rows in each column.
column1 = find(horizontalProfile, 1, 'first');
column2 = find(horizontalProfile, 1, 'last');
croppedImage = maskedRgbImage3(row1:row2, column1:column2,:);

% iconos(:,:,:,k)=maskedRgbImage3;
iconos{k,1}=croppedImage ;

figure;imshow(croppedImage);

end


% return
umbral_sift1=0.65; %Mientras más alto el porcentaje, aumenta el numero de puntos cazados
num=0;

while (num<1)
[puntosMatch,im1,im2]=match(umbral_sift1,3,imagen_pc1,imagen_pc2);
num=size(puntosMatch,1);

mensaje1=['Imagenes Izquierda-Derecha de captura número ',num2str(1),  ' con un total de ',num2str(num), ' puntos casados'];
disp(mensaje1);

puntosMatch1=puntosMatch(:,1:2);
puntosMatch2=puntosMatch(:,3:4);

disparidad = [(puntosMatch(:,3)-puntosMatch(:,1)),(puntosMatch(:,4)-puntosMatch(:,2))];

error_y=mean(disparidad(:,2));
if (num>=8)
% [F, inliers] = ransacfitfundmatrix(puntosMatch1', puntosMatch2', 0.01);
[H, inliers] = ransacfithomography(puntosMatch1', puntosMatch2', 0.01);
status=true;
status(inliers)=1;
status=status';

figure;
showMatchedFeatures(im1, im2, puntosMatch1(status,:),puntosMatch2(status,:),'montage','PlotOptions',{'ro','co','g'});
title('Mapa de disparidad entre con filtro RANSAC');
end
if(num<8)
    status=true(size(puntosMatch1,1),1);
end

if(num<=0)
    umbral_sift1=umbral_sift1+0.01;
end

real_puntos=puntosMatch2(status,:);
cont=[];

end

for p=1:size(Mask_m,4)
    for k=1:size(real_puntos,1)
        if (Mask_m(round(real_puntos(k,2)),round(real_puntos(k,1)),:,p)==true)
            cont(k,p)=1;
        else
            cont(k,p)=0;
        end
    end
end

r=sum(cont,1);
r2=r./size(real_puntos,1)*100;
indice=find(r(:)==max(r));
imwrite(iconos{indice,1},'match.jpg');

%////////////////////
[BW,maskedRGBImage] = createMask_verde(iconos{indice,1});
verde=any(BW(:));
[BW,maskedRGBImage] = createMask_rojo(iconos{indice,1});
rojo=any(BW(:));
[BW,maskedRGBImage] = createMask_celeste(iconos{indice,1});
celeste=any(BW(:));
[BW,maskedRGBImage] = createMask_amarillo(iconos{indice,1});
amarillo=any(BW(:));
[BW,maskedRGBImage] = createMask_morado(iconos{indice,1});
morado=any(BW(:));
[BW,maskedRGBImage] = createMask_naranja(iconos{indice,1});
naranja=any(BW(:));


% compara=['01.jpg';'02.jpg';'03.jpg';'04.jpg';'05.jpg';'06.jpg';'07.jpg';'08.jpg';'09.jpg';...
%     '10.jpg';'11.jpg';'12.jpg';'13.jpg';'14.jpg';'15.jpg';'16.jpg';'17.jpg';'18.jpg';'19.jpg';'20.jpg';...
%     '21.jpg'; '22.jpg';'23.jpg';'24.jpg';'25.jpg';'26.jpg';'27.jpg';'28.jpg';'29.jpg';'30.jpg';...
%     '31.jpg'; '32.jpg'; '33.jpg'; '34.jpg'; '35.jpg'; '36.jpg'; '37.jpg'; '38.jpg'; '39.jpg'; '40.jpg';
%     '41.jpg';'42.jpg';'43.jpg';'44.jpg';'45.jpg';'46.jpg';'47.jpg';'48.jpg';'49.jpg';'50.jpg';
%     '51.jpg'; '52.jpg';'53.jpg';'54.jpg';'55.jpg';'56.jpg';];

compara_verde=['01.jpg';'13.jpg';'17.jpg';'28.jpg';'42.jpg';'43.jpg';'53.jpg'];

compara_rojo=['02.jpg';'14.jpg';'16.jpg';'19.jpg';'34.jpg';'38.jpg';'45.jpg';'51.jpg'];

compara_celeste=['05.jpg';'06.jpg';'07.jpg';'10.jpg';'27.jpg';'31.jpg';'46.jpg';'54.jpg'];

compara_amarillo=['03.jpg';'11.jpg';'20.jpg';'21.jpg';'25.jpg';'36.jpg';'37.jpg';'49.jpg'];

compara_morado=['09.jpg';'15.jpg';'18.jpg';'22.jpg';'24.jpg';'30.jpg';'33.jpg';'47.jpg'];

compara_naranja=['04.jpg';'08.jpg';'12.jpg';'23.jpg';'29.jpg';'40.jpg';'41.jpg';'52.jpg';'57.jpg'];

compara_verde_naranja=['32.jpg';'52.jpg'];

compara_negro=['26.jpg';'35.jpg';'39.jpg';'44.jpg';'48.jpg';'50.jpg';'55.jpg';'56.jpg'];

load('Dataset8.mat');
load('Dataset_names.mat')

if(verde==1&&naranja==0)
compara=compara_verde;
my_im_cell=my_im_cell_verde;
Nombres=Nombres_verde;
end

if(naranja==1&&verde==0)
compara=compara_naranja;
my_im_cell=my_im_cell_naranaja;
Nombres=Nombres_naranja;
end

if(verde==1&&naranja==1)
compara=compara_verde_naranja;
my_im_cell=my_im_cell_verde_naranja;
Nombres=Nombres_verde_naranja;
end

if(morado==1)
compara=compara_morado;
my_im_cell=my_im_cell_morado;
Nombres=Nombres_morado;
end

if(amarillo==1)
compara=compara_amarillo;
my_im_cell=my_im_cell_amarillo;
Nombres=Nombres_amarillo;
end

if(celeste==1)
compara=compara_celeste;
my_im_cell=my_im_cell_celeste;
Nombres=Nombres_celeste;
end

if(rojo==1)
compara=compara_rojo;
my_im_cell=my_im_cell_rojo;
Nombres=Nombres_rojo;
end

if(rojo==0&&celeste==0&&morado==0&&naranja==0&&amarillo==0&&verde==0)
    compara=compara_negro;
    my_im_cell=my_im_cell_negro;
    Nombres=Nombres_negro;
end
%01=Mancha    %02=Fuego    03=Queso     04=Coche     05=Delfín   06=Iglú   07=Muñeco de nieve   08=biberon     09=Tijera;
%10=Lapiz   11=Perro    12=Llave    13=Dinosaurio 14=Prohibido
%15=Telaraña   16=Hoja    17=Manzana    18=Dragon  19=corazón   20=banana

% N = size(compara,1);
% my_im_cell = cell(N,3);


umbral_sift2=0.75 ; %Mientras más alto el porcentaje, aumenta el numero de puntos cazados

for i=1:size(compara,1)
[puntosMatch,im1,im2]=match2(umbral_sift2,3,imread('match.jpg'), my_im_cell{i,2},  my_im_cell{i,3}, my_im_cell{i,1});
% [puntosMatch,im1,im2]=match2(umbral_sift2,3,'dobble_222.jpg', my_im_cell{i,2},  my_im_cell{i,3}, my_im_cell{i,1});
% [puntosMatch,im1,im2,des2,loc2]=match3(umbral,3,imread('match.jpg'),imread(compara(i,:)) );


% my_im_cell{i,1} = imread(compara(i,:)); % where k is the image index/number
% my_im_cell{i,2}= des2;
% my_im_cell{i,3}= loc2;
num2=size(puntosMatch,1);


puntosMatch1_ic=puntosMatch(:,1:2);
puntosMatch2_ic=puntosMatch(:,3:4);

        if(num2>4)
%           [F, inliers] = ransacfitfundmatrix(puntosMatch1_ic', puntosMatch2_ic', 0.01);
            [H, inliers] = ransacfithomography(puntosMatch1_ic', puntosMatch2_ic', 0.005);
            
            status_ic=true;
            status_ic(inliers)=1;
            status_ic=status_ic';
            figure;
            showMatchedFeatures(im1, im2, puntosMatch1_ic(status_ic,:),puntosMatch2_ic(status_ic,:),'montage','PlotOptions',{'ro','co','g'});
            title('Mapa de disparidad entre con filtro RANSAC');
        end
        if(num2<=4)
            status_ic=true(size(puntosMatch1_ic,1),1);
            
        end
        
        real_puntos_ic=puntosMatch2_ic(status_ic,:);
        cont2=[];
        
        num3=size(real_puntos_ic,1);
        
        if num2<=4
        num3=0;
        end
        
        r3(i)=num3;
        rt=rt+num3;
       
end
        
        r4=(r3./rt).*100;
        r4(isnan(r4))=0;
        indice2=find(r4(:)==max(r4));
        
        figure;imshow(compara(indice2,:));




