! VARYING HOLE DISTANCE (23/01/2018) SIGMA Y - varying_hole_distance_plate_14_depth_1_refined_mesh_region_ring - uniaxial

*enddo
                !Document header
                finish
                /cle,,nopr
                /Title, varying_hole_distance
				save
                /prep7
				seltol,0.00001
				
				!Defining the curent working directory
				*dim,wd,string,200,1
				wd(1,1)='C:\Manasses\varying_hole_distance_plate_14_depth_1_refined_mesh_region_ring\uniaxial'
                /cwd,wd(1,1) !it must be a comment when running on optimization mode!!!!!!!!!!!!!!!!!
								
				
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
				
				!Distance from the border to the first hole center 
				!diff = 5.5 !mínimo 5.0 mm -> PROBLEM BORDER
				inicial = 20
				final = 55
				incr = 5
!Estrutura de repetição:						
*do,diff,inicial,final,incr
	*if,diff,eq,55,then
		diff=54.5 !minimum, ring problem
	*endif
	!Save parameters to clear the graphics interface
	finish
	/cwd,wd(1,1)
	
	parsav,all,parameters,txt,wd(1,1)
	/mkdir,difference%diff%mm !Creates the new folder for the current iteration
	finish
	/clear,,nopr
	/prep7 
					
	parres,new,parameters,txt,'C:\Manasses\varying_hole_distance_plate_14_depth_1_refined_mesh_region_ring\uniaxial'
	/cwd,%wd(1,1)%\difference%diff%mm !salvando nas diferentes pastas
	/Title,difference%diff%mm  !varying_hole_distance
	finish
	/filname,difference%diff%mm !varying_hole_distance
	/prep7
	
	!INÍCIO DO BLOCO DE COMANDO DENTRO DO LOOP
		seltol,0.00001
		
		!Módulo de Elasticidade(MPa)
		MP,EX,1,2E5
		!Coeficiente de Poisson
		MP,PRXY,1,0.3
		
		! GEOMETRIA
		!Dimensões parametrizadas do paralelepípedo
		x1 = 0 
		x2 = 60
		y1 = 0
		y2 = 60
		z1 = 0
		z2 = 1.5
		block,x1,x2,y1,y2,-z1,-z2
		allsel !volume1 is select
		*get,volume1,volu,0,num,max !it gets the volume number, and stores in the variable "volume1"

		!Dimensões parametrizadas dos furos
		xcenter1 	= (x2 - diff)/2		
		ycenter1 	= y2/2
		raio_int1 	= 2.0
		raio_ext1	= 0.0
		angle_int1  = 360
		depth1 	    = 1.0
		
		xcenter2 	= x2 - xcenter1	! Symmetry
		ycenter2 	= y2/2
		raio_int2 	= 2.0
		raio_ext2	= 0.0
		angle_int2  = 360
		depth2 	    = 1.0
		
		cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
		allsel
		vsel,u,volu,,volume1 !unselect volume1
		*get,volume2,volu,0,num,max		!volume2 is select, it gets the volume number
		
		cyl4,xcenter2,ycenter2,raio_int2,angle_int2,raio_ext2,angle_ext2,-depth2
		allsel !select all volumes
		vsel,u,volu,,volume1 !unselect volume1
		vsel,u,volu,,volume2 !unselect volume2
		*get,volume3,volu,0,num,max		! volume3 is select, it gets the volume number

		gplot
		!Subtração dos volumes
		allsel !select all volumes
		vsbv,volume1,volume2 !subtract volume2 from volume1
		vsbv,all,volume3	 !subtract volume3 from all (including the result from the last command) 
		vplot

		/view,1,1,1,1
		vplot
		
		!delete variables
		*set,volume1
		*set,volume2
		*set,volume3
		
		!-------------------------------------- until here, no changes compare to the other geometry codes
		allsel	
		*get,volume1,volu,0,num,max !it gets the current volume number (there's only one)
		
		!------ model a 13.5 mm depth block
		
		!let's name the block by 'B'
		
		Bx1 = 0 
		Bx2 = 60
		By1 = 0
		By2 = 60
		Bz1 = 1.5
		Bz2 = 14
		block,Bx1,Bx2,By1,By2,-Bz1,-Bz2
		
		allsel
		vsel,u,volu,,volume1 !unselect volume1
		*get,volume2,volu,0,num,max		!it gets the block B volume number	

		!------
		
		!CRIAR 2 BLOCOS E SUBTRAIR	
		block,x1-1,x2+1,y1-1,y2/2,z1+1,-Bz2-1     
		allsel !select all volumes
		vsel,u,volu,,volume1 !unselect volume1
		vsel,u,volu,,volume2 !unselect volume2
		*get,volume3,volu,0,num,max		!it gets the first block volume number	

		block,x2/2,x2+1,(y2/2)-1,y2+1,z1+1,-Bz2-1 
		allsel !select all volumes
		vsel,u,volu,,volume1 !unselect volume1
		vsel,u,volu,,volume2 !unselect volume2
		vsel,u,volu,,volume3 !unselect volume3
		*get,volume4,volu,0,num,max		!it gets the second block volume number	

		allsel !select all volumes
		vsel,u,volu,,volume4 !unselect volume4
		
		vsbv,all,volume3 !subtract volume3 from all (volume1 and volume2)
		allsel
		vsbv,all,volume4 !subtract volume4 from all (volume1 and volume2)

		!delete variables
		*set,volume1
		*set,volume2
		*set,volume3
		*set,volume4
				
		!Refinar malha da Região do Furo // [ RING ]
		allsel !select all volumes (there's only one left)
		asel,s,loc,z,z1
		vsla,s,0 !select a specific volume from a specific area, by selection tools
		*get,volume1,volu,0,num,max	 !it gets the volume number	
		allsel
		vsel,u,volu,,volume1 !unselect volume1
		*get,volume2,volu,0,num,max	 

		xcenter1 	= (x2 - diff)/2		
		ycenter1 	= y2/2
		raio_int1 	= 2.0
		raio_ext1   = 2.5
		angle_int1  = 180
		!angle_ext1  = 180
		depth1 	    = 1.5
		
		cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
		allsel !select all volumes 
		
		vsel,u,volu,,volume1	 !unselect volume1
		vsel,u,volu,,volume2     !unselect volume2
		*get,volume3,volu,0,num,max	!it gets the volume number (from the volume left, volume2)
		allsel !select all volumes 
		vsbv,all,volume3,,delete,keep !subtract volume2 from all, the blank space indicates to keep a common area between the volumes
		
		vsel,all
		vglue,all
		
		/pnum,volu,1
		vplot
		
		!allsel !select all volumes
		!asel,s,loc,x,x1
		!vsla,s,0 !select a specific volume from a specific area, by selection tools
		!*get,volume3,volu,0,num,max	!it gets the volume number
		!allsel !select all volumes
		!vsel,u,volu,,volume3 !unselect volume3
		!*get,teste,volu,0,num,max	!it gets the volume number
		
		
		! SEÇÃO GUIA A1(xcenter1)
		allsel
		k,201,xcenter1,y2/2,Z1
		k,202,xcenter1,y2/2,-Z2
		k,203,xcenter1,y2,-Z2
		k,204,xcenter1,y2,Z1
		a,201,202,203,204
		vsel,all
		asel,s,loc,x,xcenter1
		asel,r,loc,y,(3*y2)/4
		asel,r,loc,z,-z2/2
		!Subtrai areas de volume
		*get,n_area,area,0,num,max !it gets the area number
		vsel,all
		vsba,all,n_area,,delete,keep
		!vsba,volume3,n_area,,delete,keep !subtract n_area from volume3
		!vsba,teste,n_area,,delete,keep ! !subtract n_area from teste, the blank space indicates to keep a common area between the geometries
		!vdele,1
		allsel
		vplot
		save
		
		!delete variables
		*set,volume1
		*set,volume2
		*set,volume3
		!*set,teste
		
		! MALHA
		!Seleção do volume
		!Tipo elemento
		et,1,187
		!seleção dos volumes para vmesh
		allsel
		asel,s,loc,z,-Bz2
		vsla,s,0 !select a specific volume from a specific area, by selection tools
		*get,volume1,volu,0,num,max	!it gets the volume number
		
		allsel
		ksel,s,loc,x,x1
		ksel,r,loc,y,y2
		ksel,r,loc,z,z1
		lslk,s,0
		asll,s,0
		vsla,s,0 !select a specific volume from a specific area, by selection tools
		*get,volume2,volu,0,num,max	!it gets the volume number
		
		allsel
		ksel,s,loc,x,x2/2
		ksel,r,loc,y,y2
		ksel,r,loc,z,z1
		lslk,s,0
		asll,s,0
		vsla,s,0 !select a specific volume from a specific area, by selection tools
		*get,volume3,volu,0,num,max !it gets the volume number
		
		allsel
		vsel,u,volu,,volume1
		vsel,u,volu,,volume2
		vsel,u,volu,,volume3
		!Comprimento do elemento padrão 
		size_refined= 0.2
		esize,size_refined
		vmesh,all
		
		!Comprimento do elemento padrão 
		size_coarse2= 0.5
		esize,size_coarse2
		allsel
		vmesh,volume2
		vmesh,volume3
		
		!Comprimento do elemento padrão 
		size_coarse1=3.0
		esize,size_coarse1
		allsel
		vmesh,volume1
		
		
		*set,volume1
		*set,volume2
		*set,volume3
		
		eplot
		
		! NUMERAÇÃO DE NÓS 
		! PRIMEIRA SEÇÃO A1(xcenter1)
		!Alterando a sequência (numeracao) dos nós ao longo da seção de interesse
		asel,s,loc,x,xcenter1
		nsla,s,1
		*get,maior_numero_de_nos,node,,num,max 
		numstr,node,maior_numero_de_nos !Estabelece números iniciais para itens numerados automaticamente.
		*set, maior_numero_de_nos,
		ksel,none 				!seleciona keypoints - none - deseleciona o conjunto completo
		knode,0,all 			!Define keypoints em um local de nó existente.
		nkpt,0,all  			!Define nós em local de keypoint existente.
		kdel,all    			!Deleta 'unmeshed' keypoints.
		nummrg,node,,,,high
		! PRIMEIRA SEÇÃO A2(x2/2)
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
		! PRIMEIRA SEÇÃO A3(y2/2)
		!Alterando a sequência (numeracao) dos nós ao longo da seção de interesse
		asel,s,loc,y,y2/2
		nsla,s,1
		asel,s,loc,x,xcenter1
		nsla,u,1
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
		
		! CARREGAMENTO |1| => F = Fx (Horizontal X) 
		!allsel
		!asel,s,loc,x,x2
		!sfa,all,1,pres,-p
		!asel,s,loc,x,x1
		!sfa,all,1,pres,-p
		!allsel
		!lswrite,1
		! SOLUÇÃO |1|
		!finish
		!/solu
		!lssolve,1
		!save

		! CARREGAMENTO |2| => F = Fy (Vertical Y) 
		allsel
		asel,s,loc,y,y2
		sfa,all,1,pres,-p
		asel,s,loc,y,y1
		sfa,all,1,pres,-p
		allsel
		lswrite,1
		
		
		! SOLUÇÃO |2|
		finish
		/solu
		lssolve,1
		save
		
		! VISUALIZANDO RESULTADOS NA TELA
		/post1
		plnsol,s,eqv,0,0.5
		pldisp,1
		pldisp,2
		!/dscale,1,1
		
		!PARTE PROBLEMÁTICA
		
			! PRIMEIRA SEÇÃO A1(xcenter1)
			! OBTENÇÃO DE DADOS (nós)
			asel,s,loc,x,xcenter1
			nsla,s,1
			*get,numero_de_nos,node,,count
			*get,menor_numero_de_nos,node,,num,min
			!set,1
			set,1 !(tem relação com file.s01)
			save
			colunas_matriz = 10
			*dim,dados_dos_nos_A1,array,numero_de_nos,colunas_matriz
			*get,menor_numero_de_nos,node,,num,min
			
			/cwd,wd(1,1) !voltar para a pasta principal para encontrar dados_forma_matriz_A?.txt
			
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

			/cwd,%wd(1,1)%\difference%diff%mm !volta para a pasta do loop
			
			! SEGUNDA SEÇÃO A2(x2/2)
			! OBTENÇÃO DE DADOS (nós)
			asel,s,loc,x,x2/2
			nsla,s,1
			*get,numero_de_nos,node,,count
			*get,menor_numero_de_nos,node,,num,min
			!set,1
			set,1 !(tem relação com file.s01)
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
			
			/cwd,%wd(1,1)%\difference%diff%mm

			! TERCEIRA SEÇÃO A3(y2/2)
			asel,s,loc,y,y2/2
			nsla,s,1
			asel,s,loc,x,xcenter1
			nsla,u,1
			asel,s,loc,x,x2/2
			nsla,u,1
			*get,numero_de_nos,node,,count
			*get,menor_numero_de_nos,node,,num,min
			!set,1
			set,1 !(tem relação com file.s01)
			save
			colunas_matriz = 10
			*dim,dados_dos_nos_A3,array,numero_de_nos,colunas_matriz
			*get,menor_numero_de_nos,node,,num,min
			
			/cwd,wd(1,1)
			
			/input,dados_forma_matriz_A3,txt !(cria arquivo dados_dos_nos_A3.txt)
			! ARMAZENAMENTO DE DADOS
			*vget,dados_dos_nos_A3(1,1),node,menor_numero_de_nos,loc,x
			*vget,dados_dos_nos_A3(1,2),node,menor_numero_de_nos,loc,y
			*vget,dados_dos_nos_A3(1,3),node,menor_numero_de_nos,loc,z
			*vget,dados_dos_nos_A3(1,4),node,menor_numero_de_nos,u,x
			*vget,dados_dos_nos_A3(1,5),node,menor_numero_de_nos,u,y
			*vget,dados_dos_nos_A3(1,6),node,menor_numero_de_nos,u,z
			*vget,dados_dos_nos_A3(1,7),node,menor_numero_de_nos,s,x
			*vget,dados_dos_nos_A3(1,8),node,menor_numero_de_nos,s,y
			*vget,dados_dos_nos_A3(1,9),node,menor_numero_de_nos,s,z
			*vget,dados_dos_nos_A3(1,10),node,menor_numero_de_nos,s,eqv

			
			/input,dados_forma_matriz_A3,txt
		
			/cwd,%wd(1,1)%\difference%diff%mm
		
			*set,dados_dos_nos_A1,,nopr
			*set,dados_dos_nos_A2,,nopr
			*set,dados_dos_nos_A3,,nopr
		
	!FIM DO BLOCO DE COMANDOS 
	
*enddo

!!!Observacoess: os comandos parsav e parres servem para salvar  os parametros e limpar a interface gráfica
