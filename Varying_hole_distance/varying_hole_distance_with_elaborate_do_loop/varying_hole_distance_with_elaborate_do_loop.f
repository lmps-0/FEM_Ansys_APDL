! VARYING HOLE DISTANCE WITH ELABORATE LOOP(07/12/2017)

*enddo
                !Document header
                finish
                /cle,,nopr
                /Title, varying_hole_distance_with_elaborate_do_loop
				save
                /prep7
				seltol,0.00001
				
				!Defining the curent working directory
				*dim,wd,string,200,1
				wd(1,1)='C:\Users\TTR01\Desktop\Manasses\varying_hole_distance_with_elaborate_do_loop'
                /cwd,wd(1,1) !it must be a comment when running on optimization mode!!!!!!!!!!!!!!!!!
								
				
				!Módulo de Elasticidade(MPa)
				MP,EX,1,2E5
				!Coeficiente de Poisson
				MP,PRXY,1,0.3
				!Profundidade Nominal do Furo(mm)
				PROF=1.0 
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
				diff = 4.5 !mínimo 4.1 mm
				
				!Values for the loop simulation
				incr1 = 0.1 	!incremento refinado
				incr2 = 0.5   	!incremento grosseiro
				ini_val = 4.5	!valor inicial da diferença entre os furos (mínimo 4.1) respeitando a geometria atual
				fin_val = 10	!valor final da diferença entre os furos 
				ini_interv = 5	!inicio do intervalo com incremento grosseiro
				fin_interv = 9.5	!final do intervalo com incremento grosseiro
						
				!Constants for the loop control (do not change!)
				acum = 0
				temp = 0
				cont = 0
				R 	 = incr2/incr1
				
!Estrutura de repetição:						
*do,acum,ini_val,fin_val,incr1
	
	diff = acum
	
	*if,diff,gt,ini_interv,and,diff,lt,fin_interv,then
		cont = cont + 1
		*if,cont,ne,R,then
			diff = diff - (cont*incr1)
		*else
			cont=0
		*endif
		
		!diff = nint(diff)!função de arredondamento -> tentar com anint(diff) real -> em -> real
	*endif
	
	*if,temp,eq,diff,cycle
		!Save parameters to clear the graphics interface
		finish
		/cwd,wd(1,1)
		
		parsav,all,parameters,txt,wd(1,1)
		/mkdir,difference%diff%mm !Creates the new folder for the current iteration
		finish
		/clear,,nopr
		/prep7 
						
		parres,new,parameters,txt,'C:\Users\TTR01\Desktop\Manasses\varying_hole_distance_with_elaborate_do_loop'
		/cwd,%wd(1,1)%\difference%diff%mm !salvando nas diferentes pastas
		/Title,difference%diff%mm  !variando distance
		finish
		/filname,difference%diff%mm !variando distance
		/prep7
		
		!INÍCIO DO BLOCO DE COMANDO DENTRO DO LOOP
					
			!Módulo de Elasticidade(MPa)
			MP,EX,1,2E5
			!Coeficiente de Poisson
			MP,PRXY,1,0.3
			
			! GEOMETRIA
			!Dimensões parametrizadas do paralelepípedo
			x1 = 0 
			x2 = 20
			y1 = 0
			y2 = 20
			z1 = 0
			z2 = 1.5
			block,x1,x2,y1,y2,-z1,-z2
			!Dimensões parametrizadas dos furos
			xcenter1 	= (x2 - diff)/2		
			ycenter1 	= y2/2
			raio_int1 	= 2.0
			angle_int1  = 360
			depth1 	    = 1
			
			xcenter2 	= x2 - xcenter1	! Symmetry
			ycenter2 	= y2/2
			raio_int2 	= 2.0
			angle_int2  = 360
			depth2 	    = 1
			
			cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,-depth1
			cyl4,xcenter2,ycenter2,raio_int2,angle_int2,raio_ext2,angle_ext2,-depth2
			gplot
			!Subtração dos volumes
			vsbv,1,2
			vsbv,4,3
			vplot

			/view,1,1,1,1
			vplot
					
			!CRIAR 2 BLOCOS E SUBTRAIR

			block,x1-1,x2+1,y1-1,y2/2,z1+1,-Z2-1     !-> gera 2
			block,x2/2,x2+1,(y2/2)-1,y2+1,z1+1,-Z2-1 !-> gera 3

			vsbv,1,2 !-> gera 4
			vsbv,4,3 
			vplot

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
			vsba,all,all,delete,keep ! ATENÇÃO - ESTÃO SELECIONADOS 3 VOLUMES -> VMESH,2 E VMESH,3 e VDELE,1 deve resolver
			vdele,1
			allsel
			vplot
			save
			
			! MALHA
			!Seleção do volume
			!Tipo elemento
			et,1,187
			!Comprimento do elemento padrão 
			size= 0.5
			esize,size
			!command
			vmesh,all
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
			allsel
			asel,s,loc,x,x2
			sfa,all,1,pres,-p
			asel,s,loc,x,x1
			sfa,all,1,pres,-p
			allsel
			lswrite,1
			! SOLUÇÃO |1|
			!finish
			!/solu
			!lssolve,1
			!save

			! CARREGAMENTO |2| => F = Fx + Fy (Vertical Y) 
			allsel
			asel,s,loc,y,y2
			sfa,all,1,pres,-p
			asel,s,loc,y,y1
			sfa,all,1,pres,-p
			allsel
			lswrite,2
			
			! SOLUÇÃO |1,2|
			finish
			/solu
			lssolve,1,2
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
				set,1
				set,2 !(tem relação com file.s01)
				save
				colunas_matriz = 9
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
				/input,dados_forma_matriz_A1,txt

				/cwd,%wd(1,1)%\difference%diff%mm !volta para a pasta do loop
				
				! SEGUNDA SEÇÃO A2(x2/2)
				! OBTENÇÃO DE DADOS (nós)
				asel,s,loc,x,x2/2
				nsla,s,1
				*get,numero_de_nos,node,,count
				*get,menor_numero_de_nos,node,,num,min
				set,1
				set,2 !(tem relação com file.s01)
				save
				colunas_matriz = 9
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
				set,1
				set,2 !(tem relação com file.s01)
				save
				colunas_matriz = 9
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
				/input,dados_forma_matriz_A3,txt
			
				/cwd,%wd(1,1)%\difference%diff%mm
			
				*set,dados_dos_nos_A1,,nopr
				*set,dados_dos_nos_A2,,nopr
				*set,dados_dos_nos_A3,,nopr
		
		!FIM DO BLOCO DE COMANDOS 

	temp =diff
		
*enddo

!!!Observacoess: os comandos parsav e parres servem para salvar  os parametros e limpar a interface gráfica
