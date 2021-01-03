
function [Irgb,Mask_m,Mask_m2,iconos,iconos2,carta1,carta2] = preprocesar(image)
[uu1,uu2] = dividir_tarjetas(image);

imagen_pc1=uu1;
imagen_pc2=uu2;

I222= imagen_pc2;
Irgb=I222;
rt=0;

[iconos, carta1, Mask_m] = extraer_iconos(imagen_pc1,0.70,5);
[iconos2, carta2, Mask_m2] = extraer_iconos(imagen_pc2,0.70,5);

