function [resultado_comparacion,Etiqueta] = get_label(indice_match,i_match,iconos)
rt=0;

color = color_icono(iconos{indice_match,1});
verde =color(1);
rojo =color(2);
celeste =color(3);
amarillo =color(4);
morado =color(5);
naranja =color(6);

compara_verde=['01.tiff';'13.tiff';'17.tiff';'28.tiff';'42.tiff';'43.tiff';'53.tiff'];
compara_verde2=[01,13,17,28,42,43,53];
compara_rojo=['02.tiff';'14.tiff';'16.tiff';'19.tiff';'34.tiff';'38.tiff';'45.tiff';'51.tiff'];
compara_rojo2=[02,14,16,19,34,38,45,51];
compara_celeste=['05.tiff';'06.tiff';'07.tiff';'10.tiff';'27.tiff';'31.tiff';'46.tiff';'54.tiff'];
compara_celeste2=[05,06,07,10,27,31,46,54];
compara_amarillo=['03.tiff';'11.tiff';'20.tiff';'21.tiff';'25.tiff';'36.tiff';'37.tiff';'49.tiff'];
compara_amarillo2=[03,11,20,21,25,36,37,49];
compara_morado=['09.tiff';'15.tiff';'18.tiff';'22.tiff';'24.tiff';'30.tiff';'33.tiff';'47.tiff'];
compara_morado2=[09,15,18,22,24,30,33,47];
compara_naranja=['04.tiff';'08.tiff';'12.tiff';'23.tiff';'29.tiff';'40.tiff';'41.tiff';'57.tiff'];
compara_naranja2=[04,08,12,23,29,40,41,57];
compara_verde_naranja=['32.tiff';'52.tiff'];
compara_verde_naranja2=[32,52];
compara_negro=['26.tiff';'35.tiff';'39.tiff';'44.tiff';'48.tiff';'50.tiff';'55.tiff';'56.tiff'];
compara_negro2=[26,35,39,44,48,50,55,56];


load('Dataset9.mat');
load('Dataset_names.mat');
compara=[];

if(verde==1&&naranja==0)
    compara=compara_verde;
    compara2=compara_verde2;
    my_im_cell=my_im_cell_verde;
    Nombres=Nombres_verde;
end

if(naranja==1&&verde==0)
    compara=compara_naranja;
    compara2=compara_naranja2;
    my_im_cell=my_im_cell_naranja;
    Nombres=Nombres_naranja;
end

if(verde==1&&naranja==1)
    compara=compara_verde_naranja;
    compara2=compara_verde_naranja2;
    my_im_cell=my_im_cell_verde_naranja;
    Nombres=Nombres_verde_naranja;
end

if(morado==1)
    compara=compara_morado;
    compara2=compara_morado2;
    my_im_cell=my_im_cell_morado;
    Nombres=Nombres_morado;
end

if(amarillo==1)
    compara=compara_amarillo;
    compara2=compara_amarillo2;
    my_im_cell=my_im_cell_amarillo;
    Nombres=Nombres_amarillo;
end

if(celeste==1)
    compara=compara_celeste;
    compara2=compara_celeste2;
    my_im_cell=my_im_cell_celeste;
    Nombres=Nombres_celeste;
end

if(rojo==1)
    compara=compara_rojo;
    compara2=compara_rojo2;
    my_im_cell=my_im_cell_rojo;
    Nombres=Nombres_rojo;
end

if(rojo==0&&celeste==0&&morado==0&&naranja==0&&amarillo==0&&verde==0)
    compara=compara_negro;
    compara2=compara_negro2;
    my_im_cell=my_im_cell_negro;
    Nombres=Nombres_negro;
end

N = size(compara,1);
cell_puntosMatch_indice2 = cell(N,2);

umbral_sift2=0.90 ; 

for i=1:size(compara,1)
[puntosMatch_ic,im1,im2]=match2(umbral_sift2,i_match, my_im_cell{i,2},  my_im_cell{i,3}, my_im_cell{i,1},0.55);

num2=size(puntosMatch_ic,1);


puntosMatch1_ic=puntosMatch_ic(:,1:2);
puntosMatch2_ic=puntosMatch_ic(:,3:4);

        if(num2>4)
            [H, inliers] = ransacfithomography(puntosMatch1_ic', puntosMatch2_ic', 0.005);
            
            status_ic=true;
            status_ic(inliers)=1;
            status_ic=status_ic';
            %figure;
            %showMatchedFeatures(im1, im2, puntosMatch1_ic(status_ic,:),puntosMatch2_ic(status_ic,:),'montage','PlotOptions',{'ro','co','g'});
            %title('Mapa de disparidad entre con filtro RANSAC');
        end
        if(num2<=4)
            status_ic=true(size(puntosMatch1_ic,1),1);
            
        end
        
        cell_puntosMatch_indice2{i,1}=puntosMatch_ic(status_ic,:);
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
        
       if size(indice2,1)>1

            [confront, ind_conf]=confirmation2(compara,indice2,cell_puntosMatch_indice2,i_match);
            %figure;imshow(compara(indice2(ind_conf,:),:));
            nom=Nombres(indice2(ind_conf,:),:);

       else
            %figure;imshow(compara(indice2,:)); 
            nom=Nombres(indice2,:);
        end
        result_icon=compara(indice2,:);
        resultado_comparacion=imread(result_icon(1,:));
%         figure;imshow(resultado_comparacion);
        Etiqueta=nom;





