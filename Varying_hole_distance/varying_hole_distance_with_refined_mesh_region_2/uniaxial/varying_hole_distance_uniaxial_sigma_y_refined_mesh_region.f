! VARYING HOLE DISTANCE (07/12/2017) SIGMA Y

!*enddo
                !Document header
                finish
                /cle,,nopr
                /Title, varying_hole_distance
				save
                /prep7
				seltol,0.00001
				
				!Defining the curent working directory
				*dim,wd,string,200,1
				wd(1,1)='C:\Manasses\varying_hole_distance_with_refined_mesh_region_2\uniaxial'
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
				
				!Angulo de Ponta(°)
				!PONTA=0
				!Ângulo de PONTA LIMITE, onde rreal = r 
				!PONTA_LIMITE = 180-2*((180/3.1415926535897932384626433832795)*atan(prof/r))	! 126,86 - > 129 para rodar as simulações
				!PONTA_LIMITE = 129
				
				!Distance from the border to the first hole center 
				diff = 6 !mínimo 6.0 mm
				inicial = 17
				final = 20
				incr = 0.5
!Estrutura de repetição:						
*do,diff,inicial,final,incr
	
	!Save parameters to clear the graphics interface
	finish
	/cwd,wd(1,1)
	
	parsav,all,parameters,txt,wd(1,1)
	/mkdir,difference%diff%mm !Creates the new folder for the current iteration
	finish
	/clear,,nopr
	/prep7 
					
	parres,new,parameters,txt,'C:\Manasses\varying_hole_distance_with_refined_mesh_region_2\uniaxial'
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
		allsel
		*get,volume1,volu,0,num,max

		!Dimensões parametrizadas dos furos
		xcenter1 	= (x2 - diff)/2		
		ycenter1 	= y2/2
		raio_int1 	= 2.0
		raio_ext1	= 0.0
		angle_int1  = 360
		depth1 	    = 1.5
		
		xcenter2 	= x2 - xcenter1	! Symmetry
		ycenter2 	= y2/2
		raio_int2 	= 2.0
		raio_ext2	= 0.0
		angle_int2  = 360
		depth2 	    = 1.5
		
		cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
		allsel
		vsel,u,volu,,volume1
		*get,volume2,volu,0,num,max		
		
		cyl4,xcenter2,ycenter2,raio_int2,angle_int2,raio_ext2,angle_ext2,-depth2
		allsel
		vsel,u,volu,,volume1
		vsel,u,volu,,volume2
		*get,volume3,volu,0,num,max		

		gplot
		!Subtração dos volumes
		allsel
		vsbv,volume1,volume2
		vsbv,all,volume3
		vplot

		/view,1,1,1,1
		vplot
				
		!CRIAR 2 BLOCOS E SUBTRAIR
		allsel
		*get,volume4,volu,0,num,max		
		block,x1-1,x2+1,y1-1,y2/2,z1+1,-Z2-1     !-> gera 5
		allsel
		vsel,u,volu,,volume4
		*get,volume5,volu,0,num,max		
		block,x2/2,x2+1,(y2/2)-1,y2+1,z1+1,-Z2-1 !-> gera 6
		allsel
		vsel,u,volu,,volume4
		vsel,u,volu,,volume5
		*get,volume6,volu,0,num,max		

		allsel
		
		vsbv,volume4,volume5 !-> gera 7
		
		allsel
		vsel,u,volu,,volume6
		*get,teste,volu,0,num,max		
		allsel
		
		vsbv,teste,volume6 
		vplot
		
		!Refinar malha da Região do Furo
		allsel
		*get,volume7,volu,0,num,max		

		xcenter1 	= (x2 - diff)/2		
		ycenter1 	= y2/2
		raio_int1 	= 2.0
		raio_ext1   = 3.0
		angle_int1  = 180
		!angle_ext1  = 180
		depth1 	    = 1.5
		
		cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
		allsel
		
		
		
		vsel,u,volu,,volume7	
		*get,volume8,volu,0,num,max	
		allsel
		vsbv,all,volume8,,delete,keep
		
		/pnum,volu,1
		vplot
		
		allsel
		asel,s,loc,x,x1
		vsla,s,0
		*get,volume9,volu,0,num,max	
		allsel
		vsel,u,volu,,volume9
		*get,volume10,volu,0,num,max	
		
		
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
		*get,n_area,area,0,num,max
		vsba,volume9,n_area,,delete,keep 
		vsba,volume10,n_area,,delete,keep ! ATENÇÃO - ESTÃO SELECIONADOS 3 VOLUMES -> VMESH,2 E VMESH,3 e VDELE,1 deve resolver
! ATENÇÃO - ESTÃO SELECIONADOS 3 VOLUMES -> VMESH,2 E VMESH,3 e VDELE,1 deve resolver
		!vdele,1
		allsel
		vplot
		save
		
		! MALHA
		!Seleção do volume
		!Tipo elemento
		et,1,187
		!seleção dos volumes para vmesh
		allsel
		asel,s,loc,x,x1
		vsla,s,0
		*get,volume11,volu,0,num,max	
		allsel
		asel,s,loc,x,x2/2
		vsla,s,0
		*get,volume12,volu,0,num,max
		
		!Comprimento do elemento padrão 
		size_not_refined= 0.25
		esize,size_not_refined
		allsel
		vmesh,volume11
		vmesh,volume12
		
		
		allsel
		vsel,u,volu,,volume11
		vsel,u,volu,,volume12
		!Comprimento do elemento padrão 
		size_refined= 0.2
		esize,size_refined
		vmesh,all
		
		
		!Comprimento do elemento padrão 

		!size= 1
		!esize,size
		!command
		!vmesh,all
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
		asel,s,loc,x,x2/4
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
		
		
		
		*set,volume1
		*set,volume2
		*set,volume3
		*set,volume4
		*set,volume5
		*set,volume6
		*set,volume7
		*set,volume8
		*set,volume9
		*set,volume10

		
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
