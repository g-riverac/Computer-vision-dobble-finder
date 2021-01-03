function [Irgb,Iycbcr,carta_original] = segmentar_carta(imagen)
%////////////////Mejorar el contraste//////////////
I111=imagen;
I333= rgb2ycbcr(I111);
J = imadjust(I333(:,:,1));
I333(:,:,1)=J;
I222=ycbcr2rgb(I333);
% I222=rgb2gray(I222);
%/////////////////////////////////////////////////
BW12=imbinarize(I333(:,:,1),.85);imshow(BW12);

% [centersBright,radiiBright] = imfindcircles(BW12,[350 400],'ObjectPolarity','bright','Sensitivity',0.99);
[centersBright,radiiBright] = imfindcircles(BW12,[410 430],'ObjectPolarity','bright','Sensitivity',0.99);

imshow(I222);
hBright = viscircles(centersBright, radiiBright,'Color','b');
carta_original = I111((round(centersBright(1,2))-round(radiiBright)):(round(centersBright(1,2))+round(radiiBright)),(round(centersBright(1,1))-round(radiiBright)):(round(centersBright(1,1))+round(radiiBright)),:);

carta= I222((round(centersBright(1,2))-round(radiiBright)):(round(centersBright(1,2))+round(radiiBright)),(round(centersBright(1,1))-round(radiiBright)):(round(centersBright(1,1))+round(radiiBright)),:);

% Create a logical image of a circle with specified
  % diameter, center, and image size.
  % First create the image.
  mask = false(size(carta_original,1), size(carta_original,2));
  [columnsInImage,rowsInImage] = meshgrid(1:size(carta_original,2), 1:size(carta_original,1));
  % Next create the circle in the image.
  I444=rgb2ycbcr(carta_original);
  BW13=imbinarize(I444(:,:,1),.45);imshow(BW13);
  [centersBright2,radiiBright2] = imfindcircles(BW13,[410 430],'ObjectPolarity','bright','Sensitivity',0.99);
%   [centersBright2,radiiBright2] = imfindcircles(BW13,[350 400],'ObjectPolarity','bright','Sensitivity',0.99);

  centerX = centersBright2(1, 1);
  centerY = centersBright2(1, 2);
  radius = radiiBright(1);
  circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= (radius-0.05*radius).^2;
  % circlePixels is a 2D "logical" array.
  % Now, display it.

  mask(circlePixels) = true;
  
figure;imshow(mask);
  hBright2 = viscircles(centersBright2, radiiBright2,'Color','b');

maskedRgbImage = bsxfun(@times, carta, cast(mask, 'like', carta));
% carta=bsxfun(@times, I111, cast(mask, 'like', I111));
figure;imshow(maskedRgbImage);
 mask2= 255.*uint8(mask);
 
% [carta_segmentar] = recortar_zi(maskedRgbImage, 0.2,1);
carta_segmentar = maskedRgbImage;
% [mask3] = recortar_zi(mask2, 0.2,0);

n=imcomplement(mask2);
maskedRed=carta_segmentar(:,:,1) ;
maskedGreen=carta_segmentar(:,:,2) ;
maskedBlue=carta_segmentar(:,:,3) ;
maskedRed(logical(n)) = 255;
maskedGreen(logical(n)) = 255;
maskedBlue(logical(n)) = 255;
maskedRgbImage4 = cat(3, maskedRed, maskedGreen, maskedBlue);
Irgb=maskedRgbImage4;
Iycbcr=rgb2ycbcr(maskedRgbImage4);
figure;imshow(carta_original);

