% The following code plots the stress profile of the nodes on the line x (y=y2/2, z=0) that crosses the center hole
clear all
close all

axial={'uniaxial','biaxial','uniaxial_r_eq_1'};
[m t] = size(axial);
%plotstyle3{1}={'k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.'}; 
%plotstyle3{2}={'k*','b*','g*','r*','y*','m*','c*','k*','b*','g*','r*','y*','m*','c*','k*','b*','g*','r*','y*','m*','c*','k*'}; 
          plotstyle={'k-o' 'k-^'  'k-*' 'k-o';
                        'b-o'  'b-^'  'b-*' 'b-o';
                        'k-o' 'k-^'  'k-*' 'k-o'};
          %plotstyle1={'k.-o','k.-^','k.-*','b.-','b.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-'}; 

%cont2=-65; % figure position 
%n=0;
plate  = [1.5  1.5 14 0.5];
depth = [1.5 1 1 0.5];   

%m=3; %3 geometries
%t=1 % uniaxial only
%t=3 % uniaxial when r= 1 mm
m=4 % through hole
figure('pos',[80 80 650 500],'Name','Teste');
for cont=1:1:t
    %cont2=cont2 + 66; %figure position 
    %figure('rend','painters','pos',[10*cont2 80 650 500],'Name',upper(axial{cont})); % => este comando funciona no MATLAB -> � funciona no OCTAVE
    %figure('pos',[80 80 650 500],'Name',upper(axial{cont}));
    %movegui(f,[125*cont2,200]);
    %plotstyle1={'k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.'}; 
          %plotstyle1={'k.-o','k.-^','k.-*','b.-','b.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-'}; 
    %plotstyle1={'k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y.','m-','c-','k-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-'}; 
		
    %diff=[6:2:20]; %Point differences to be read
    %[m n] = size(diff);
   %Some importants parameters
    r = 2; %hole radius
    L = 60; % comprimento do modelo (x2 do ansys apdl)

    for a=1:1:m %going through each point difference
        %figure('pos',[80 80 650 500],'Name','Teste');

        %/cwd,wd(1,1),'\',axial(1,cont),'\plate_',plate(1,cont2)'_depth_'depth(1,cont2) -> no Ansys APDL
        path=['C:\Manasses\center_hole\',axial{cont},'\plate_',num2str(plate(a)),'_depth_',num2str(depth(a)),'\'];%address
        %path=['C:\Users\TTR01\Desktop\Manasses\varying_hole_distance\biaxial\difference',num2str(diff(a)),'mm\'];%address
        nome='dados_dos_nos_A2.txt';%file name

        [n,xloc,yloc,zloc,ux,uy,uz,sx,sy,sz,se]=textread([path nome],'%f %f %f %f %f %f %f %f %f %f %f');%L� o arquivo Salva as colunas em 10 vari�veis
        %legendinfo{a}=[num2str(diff(a)),' mm'];%legenda
        matriz=[n(:,1),xloc(:,1),yloc(:,1),zloc(:,1),ux(:,1),uy(:,1),uz(:,1),sx(:,1),sy(:,1),sz(:,1),se(:,1)];%preparing to sort the data
        matriz=sortrows(matriz,2); %Deixa os dados em ordem crescente

        [i,j]=find(matriz(:,4)~=0.0);%transversal line at the surface of the plate
        matriz(i,:)=[];%exclui os pontos que n�o est�o na superf�cie do modelo

        [i,j]=find(matriz(:,9)==0); %finds sigmax values equal to zero
        matriz(i,:)=[];%exclui os valores de tens�o igual a zero (n�s intermedi�rios)
        [i,j]=size(matriz);
      
        % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = x2/2 = 30 (A1) 
        % matriz(:,2) -> indica valores ao longo do eixo x  -> plano y = y2/2 = 30  (A2)

        %x1 = ((L-diff(a))/2)-r;
        %x2 = ((L-diff(a))/2)+r;

        %[i,j]=find(matriz(:,2)==x1|matriz(:,2)==x2); %size(i) � numero de points
        %MATRIZSTRESST(1:size(i),1,a)=matriz(i,2);%x position
        %MATRIZSTRESST(1:size(i),2,a)=matriz(i,9);%Stresses x
        % i � o numero(sequencia) de n� q se encontra o no com valoresmaximos de ten�o

        %matrizGeo(1:size(i),1) = diff(a);
        %matrizGeo(1:size(i),2) = MATRIZSTRESST(1:size(i),2,a);

        %legendinfo{1}=['point x1'];%legenda
        %legendinfo{2}=['point x2'];%legenda

        % with one hole as a reference
        %grid on
        %plot(diff(a),MATRIZSTRESST(1,2,a),'g.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
        %hold on
        %plot(diff(a),MATRIZSTRESST(2,2,a),'r.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
        %hold on 
        
        %Nominal stress
        coef=( (L-2*r)*(plate(a)) )/((L*plate(a)));
        
        grid on
        plot(30-matriz(:,2),matriz(:,9),plotstyle{cont,a},'markersize',5) %9 � sigma y
        grid minor
        %plot(matriz(:,2),matriz(:,9),'markersize',15) %9 � sigma y
        hold on
        
        %[g h] = size(matriz);
        %grid on
        %plot(matriz(1:i(1),2),matriz(1:i(1),9),plotstyle1{a},'markersize',10)
        %hold on
        %grid on
        %plot(matriz(i(2):g,2),matriz(i(2):g,9),plotstyle1{a},'markersize',10)
        %hold on
     
        %legend(legendinfo,'Location','eastoutside');
        
        %legendinfo{a}=['thickness',num2str(plate(a)),' hole depth',num2str(depth(a))];
        legendinfo{1}=['thickness',num2str(plate(a)),' hole depth',num2str(depth(a))];
        
        %para plotar:
        %legend(legendinfo);

        %ylabel(' {\sigma}_y (Mpa)');
        ylabel(' {\sigma}_y (Mpa)');
        xlabel('x axis(mm)' );
        %aguardar 2s e plotar o pr�ximo ponto
        %xlswrite('teste5', matrizGeo(:,:),'sheet1',num2str(2*a));
    end
    title(strcat('{ \sigma}_y stress '));
    %title(strcat('Nominal Stress { \sigma}_n '));
    %legend(legendinfo);
    %legendinfo{a+cont}=['blue',axial={cont}];
    legend(legendinfo);
end
    %legendinfo{a+1}=['Black'];
    %legendinfo{a+2}=['Blue'];
    S = 1.0; % MPa
    teta = 270*3.1415926535897932384626433832795/180; % teta em Radianos 
    a = 2.0; %Raio furo em mm
    r = [a:0.1:30];

    sigma_r    = (S/2).*( 1 - ( (a^2)./(r.^2) ) ) + (S/2).*( ( 1 + 3.*( (a^4)./(r.^4) ) - 4.*( (a^2)./r.^2 ) ) ).*cos(2*teta);
    sigma_teta = (S/2).*( 1 + ( (a^2)./(r.^2) ) ) - (S/2).*( ( 1 + 3.*( (a^4)./(r.^4) )                      ) ).*cos(2*teta);

    legendinfo{1}=['{\sigma}_r'];%legenda
    legendinfo{2}=['{\sigma}_{\theta}'];%legenda

    grid on
    plot(r,sigma_r,'k-.','markersize',25);%% sigma_r
    hold on
    grid on
    plot(r,sigma_teta,'b-.','markersize',25);%% sigma_teta
    hold on 
    
    figure
r=30-matriz(:,2);
sigma_teta = (S/2).*( 1 + ( (a^2)./(r.^2) ) ) - (S/2).*( ( 1 + 3.*( (a^4)./(r.^4) )                      ) ).*cos(2*teta);
diff_K_sim=matriz(:,9)-sigma_teta;
diff_K_sim;
plot(30-matriz(:,2),diff_K_sim,plotstyle{cont,a},'markersize',5) %9 � sigma y
grid on