! CENTER HOLE (02/01/2018) modified in (02/03/2018), modified/adapted for finer mesh region in (12/03/2018)
*enddo

		!Document header
		finish
		!/cle
		/cle,,nopr
		/Title, center_hole
		save
		/prep7
		seltol,0.00001
		
		*dim,wd,string,200,1
		wd(1,1)='C:\Manasses\center_hole'
		/cwd,wd(1,1) !it must be a comment when running on optimization mode!!!!!!!!!!!!!!!!!
		
		*dim,axial,string,200,3
		axial(1,1) ='uniaxial'
		axial(1,2) ='biaxial'
		axial(1,3) ='uniaxial_r_eq_1'
		
		*dim,solver,array,1,3
		solver(1,1) =1 !uniaxial
		solver(1,2) =2 !biaxial
		solver(1,3) =1 !uniaxial
		
		*dim,plate,array,1,5
		plate(1,1) =1.5
		plate(1,2) =1.5
		plate(1,3) =14.0
		plate(1,4) =1.5
		plate(1,5) =0.5
		
		*dim,depth,array,1,5
		depth(1,1) =1.5
		depth(1,2) =1.0
		depth(1,3) =1.0
		depth(1,4) =1.5
		depth(1,5) =0.5
		
		*dim,mesh,array,1,5
		mesh(1,1) =0.5
		mesh(1,2) =1
		mesh(1,3) =1.0 !there's differents regions now [???]
		mesh(1,4) =0.5
		mesh(1,5) =0.5
		
				
	*do,cont,1,2,1
	
		!Defining the curent working directory
		finish
		/cwd,wd(1,1) !it must be a comment when running on optimization mode!!!!!!!!!!!!!!!!!
						
		!Save parameters1 to clear the graphics interface

		parsav,all,parameters1,txt,wd(1,1)
		/mkdir,%axial(1,cont)% !Creates the new folder for the current iteration
		finish
		/clear,,nopr
		/prep7 
						
		parres,new,parameters1,txt,'C:\Manasses\center_hole'
		/cwd,%wd(1,1)%\%axial(1,cont)%
		!/Title,difference%diff%mm  !varying_hole_distance
		finish
		!/filname,difference%diff%mm !varying_hole_distance
		/prep7
			
		*do,cont2,1,3,1
			finish
			/cwd,%wd(1,1)%\%axial(1,cont)% !it must be a comment when running on optimization mode!!!!!!!!!!!!!!!!!
							
			!Save parameters1 to clear the graphics interface

			parsav,all,parameters2,txt,wd(1,1)
			/mkdir,plate_%plate(1,cont2)%_depth_%depth(1,cont2)% !Creates the new folder for the current iteration
			finish
			/clear,,nopr
			/prep7 
							
			*dim,axial,string,200,3
			axial(1,1) ='uniaxial'
			axial(1,2) ='biaxial'
			axial(1,3) ='uniaxial_r_eq_1'
			parres,new,parameters2,txt,'C:\Manasses\center_hole'
			/cwd,%wd(1,1)%\%axial(1,cont)%\plate_%plate(1,cont2)%_depth_%depth(1,cont2)% 
			/Title,%axial(1,cont)%_plate_%plate(1,cont2)%_depth_%depth(1,cont2)%  !varying_hole_distance
			finish
			/filname,%axial(1,cont)%_plate_%plate(1,cont2)%_depth_%depth(1,cont2)% !varying_hole_distance
			/prep7
			
			!Módulo de Elasticidade(MPa)
			MP,EX,1,2E5
			!Coeficiente de Poisson
			MP,PRXY,1,0.3
			!Profundidade Nominal do Furo(mm)
			!PROF=1.0
			!Raio Nominal do Furo(mm)
			R=2
			!Tensão Residual(MPa)
			P=1
			
			! GEOMETRIA
			!Parameterized parallelepiped dimensions
			x1 = 0 
			x2 = 60
			y1 = 0
			y2 = 60
			z1 = 0
			t1_14=0
			*if,cont2,eq,3,then !TENTAR MELHORAR
				t1_14=(14-1.5)
			*endif
			z2 = plate(1,cont2)-t1_14 ! in order to make a finer mesh in this region volume -t1_14 =(14-1.5)
			block,x1,x2,y1,y2,-z1,-z2
			allsel
			*get,volume1,volu,0,num,max !select the first volume number 
			!cylinder -> hole
			xcenter1 	= x2/2		
			ycenter1 	= y2/2
			raio_int1 	= 2.0
			raio_ext1   = 0.0
			angle_int1  = 360
			angle_ext1  = 0.0
			depth1 	    = depth(1,cont2)
			cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
			gplot
			!now 2 volumes are selected
			!let's unselected the first one
			allsel
			vsel,u,volu,,volume1	
			*get,volume2,volu,0,num,max !select the second volume number 
			!volumes generic selection
			allsel
			vsbv,volume1,volume2
			vplot
			/view,1,1,1,1
			vplot	
			
			!delete variables
			*set,volume1
			*set,volume2
			!*set,volume3
			
			!!!!!
			
			!Refining mesh in the hole region // [ RING ]
			allsel !select all volumes (there's only one left)
			*get,volume1,volu,0,num,max	 !it gets the volume number	
			allsel
			
			xcenter1 	= x2/2		
			ycenter1 	= y2/2
			raio_int1 	= 2.0
			raio_ext1   = 2.5
			angle_int1  = 360
			angle_ext1  = 0.0
			depth1 	    = 1.5
			
			cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
			allsel !select all volumes 
			
			
			vsel,u,volu,,volume1	 !unselect volume1
			*get,volume2,volu,0,num,max	!it gets the volume number (from the volume left, volume2)
			allsel !select all volumes 
			vsbv,all,volume2,,delete,keep !subtract volume2 from all, the blank space indicates to keep a common area between the volumes
			
			vsel,all
			vglue,all
			!!!!!
			/pnum,volu,1
			/rep
			
			!delete variables
			*set,volume1
			*set,volume2
			
			!FOR THE 14 mm GEOMETRY ONLY
			!------ model a 13.5 mm depth block
			
			*if,cont2,eq,3,then
				!let's name the block by 'B'
				Bx1 = 0 
				Bx2 = 60
				By1 = 0
				By2 = 60
				Bz1 = 1.5
				Bz2 = 14
				block,Bx1,Bx2,By1,By2,-Bz1,-Bz2
				
				z2 = Bz2 !for 14mm ONLY
				
				vsel,all
				vglue,all
			*endif
				
			!CREATING TWO BLOCKS TO SUBTRACT
			allsel
			block,x1-1,x2+1,y1-1,y2/2,z1+1,-z2-1     !-> gera 1
			!selectin the last volume created
			asel,s,loc,y,-1 ! -1 specific from the first block
			vsla,s,0 !select a specific volume from a specific area, by selection tools
			*get,volume1,volu,0,num,max	!select the current volume number
			allsel
			vsbv,all,volume1 !subtract
			vplot
			
			allsel
			block,x2/2,x2+1,(y2/2)-1,y2+1,z1+1,-z2-1 !-> gera 2
			!selectin the last volume created
			asel,s,loc,x,x2+1 ! x2+1 specific from the second block
			vsla,s,0 !select a specific volume from a specific area, by selection tools
			*get,volume2,volu,0,num,max	!select the current volume number
			allsel
			vsbv,all,volume2 !subtract
			vplot
			
			!delete variables
			*set,volume1
			*set,volume2			
			
			! MALHA
			!volume selection
			allsel
			!element type 
			et,1,187
			!trying to select the ring and the 
			allsel
			ksel,s,loc,x,x1
			ksel,r,loc,y,y2
			ksel,r,loc,z,z1
			lslk,s,0
			asll,s,0
			vsla,s,0 !select a specific volume from a specific area, by selection tools
			*get,volume1,volu,0,num,max
			allsel
			vsel,u,volu,,volume1
			vplot
			! 14 mm
			*if,cont2,eq,3,then
				allsel
				ksel,s,loc,z,-Bz2
				ksel,r,loc,x,x1
				ksel,r,loc,y,y2
				lslk,s,0
				asll,s,0
				vsla,s,0 !select a specific volume from a specific area, by selection tools
				*get,volume2,volu,0,num,max
				allsel
				vsel,u,volu,,volume1
				vsel,u,volu,,volume2
				vplot
				
				esize,0.2
				vmesh,all
				allsel
				esize,0.5
				vmesh,volume1
				allsel
				esize,2
				vmesh,volume2
			*else
				esize,0.2
				vmesh,all
				allsel
				esize,0.5
				vmesh,volume1
			*endif
			!------
			!esize,0.2
			!vmesh,all
			!allsel
			!esize,0.5
			!vmesh,volume1
			!allsel
			!esize,2
			!vmesh,volume2
			!--------
			!allsel
			!element type 
			!et,1,187
			!Comprimento do elemento padrão 
			!size= mesh(1,cont2)
			!esize,size
			!command
			!vmesh,all
			!eplot
			
			! NUMERAÇÃO DE NÓS 
			! PRIMEIRA SEÇÃO A1(x2/2)
			!Alterando a sequência (numeracao) dos nós ao longo da seção de interesse
			asel,s,loc,x,x2/2
			nsla,s,1
			*get,maior_numero_de_nos,node,,num,max 
			numstr,node,maior_numero_de_nos !Estabelece números iniciais para itens numerados automaticamente.
			*set, maior_numero_de_nos,
			ksel,none 				!seleciona keypoints - none - deseleciona o conjunto completo
			knode,0,all 			!Define keypoints em um local de nó existente.
			nkpt,0,all  			!Define nós em local de keypoint existente.
			kdel,all    			!Deleta 'unmeshed' keypoints.
			nummrg,node,,,,high
			! segunda SEÇÃO A2(y2/2)
			!Alterando a sequência (numeracao) dos nós ao longo da seção de interesse
			asel,s,loc,y,y2/2
			nsla,s,1
			!asel,s,loc,x,xcenter1
			!nsla,u,1
			asel,s,loc,x,x2/2
			nsla,u,1
			*get,maior_numero_de_nos,node,,num,max 
			numstr,node,maior_numero_de_nos !Estabelece números iniciais para itens numerados automaticamente.
			*set, maior_numero_de_nos,
			ksel,none 				!seleciona keypoints - none - deseleciona o conjunto completo
			knode,0,all 			!Define keypoints em um local de nó existente.
			nkpt,0,all  			!Define nós em local de keypoint existente.
			kdel,all    			!Deleta 'unmeshed' keypoints.
			nummrg,node,,,,high
			
			! CONDIÇÕES DE SIMETRIA
			!(seção ao longo do eixo X)
			asel,s,loc,x,x2/2
			nsla,s,1
			dsym,symm,x,0
			!(seção ao longo do eixo Y)
			asel,s,loc,y,y2/2
			nsla,s,1
			dsym,symm,y,0

			! CONDIÇÕES DE CONTORNO
			allsel
			vplot

			ksel,s,loc,x,x1
			ksel,r,loc,y,y2/2
			ksel,r,loc,z,z1
			nslk,s
			d,all,uz,0
			
			! CARREGAMENTO |1| => Fy (Vertical Y)
			allsel
			asel,s,loc,y,y2
			sfa,all,1,pres,-p
			asel,s,loc,y,y1
			sfa,all,1,pres,-p
			allsel
			
			!SAVE FILE UNIAXIAL CARREGAMENTO |1| => F = Fy (Vertical Y)
			lswrite,1

			! CARREGAMENTO |2| => Fx (Horizontal X) 
			allsel
			asel,s,loc,x,x2
			sfa,all,1,pres,-p
			asel,s,loc,x,x1
			sfa,all,1,pres,-p
			allsel
			
			!SAVE FILE BIAXIAL  (SOMOU CARREGAMENTO |1|+|2|) F = Fy + Fx
			lswrite,2 
			
			!temp=cont
			
			! SOLUÇÃO |1| or |2| => UNIAXIAL or BIAXIAL
			finish
			/solu
			lssolve,solver(1,cont)
			save
			
			! VISUALIZANDO RESULTADOS NA TELA
			/post1
			plnsol,s,eqv,0,0.5
			!pldisp,1
			!pldisp,2
			!/dscale,1,1
	
			!PARTE PROBLEMÁTICA
		
			! primeira SEÇÃO A1(x2/2)
			! OBTENÇÃO DE DADOS (nós)
			asel,s,loc,x,x2/2
			nsla,s,1
			*get,numero_de_nos,node,,count
			*get,menor_numero_de_nos,node,,num,min
			!set,1
			
			
			
			
			!set!(tem relação com file.s01)
			
			
			
			
			save
			colunas_matriz = 10
			*dim,dados_dos_nos_A1,array,numero_de_nos,colunas_matriz
			*get,menor_numero_de_nos,node,,num,min
			
			/cwd,wd(1,1)
			
			/input,dados_forma_matriz_A1,txt !(cria arquivo dados_dos_nos_A1.txt)
			! ARMAZENAMENTO DE DADOS
			*vget,dados_dos_nos_A1(1,1),node,menor_numero_de_nos,loc,x
			*vget,dados_dos_nos_A1(1,2),node,menor_numero_de_nos,loc,y
			*vget,dados_dos_nos_A1(1,3),node,menor_numero_de_nos,loc,z
			*vget,dados_dos_nos_A1(1,4),node,menor_numero_de_nos,u,x
			*vget,dados_dos_nos_A1(1,5),node,menor_numero_de_nos,u,y
			*vget,dados_dos_nos_A1(1,6),node,menor_numero_de_nos,u,z
			*vget,dados_dos_nos_A1(1,7),node,menor_numero_de_nos,s,x
			*vget,dados_dos_nos_A1(1,8),node,menor_numero_de_nos,s,y
			*vget,dados_dos_nos_A1(1,9),node,menor_numero_de_nos,s,z
			*vget,dados_dos_nos_A1(1,10),node,menor_numero_de_nos,s,eqv
			/input,dados_forma_matriz_A1,txt
			
			/cwd,%wd(1,1)%\%axial(1,cont)%\plate_%plate(1,cont2)%_depth_%depth(1,cont2)% 
			
			! segunda SEÇÃO A2(y2/2)
			asel,s,loc,y,y2/2
			nsla,s,1
			!asel,s,loc,x,xcenter1
			!nsla,u,1
			asel,s,loc,x,x2/2
			nsla,u,1
			*get,numero_de_nos,node,,count
			*get,menor_numero_de_nos,node,,num,min
			!set,1
			set!(tem relação com file.s01)
			save
			colunas_matriz = 10
			*dim,dados_dos_nos_A2,array,numero_de_nos,colunas_matriz
			*get,menor_numero_de_nos,node,,num,min
			
			/cwd,wd(1,1)
			
			/input,dados_forma_matriz_A2,txt !(cria arquivo dados_dos_nos_A2.txt)
			! ARMAZENAMENTO DE DADOS
			*vget,dados_dos_nos_A2(1,1),node,menor_numero_de_nos,loc,x
			*vget,dados_dos_nos_A2(1,2),node,menor_numero_de_nos,loc,y
			*vget,dados_dos_nos_A2(1,3),node,menor_numero_de_nos,loc,z
			*vget,dados_dos_nos_A2(1,4),node,menor_numero_de_nos,u,x
			*vget,dados_dos_nos_A2(1,5),node,menor_numero_de_nos,u,y
			*vget,dados_dos_nos_A2(1,6),node,menor_numero_de_nos,u,z
			*vget,dados_dos_nos_A2(1,7),node,menor_numero_de_nos,s,x
			*vget,dados_dos_nos_A2(1,8),node,menor_numero_de_nos,s,y
			*vget,dados_dos_nos_A2(1,9),node,menor_numero_de_nos,s,z
			*vget,dados_dos_nos_A2(1,10),node,menor_numero_de_nos,s,eqv

			
			/input,dados_forma_matriz_A2,txt
		
			/cwd,%wd(1,1)%\%axial(1,cont)%\plate_%plate(1,cont2)%_depth_%depth(1,cont2)% 
		
			*set,dados_dos_nos_A1,,nopr   !''ativar dentro de um loop''
			*set,dados_dos_nos_A2,,nopr
			!*set,dados_dos_nos_A3,,nopr
			
			/post1
			plnsol,s,eqv
			
		*enddo
			
	*enddo			
	
		
		
			

!!!Observacoess: os comandos parsav e parres servem para salvar  os parametros e limpar a interface gráfica
