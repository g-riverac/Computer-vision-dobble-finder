function [confront ind_conf] = confirmation2(compara,indice2,puntosMatch_indice2,i_match)
kkk1=1;
kkk2=2;
ima1=i_match;
for iii=1:length(indice2)
    flag=0;
    ima2=rgb2gray(imread(compara(indice2(iii),:)));
%     umbral_sift1=0.85;
%     [puntosMatch,im1,im2]=match2(umbral_sift1,3,i_match, my_im_cell{indice2(iii),2},  my_im_cell{indice2(iii),3}, my_im_cell{indice2(iii),1});
    puntosMatch=puntosMatch_indice2{iii,1};
    contatore=0;
    if length(puntosMatch(:,1))>3%%%%%%%%%%%%%%%%%%%%%%%%%%elnumero de mach to switch to takesimbol
        for kkk1=1:length(puntosMatch(:,1))
            for kkk2=kkk1+1:length(puntosMatch(:,1))
                v1=(puntosMatch(kkk1,1:2)-puntosMatch(kkk2,1:2))';
                v2=(puntosMatch(kkk1,3:4)-puntosMatch(kkk2,3:4))';
                norm1=norm(v1);
                norm2=norm(v2);
                if norm1/norm2<100&&norm1/norm2>0.001
                    contatore=contatore+1;
                    scal(contatore)=norm2/norm1;
                    ang(contatore)=-angle(v1(1)+v1(2)*j)+angle(v2(1)+v2(2)*j);
                end
            end
        end
%         figure
%         histogram(ang)
%         figure
%         histogram(scal)
        [mi contatore]=min(abs(scal-mode(scal)));
        scala=scal(contatore);
        [mi contatore]=min(abs(ang-mode(ang)));
        angl=ang(contatore);
    else
        flag=1;
        ima3=rgb2gray(i_match);
        [l1,m1,k]=size(ima2(:,:));
        [l2,m2,k]=size(ima3(:,:));
        for cont1=1:l1
            for cont2=1:m1
                if ima2(cont1,cont2)==0
                    nero2(cont1,cont2)=1;
                else
                    it1=cont1+1;
                    jt1=cont2+1;
                    nero2(cont1,cont2)=0;
                end
            end
        end
%         figure
        nero2=[zeros(1,m1+2)+1;[zeros(l1,1)+1 nero2 zeros(l1,1)+1];zeros(1,m1+2)+1];
%         imshow(nero2)
        for cont1=1:l2
            for cont2=1:m2
                if ima3(cont1,cont2)==0
                    nero3(cont1,cont2)=1;
                else
                    it2=cont1+1;
                    jt2=cont2+1;
                    nero3(cont1,cont2)=0;
                end
            end
        end
%         figure
        nero3=[zeros(1,m2+2)+1;[zeros(l2,1)+1 nero3 zeros(l2,1)+1];zeros(1,m2+2)+1];
%         imshow(nero3)
        [W1,fattorediscala1] = take_simbol(it1,jt1,nero2,l1+2,m1+2);
        [W2,fattorediscala2] = take_simbol(it2,jt2,nero3,l2+2,m2+2);
        W=W1*W2';
        scala=fattorediscala1/fattorediscala2;
    end
    if scala<10
        canal=1;
        [l,m]=size(ima2(:,:,canal));
        n=0;
        toll=0;
        for i=1:l
            for j_j=1:m
                if ima2(i,j_j,canal)>toll
                    n=n+1;
                    vima2(n,:)=[i j_j ima2(i,j_j,canal)];
                end
            end
        end
        cm2=[sum(vima2(:,1));sum(vima2(:,2))]/n;
        [l,m]=size(ima1(:,:,canal));
        n=0;
        out=[0;0;0];
        vima1=[4.4 4.4 4.4];
        for i=1:l
            for j_j=1:m
                if ima1(i,j_j,canal)>toll
                    n=n+1;
                    if flag==0
                        out=rotz(-angl)*[i;j_j;0];
                    else
                        out=W*[i;j_j];
                    end
                    ii=out(1);
                    j_jj_j=out(2);
                    vima1(n,:)=[ii j_jj_j double(ima1(i,j_j,canal))];
                end
            end
        end
        cm1=[sum(vima1(:,1));sum(vima1(:,2))]/n;
        vima1(:,1:2)=vima1(:,1:2)+(cm2-cm1)'.*ones(n,2);
        vima1(:,1)=vima1(:,1)-min(vima1(:,1))+1;
        vima1(:,2)=vima1(:,2)-min(vima1(:,2))+1;
        imout=zeros(round(max(vima1(:,1))),round(max(vima1(:,2))));
        for i=1:n
            imout(round(vima1(i,1)),round(vima1(i,2)))=uint8(vima1(i,3));
            imout(round(vima1(i,1))+1,round(vima1(i,2))+1)=uint8(vima1(i,3));
            imout(round(vima1(i,1)),round(vima1(i,2))+1)=uint8(vima1(i,3));
            imout(round(vima1(i,1))+1,round(vima1(i,2)))=uint8(vima1(i,3));
            imout(indic(round(vima1(i,1))-1),indic(round(vima1(i,2))-1))=uint8(vima1(i,3));
            imout(round(vima1(i,1)),indic(round(vima1(i,2))-1))=uint8(vima1(i,3));
            imout(indic(round(vima1(i,1))-1),round(vima1(i,2)))=uint8(vima1(i,3));
            imout(round(vima1(i,1))+1,indic(round(vima1(i,2))-1))=uint8(vima1(i,3));
            imout(indic(round(vima1(i,1))-1),round(vima1(i,2))+1)=uint8(vima1(i,3));
        end
        imout=imresize(uint8(imout),scala);
        imout = imresize(imout,size(ima2));
%         figure; imshow(abs(histeq(ima2)-histeq(uint8(imout))))
        confronto(iii)=norm(double(abs(histeq(ima2)-histeq(uint8(imout)))));
    end
end
[confront ind_conf]=min(confronto);
% figure;imshow(compara(indice2(ind_conf),:));
end

