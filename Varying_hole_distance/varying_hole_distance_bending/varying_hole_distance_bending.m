% The following code plots the points A (x1) and B (x2) (cor preta e azul).
% The intention is to plot 2 charts, one UNIAXIAL, other BIAXIAL BENDING


clear all
close all
axial={'bending_uniaxial','bending_biaxial'};
[maxial naxial] = size(axial);
diff=[5.5:0.5:20 25:5:50 54.5];% remember that in the 14mm geometry, diff=[....50 51 53 54.5]
[mdiff ndiff] = size(diff);

%folder{1}='varying_hole_distance_plate_1.5_depth_1.5_refined_mesh_region_ring';
%folder{2}='varying_hole_distance_plate_1.5_depth_1_refined_mesh_region_ring';
%folder{3}='varying_hole_distance_plate_14_depth_1_refined_mesh_region_ring';
%[mfolder nfolder] = size(folder);

%Some importants parameters
r = 2; %hole radius
L = 60; % comprimento do modelo (x2 do ansys apdl)
%chart position
xpos=[10 660 10 660 10 660];
ypos=[10 10 510 510 10 10];
%for the plot
plotstyle_A={'k.','ko','kd'};
plotstyle_B={'b.','bo','bd'};
markersize=[35,11,11];
%legend
legendinfo{1}=['point A'];
legendinfo{2}=['point B'];

