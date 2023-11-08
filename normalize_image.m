function [image_pr] = normalize_image(image)

%////
img = im2double(image); 

avgR = mean2(img(:,:,1));
avgG = mean2(img(:,:,2));
avgB = mean2(img(:,:,3));

% Calcula los factores de escala
scaleR = avgG / avgR;
scaleG = 1;
scaleB = avgG / avgB;

% Aplica los factores de escala a cada canal
img(:,:,1) = img(:,:,1) * scaleR;
img(:,:,2) = img(:,:,2) * scaleG;
img(:,:,3) = img(:,:,3) * scaleB;

image_pr= im2uint8(img);
