% The following code plots the stress profile of the nodes on the line where the holes difference variates
% the holes difference
clear all
close all
mkdir plots
axial={'uniaxial','biaxial','uniaxial','biaxial'};
[m t] = size(axial);
sigma_ymin=[3.0 2.0 3.0 2.0] 
%plotstyle3{1}={'k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.'}; 
%plotstyle3{2}={'k*','b*','g*','r*','y*','m*','c*','k*','b*','g*','r*','y*','m*','c*','k*','b*','g*','r*','y*','m*','c*','k*'}; 
%cont2=-65;
xpos=[10 660 10 660]
ypos=[10 10 510 510]
n=0;
for cont=1:2:t
    %cont2=cont2 + 66;
    
    %figure('rend','painters','pos',[10*cont2 80 650 500],'Name',upper(axial{cont})); % => este comando funciona no MATLAB -> ñ funciona no OCTAVE
    %saveas(figure(cont),[pwd '/plots/plot',axial{cont},'_number_',num2str(cont),'.png']);
    %savefig(gcf,'figure',num2str(cont),'.fig');
    figure('pos',[xpos(cont) ypos(cont) 650 500],'Name',upper(axial{cont}));
    %movegui(f,[125*cont2,200]);
    %plotstyle1={'k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.','b.','g.','r.','y.','m.','c.','k.'}; 
    plotstyle1={'k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-','b.-','g.-','r.-','y.-','m.-','c.-','k.-'}; 
    %plotstyle1={'k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y.','m-','c-','k-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-','b-','g-','r-','y-','m-','c-','k-'}; 
    diff=[6:0.5:20]; %Point differences to be read
    [m n] = size(diff);
    %Some importants parameters
    r = 2; %hole radius
    L = 60; % comprimento do modelo (x2 do ansys apdl)

    for a=1:1:n %going through each point difference
        path=['C:\Manasses\varying_hole_distance_with_refined_mesh_region\',axial{cont},'\difference',num2str(diff(a)),'mm\'];%address
        %path=['C:\Users\TTR01\Desktop\Manasses\varying_hole_distance\biaxial\difference',num2str(diff(a)),'mm\'];%address
        nome='dados_dos_nos_A3.txt';%file name
        [n,xloc,yloc,zloc,ux,uy,uz,sx,sy,sz,se]=textread([path nome],'%f %f %f %f %f %f %f %f %f %f %f');%Lê o arquivo Salva as colunas em 10 variáveis
        
        matriz=[n(:,1),xloc(:,1),yloc(:,1),zloc(:,1),ux(:,1),uy(:,1),uz(:,1),sx(:,1),sy(:,1),sz(:,1),se(:,1)];%preparing to sort the data
        matriz=sortrows(matriz,2); %Deixa os dados em ordem crescente
        [i,j]=find(matriz(:,4)~=0.0);%transversal line at the surface of the plate
        matriz(i,:)=[];%exclui os pontos que não estão na superfície do modelo
        [i,j]=find(matriz(:,9)==0); %finds sigmax values equal to zero
        matriz(i,:)=[];%exclui os valores de tensão igual a zero (nós intermediários)
        [i,j]=size(matriz);
        %pa(a)=plot(matriz(:,2),matriz(:,8),plotstyle3{a},'markersize',10,'LineWidth',2)
        % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = xcenter1  (A1)
        % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = x2/2 = 10 (A2) 
        % matriz(:,2) -> indica valores ao longo do eixo x  -> plano y = y2/2 = 5  (A3)
        %hold on 
        x1 = ((L-diff(a))/2)-r;
        x2 = ((L-diff(a))/2)+r;
        [i,j]=find(matriz(:,2)==x1|matriz(:,2)==x2); %size(i) é numero de points
        
        [g h] = size(matriz); %saber dimensão da matriz
        
        switch cont
            case {1,2}
                legendinfo{a}=[num2str(diff(a)),' mm'];%legenda
                grid on
                pa(a)=plot(matriz(1:i(1),2),matriz(1:i(1),9),plotstyle1{a},'markersize',10)
                %plot(matriz(1:i(1),2),max(matriz(:,9)),plotstyle1{a},'markersize',10)
                hold on
                grid on
                plot(matriz(i(2):g,2),matriz(i(2):g,9),plotstyle1{a},'markersize',10)
                 %plot(matriz(i(2):g,2),max(matriz(:,9)),plotstyle1{a},'markersize',10)
                hold on
                ylabel(' {\sigma}_y (Mpa)');
                xlabel('x axis(mm)' );
                title(strcat('{ \sigma}_y stress - ',axial(cont)));
                %legend([pa(a)], legendinfo);
                %temp=a; %temp eh o numero de curvas ou de difrencas
            
            case {3,4}
                MATRIZSTRESST(1:size(i),1,a)=matriz(i,2);%x position
                MATRIZSTRESST(1:size(i),2,a)=matriz(i,9);%Stresses x
                %matrizGeo(1:size(i),1) = diff(a);
                %matrizGeo(1:size(i),2) = MATRIZSTRESST(1:size(i),2,a);
              
                percx1(a) = (MATRIZSTRESST(1,2,a) - sigma_ymin(cont)) / sigma_ymin(cont);
                percx2(a) = (MATRIZSTRESST(2,2,a) - sigma_ymin(cont)) / sigma_ymin(cont);
                % with one hole as a reference
                
                %grid on
                %plot(diff(a),percx1(a)*100,'g.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
                %hold on
                %plot(diff(a),percx2(a)*100,'r.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
                %hold on 
                
                grid on
                plot(diff(a),MATRIZSTRESST(1,2,a),'g.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
                hold on
                plot(diff(a),MATRIZSTRESST(2,2,a),'r.','markersize',25);%% Percentage stress increase in comparison with the plate with one hole
                hold on 
                %bar plots
                %grid on
                %bar(diff(a),MATRIZSTRESST(1,2,a),'g')%% Percentage stress increase in comparison with the plate with one hole
                %hold on
                %bar(diff(a)+1,MATRIZSTRESST(2,2,a),'r')%% Percentage stress increase in comparison with the plate with one hole
                %hold on 
                
                %grid on
                %plot(matriz(:,2),matriz(:,9),plotstyle1{a},'markersize',15)
                %hold on
                %legenda
                %legend(legendinfo);
                legendinfo2{1}=['point x1'];
                legendinfo2{2}=['point x2'];
                ylabel(' {\sigma}_y (%)');
                xlabel('Hole difference(mm)' )
                title(strcat('percentage{  \sigma}_y stress - ',axial(cont)));
                legend(legendinfo2);
                
            otherwise
                %disp('other value')
        end
        %aguardar 2s e plotar o próximo ponto
        %xlswrite('teste5', matrizGeo(:,:),'sheet1',num2str(2*a));
    end
    %title(strcat('{ \sigma}_y stress - ',axial(cont)));
    %legend(legendinfo,'Location','eastoutside');
    %temp=8 -> para cont=1, e cont=2, %temp=2 -> cont=3 e cont=4
    if cont==1|cont==2 
        legend([pa(1:1:a)], legendinfo); %pa(a) representa a curva salva
    end
    %if cont==3|cont==4 
     %   legend(legendinfo2); %pa(a) representa a curva salva
    %end
    
    saveas(figure(cont),[pwd '/plots/plot_',axial{cont},'_number_',num2str(cont),'.png']);
    saveas(figure(cont),[pwd '/plots/plot_',axial{cont},'_number_',num2str(cont),'.fig']);

end
    

%% Organizing the data, highest stress values and position, interpolation for the plate with one central hole (in this case, nhole equal 2)
%df=diff(a);
