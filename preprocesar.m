
function [Irgb,Mask_m,Mask_m2,iconos,iconos2,carta1,carta2] = preprocesar(image, mode)
%Mode is for the number of cards in a single image

if mode==2 % mode 2 solo si la imagen es de 2 tarjetas dobble
    [imagen_pc1,imagen_pc2] = dividir_tarjetas(image);
    [iconos, carta1, Mask_m] = extraer_iconos(imagen_pc1,0.70,5);
    [iconos2, carta2, Mask_m2] = extraer_iconos(imagen_pc2,0.70,5);
    Irgb=imagen_pc2;
else
    imagen_pc1=image;
    [iconos, carta1, Mask_m] = extraer_iconos(imagen_pc1,0.70,5);
    Mask_m2=Mask_m;
    iconos2=iconos;
    carta2=carta1;
    Irgb=imagen_pc1;
end

