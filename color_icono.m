function [color] = color_icono(icono)

    [BW,maskedRGBImage] = createMask_verde(icono);
    verde=any(BW(:));
    [BW,maskedRGBImage] = createMask_rojo(icono);
    rojo=any(BW(:));
    [BW,maskedRGBImage] = createMask_celeste(icono);
    celeste=any(BW(:));
    [BW,maskedRGBImage] = createMask_amarillo(icono);
    amarillo=any(BW(:));
    [BW,maskedRGBImage] = createMask_morado(icono);
    morado=any(BW(:));
    [BW,maskedRGBImage] = createMask_naranja(icono);
    naranja=any(BW(:));
    
    color=[verde, rojo, celeste, amarillo, morado, naranja];
