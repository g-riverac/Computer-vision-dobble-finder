function [uu1,uu2] = dividir_tarjetas(image)

u2=rgb2ycbcr(image);

BW15=imbinarize(u2(:,:,1),.45);%figure;imshow(BW15)
[centersBright,radiiBright] = imfindcircles(BW15,[395 445],'ObjectPolarity','bright','Sensitivity',0.99);

umbral=5;

while ~any(centersBright)
    [centersBright,radiiBright] = imfindcircles(BW15,[395 445+umbral],'ObjectPolarity','bright','Sensitivity',0.99);
    umbral=umbral+5;
    if umbral>=25
        break;
    end
end

out = (centersBright(1,:) + centersBright(2,:))./2;

uu2=image(:,round(out(1,1)):end,:);
uu1=image(:,1:round(out(1,1)),:);
%figure;imshow(uu2);
%figure;imshow(uu1);