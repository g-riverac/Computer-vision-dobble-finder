function [i_match,indice_match] = comparar(carta1,carta2,Mask_m,Mask_m2,iconos,iconos2)

umbral_sift1=0.60; %Mientras más alto el porcentaje, aumenta el numero de puntos cazados
umbral_filtro=0.90;
num=0;

while (num<3)

    [puntosMatch,im1,im2]=match(umbral_sift1,0,carta1,carta2,umbral_filtro);
    num=size(puntosMatch,1);

    %mensaje1=['Imagenes Izquierda-Derecha de captura número ',num2str(1),  ' con un total de ',num2str(num), ' puntos casados'];
    %disp(mensaje1);

    puntosMatch1=puntosMatch(:,1:2);
    puntosMatch2=puntosMatch(:,3:4);

    disparidad = [(puntosMatch(:,3)-puntosMatch(:,1)),(puntosMatch(:,4)-puntosMatch(:,2))];

    error_y=mean(disparidad(:,2));
    if (num>=8)
        % [F, inliers] = ransacfitfundmatrix(puntosMatch1', puntosMatch2', 0.01);
        [H, inliers] = ransacfithomography(puntosMatch1', puntosMatch2', 0.01);
        status=true;
        status(inliers)=1;
        status=status';

        %figure;
        %showMatchedFeatures(im1, im2, puntosMatch1(status,:),puntosMatch2(status,:),'montage','PlotOptions',{'ro','co','g'});
        %title('Mapa de disparidad entre con filtro RANSAC');
    end
    if(num<8)
        status=true(size(puntosMatch1,1),1);
    end

    if(num<=3)
    %     umbral_sift1=umbral_sift1+0.05;
          umbral_filtro=umbral_filtro-0.10;
    end

    real_puntos=puntosMatch1(status,:);
    real_puntos2=puntosMatch2(status,:);

end

cont=zeros(size(real_puntos,1),size(Mask_m,3));
cont2=zeros(size(real_puntos,1),size(Mask_m,3));
num_punts=1;
puntos_val=[0,0];
num_pv = size(Mask_m,3);
cell_pv = cell(num_pv,1);

for p=1:size(Mask_m,3)
    for k=1:size(real_puntos,1)
        if (Mask_m(round(real_puntos(k,2)),round(real_puntos(k,1)),p)==true)
            cont(k,p)=1;
            puntos_val(num_punts,:)=[round(real_puntos2(k,2)),round(real_puntos2(k,1))];
            num_punts=num_punts+1;
        else
            cont(k,p)=0;
            
        end

    end
    
    
        if (Mask_m2(round(real_puntos2(k,2)),round(real_puntos2(k,1)),p)==true)
            cont2(k,p)=1;

        else
            cont2(k,p)=0;
        end
    
    cell_pv{p,1}=puntos_val;
    puntos_val=[0,0];
    num_punts=1;
end


cont3=zeros(size(cell_pv,1),size(Mask_m2,3));
for m1=1:size(cell_pv,1)
    for ry=1:size(Mask_m2,3)
        
        aux_mat=cell_pv{m1};
        
       for q=1:size(cell_pv{m1},1)
       
        if (aux_mat(q,2)==0||aux_mat(q,1)==0)
        cont3(m1,ry)=0;
        else 
            
            if (Mask_m2(aux_mat(q,1),aux_mat(q,2),ry)==true)
            cont3(m1,ry)=1;
            else
                cont3(m1,ry)=0;
            end
        end
           
        
       end
    end
    

end

[row,col] = find(cont3>0);%row son Mask_m y col son Mask_m2

r1=sum(cont,1);
r2=r1./size(real_puntos,1)*100;
r1_2=sum(cont2,1);
indice_match=find(r1(:)==max(r1));
indice_match2=find(r1_2(:)==max(r1_2));

for k5=1:size(row,1)
    [color] = color_icono(iconos{row(k5,1)});
    colores1(k5,:)=color;
end
    
for k6=1:size(col,1)
    [color] = color_icono(iconos2{col(k6,1)});
    colores2(k6,:)=color;
end
    
for k7=1:size(col,1)
    result1(k7)=isequal(colores1(k7,:),colores2(k7,:));
end   

indice_match=row(result1);   

if size(indice_match,1)>1
    indice_match=find(r1(:)==max(r1));
end

i_match=iconos{indice_match,1};
imwrite(i_match,'match.tiff');


