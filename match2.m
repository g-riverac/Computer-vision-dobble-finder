
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
%


% function [puntosMatch,im1,im2] = match(umbral,representaImagen, image1, image2)
function [puntosMatch,im1,im2] = match2(umbral, image1, des2, loc2,imagen2,umbral_filtro)

%umbral: Umbral para la correspondencia (distRatio)
%representaImagen:
%   1: Representa la primera imagen con los puntos encontrados
%   2: Representa la segunda imagen con los puntos encontrados
%   3: Representa ambas imagenes con una linea que une los puntos casados
%image1: Nombre de la primera imagen en formato .pgm
%image1: Nombre de la segunda imagen en formato .pgm
%puntosMatch: Puntos casados. En cada fila x1,y1,x2,y2
%im1: Matriz imagen1
%im2: Matriz imagen2


% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1,umbral_filtro);
im2=imagen2;

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = umbral;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end


%GENERA LA MATRIZ DE RESULTADOS
%Por filas los puntos casados
%Por columnas (x,y) primera imagen, (x,y) segunda imagen

%Numero de puntos casados
num = sum(match > 0);
puntosMatch=zeros(num,4);
indice=1;

%Bucle para cada caracteristica encontrada
for i = 1: size(des1,1)
    %Caracteristica casada
    if (match(i) > 0)
        puntosMatch(indice,1)=loc1(i,1);
        puntosMatch(indice,2)=loc1(i,2);
        puntosMatch(indice,3)=loc2(match(i),1);
        puntosMatch(indice,4)=loc2(match(i),2);
        indice=indice+1;
    end
end

    







