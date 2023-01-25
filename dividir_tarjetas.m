function [uu1,uu2] = dividir_tarjetas(image)
B=image;

u2=rgb2ycbcr(B);
figure;imshow(u2);
% u3=rgb2gray(B);
% gris1=max(u3(:));
% [x,y]=find(u3==240);
% x=max(x);
% y=y(find(x==max(x(:))));
% gray_val = [B(x,y,1) B(x,y,2) B(x,y,3)];
% uu = chromadapt(B,gray_val);
% figure;imshow(uu);

BW15=imbinarize(u2(:,:,1),.45);figure;imshow(BW15)
[centersBright,radiiBright] = imfindcircles(BW15,[395 445],'ObjectPolarity','bright','Sensitivity',0.99);
% hBright = viscircles(centersBright, radiiBright,'Color','b');
% figure;imshow(uu);
% hBright = viscircles(centersBright, radiiBright,'Color','b');

d = pdist(centersBright,'euclidean')
d2=d/2
out = (centersBright(1,:) + centersBright(2,:))./2

uu2=B(:,round(out(1,1)):end,:);
figure;imshow(uu2);
uu1=B(:,1:round(out(1,1)),:);
figure;imshow(uu1);
