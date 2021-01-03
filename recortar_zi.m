function [croppedImage] = recortar_zi(imagen, umbral,mostrarImagen)

binaryImage=imbinarize(imagen(:,:,1),umbral);
verticalProfile = sum(binaryImage, 2); % Sum along columns in each row.
row1 = find(verticalProfile, 1, 'first');
row2 = find(verticalProfile, 1, 'last');
horizontalProfile = sum(binaryImage, 1); % Sum along rows in each column.
column1 = find(horizontalProfile, 1, 'first');
column2 = find(horizontalProfile, 1, 'last');
croppedImage = imagen(row1:row2, column1:column2,:);
if mostrarImagen==1
    figure;imshow(croppedImage);
end