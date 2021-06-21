% The following code plots the max or min poits of stress in function of
% the holes difference
clear all
close all

plotstyle3={'k-o','b-*','k-.^','b-.v','k:d','b:+','k-P','b-*','g-.<','k-.o','b-.>','r-*','g.','b.','c.','m.','g.','k.','r.','b.','g.','k.','k.','b.','r.'}; 
%'k.','k.','k.','k.','k.','k.','k.',
diff=[4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10] %Point differences to be read
[m n] = size(diff)

%Some importants parameters
r = 2 %hole radius
L = 30 % comprimento do modelo (x2 do ansys apdl)

for a=1:1:n %going through each point difference

    path=['C:\Users\TTR01\Desktop\Manasses\varying_hole_distance\biaxial\difference',num2str(diff(a)),'mm\'];%address
    nome='dados_dos_nos_A3.txt';%file name
         
    [n,xloc,yloc,zloc,ux,uy,uz,sx,sy,sz,se]=textread([path nome],'%f %f %f %f %f %f %f %f %f %f %f');%Lê o arquivo Salva as colunas em 10 variáveis
    %legendinfo{a}=['distance ',num2str(diff(a)),' mm'];%legenda
    matriz=[n(:,1),xloc(:,1),yloc(:,1),zloc(:,1),ux(:,1),uy(:,1),uz(:,1),sx(:,1),sy(:,1),sz(:,1),se(:,1)];%preparing to sort the data
    matriz=sortrows(matriz,2); %Deixa os dados em ordem crescente

    [i,j]=find(matriz(:,4)~=0.0);%transversal line at the surface of the plate
    matriz(i,:)=[];%exclui os pontos que não estão na superfície do modelo

    [i,j]=find(matriz(:,9)==0); %finds sigmax values equal to zero
    matriz(i,:)=[];%exclui os valores de tensão igual a zero (nós intermediários)
    [i,j]=size(matriz)


    %pa(a)=plot(matriz(:,2),matriz(:,8),plotstyle3{a},'markersize',10,'LineWidth',2)
    % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = xcenter1  (A1)
    % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = x2/2 = 10 (A2) 
    % matriz(:,2) -> indica valores ao longo do eixo x  -> plano y = y2/2 = 5  (A3)
       
    %hold on
    
    x1 = ((L-diff(a))/2)-r
    x2 = ((L-diff(a))/2)+r
            
    [i,j]=find(matriz(:,2)==x1|matriz(:,2)==x2); %size(i) é numero de points
    MATRIZSTRESST(1:size(i),1,a)=matriz(i,2);%x position
    MATRIZSTRESST(1:size(i),2,a)=matriz(i,9);%Stresses x
      
    legendinfo{1}=['point x1'];%legenda
    legendinfo{2}=['point x2'];%legenda
   
    % with one hole as a reference
    grid on
    plot(diff(a),MATRIZSTRESST(1,2,a),'g.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
    hold on
    plot(diff(a),MATRIZSTRESST(2,2,a),'r.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
    hold on 
    
       
    %title('Stress relief for holes with different distances between the center hole{ \sigma}_x = 1 (nominal)');
    legend(legendinfo);

    %xlim([40 80]);
    %ylim([100 300]);
    %ylim([0.02 0.03]);
   
    ylabel(' {\sigma}_y (Mpa)');
    xlabel('Hole difference(mm)' )
    %porcentagem
    %aguardar 2s e plotar o próximo ponto

 end



%% Organizing the data, highest stress values and position, interpolation for the plate with one central hole (in this case, nhole equal 2)
%df=diff(a);
