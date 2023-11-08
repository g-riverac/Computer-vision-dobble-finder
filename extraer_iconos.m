function [iconos,carta_original,Mask_m] = extraer_iconos(imagen,umbral,valor)

[Iycbcr,carta_original]=segmentar_carta(imagen);

t=2;
centroids=0;

while(size(centroids,1)<8)
    BW15=imbinarize(Iycbcr(:,:,1),umbral);%figure;imshow(BW15)
    nn=imcomplement(BW15);%figure;imshow(nn);
    se = strel('sphere',valor);
    BW20 = imdilate(nn,se); %figure;imshow(BW20), title('Original')
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
%imshow(BW2); hold on ;plot(centroids(:,1),centroids(:,2),'b*') ;hold off

% return
iconos = cell(size(w,1));
for k=1:size(w,1)

po=false(size(BW2));
u=b{w(k)};

for j9=1:size(u,1)
po(u(j9,1),u(j9,2))=true;
end

mask2 = imfill(po,'holes');

Mask_m(:,:,k)=mask2;
%figure;imshow(mask2);
maskedRgbImage3 = bsxfun(@times, carta_original, cast(mask2, 'like', carta_original));

[croppedImage] = recortar_zi(maskedRgbImage3, 0.2,0);
iconos{k,1}=croppedImage ;

%figure;imshow(croppedImage);

end