for cont=1:1:naxial %2 situations: UNIAXIAL, BIAXIAL
    %figure('pos',[xpos(cont) ypos(cont) 650 500],'Name',upper(axial{cont}));
    figure('units','normalized','outerposition',[0 0 1 1])
    
    
    %for cont2=1:1:nfolder %3 geometries, 3 different folders
        
        % this block collect data and fullfill MATRIZSTRESST, and calculate u1 and u2
        for a=1:1:ndiff %going through each point difference
            %this block (if condition) is for the 14mm geometry only
            if diff(a)==20
                a1=a;
            end
            if diff(a)==40
                a2=a;
            end
            
            %path=['C:\Manasses\',folder{cont2},'\',axial{cont},'\difference',num2str(diff(a)),'mm\'];%address
            path=['C:\Manasses\varying_hole_distance_bending\',axial{cont},'\difference',num2str(diff(a)),'mm\'];%address
            nome='dados_dos_nos_A3.txt';%file name
            [n,xloc,yloc,zloc,ux,uy,uz,sx,sy,sz,se]=textread([path nome],'%f %f %f %f %f %f %f %f %f %f %f');%L� o arquivo Salva as colunas em 10 vari�veis
            matriz=[n(:,1),xloc(:,1),yloc(:,1),zloc(:,1),ux(:,1),uy(:,1),uz(:,1),sx(:,1),sy(:,1),sz(:,1),se(:,1)];%preparing to sort the data
            matriz=sortrows(matriz,2); %Deixa os dados em ordem crescente
            [i,j]=find(matriz(:,4)~=0.0);%transversal line at the surface of the plate
            matriz(i,:)=[];%exclui os pontos que n�o est�o na superf�cie do modelo
            [i,j]=find(matriz(:,9)==0); %finds sigmax values equal to zero
            matriz(i,:)=[];%exclui os valores de tens�o igual a zero (n�s intermedi�rios)
            [i,j]=size(matriz);
            % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = xcenter1  (A1)
            % matriz(:,3) -> indica valores ao longo do eixo y  -> plano x = x2/2 = 30 (A2) 
            % matriz(:,2) -> indica valores ao longo do eixo x  -> plano y = y2/2 = 30 (A3)
            x1 = ((L-diff(a))/2)-r;
            x2 = ((L-diff(a))/2)+r;
            [i,j]=find(matriz(:,2)==x1|matriz(:,2)==x2); %size(i) � numero de points

            [g h] = size(matriz); %saber dimens�o da matriz
            MATRIZSTRESST(1:size(i),1,a)=matriz(i,2);%x position
            MATRIZSTRESST(1:size(i),2,a)=matriz(i,9);%Stresses x
            
        end%endfor, going through each point difference
        
        u1=min(min(MATRIZSTRESST(1,2,:)));
        %if cont2==3
        %    u1=min(min(MATRIZSTRESST(1,2,a1:a2))) % for the 14mm geometry
        %end
        u2=min(min(MATRIZSTRESST(2,2,:)));
        
        %for legend purposes
        %try to explain latter
        cont2=1;
        ndc(cont2)=(ndiff*(cont2-1));
        ndc(1)=0;
        ttt=ndc(cont2);
        %
                
        for temp=1:1:ndiff %'temp' has the same role as 'a', this block is for the plot
            
            %AxesH = axes('Xlim', [5, 50], 'XTick', 5:5:50, 'NextPlot', 'add');
            grid on
            point_A(temp+ttt)=plot(diff(temp),((MATRIZSTRESST(1,2,temp)- u1)/u1)*100,plotstyle_A{cont2},'markersize',markersize(cont2),'Linewidth',2.5)%% Percentage stress increase in comparison with the plate with one hole
            
            hold on
            point_B(temp+ttt)=plot(diff(temp),((MATRIZSTRESST(2,2,temp)- u2)/u2)*100,plotstyle_B{cont2},'markersize',markersize(cont2),'Linewidth',2.5)%% Percentage stress increase in comparison with the plate with one hole
            
            hold on
            %ylabel('{\sigma}_x difference (%)');
            ylabel( '100({\sigma}_x - {\sigma}_{xmin})/{\sigma}_{xmin}' );
            %xlabel('Distance between holes (mm)' );
            xlabel('L_b (mm)' );
            
            xlim([5 55]);
            ylim([-10 70]);
            
            %tit=title('{\sigma}_x variation in relation to the lowest value within the range');
            tit=title('{\sigma}_x variation (Reference: {\sigma}_{xmin})');
            %the sigma x is duo adopted notation, 
            %title(strcat('percentage{  \sigma}_y stress - ',axial(cont)));
            %legend(legendinfo);
            %set(gca,'ytick',0:2.5:25);
            %set(gca,'xtick',5:2.5:25);
            set(gca,'fontname','times','FontSize',33)
            set(tit,'fontname','times','FontSize',33,'FontWeight','Normal')
            set(gcf,'PaperPosition',[0 0 35 20])
            grid on

            %xlim([5 25]);
            %ylim([0 20]);
            
        end%endfor, plot chart
        
    %end%endfor, 3 geometries, 3 different folders
    
    %POG for Legend
    %legend([pa(1) pa(2) pa(3) pa(4) pa(5) pa(6)], {'Tetra (1 hole)', 'Hexa (1 hole)','Tetra (no hole)','Tetra (no hole)','Hexa (2 holes)','Hexa (2 holes)'})
    %p15=ndc(2)+1; %-> 38
    %p140=ndc(3)+1; %-> 75
    
    %legend([point_A(1) point_B(1) point_A(p15) point_B(p15) point_A(p140) point_B(p140)],{'through hole - point A','through hole - point B','1.5mm 1.0mmm - point A ','1.5mm 1.0mmm - point B','14mm 1.0mmm - point A','14mm 1.0mmm - point B'});
    %legend([point_A(1) point_B(1) point_A(p15) point_B(p15) point_A(p140) point_B(p140)],{'T_p/H_d=1 - point A','T_p/H_d=1 - point B','T_p/H_d=1.5 - point A ','T_p/H_d=1.5 - point B','T_p/H_d=14 - point A','T_p/H_d=14 - point B'},'Position',[0.7 0.6 0.1 0.2]);
    legend(legendinfo)
    saveas(gcf,['chart1_',axial{cont},'.png']);
    saveas(gcf,['chart1_',axial{cont},'.fig']);
    
end%endfor, 2 situations: UNIAXIAL, BIAXIAL

