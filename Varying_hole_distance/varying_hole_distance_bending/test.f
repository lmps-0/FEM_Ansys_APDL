fini
/clear
/prep7

!Módulo de Elasticidade(MPa)
		MP,EX,1,2E5
		!Coeficiente de Poisson
		MP,PRXY,1,0.3
		
		ET,1,187
		
		! GEOMETRIA
		!Dimensões parametrizadas do paralelepípedo
		x1 = 0 
		x2 = 30
		y1 = 0
		y2 = 30
		z1 = 0
		z2 = 1.5
		block,x1,x2,y1,y2,-z1,-z2
		allsel !volume1 is select
		
		esize,0.5
		vmesh,all
		
		
		! CONDIÇÕES DE SIMETRIA
		!(seção ao longo do eixo X)
		asel,s,loc,x,x2
		nsla,s,1
		dsym,symm,x,0
		!(seção ao longo do eixo Y)
		asel,s,loc,y,y1
		nsla,s,1
		dsym,symm,y,0
		
		
		! CONDIÇÕES DE CONTORNO
		allsel
		vplot

		ksel,s,loc,x,x1
		ksel,r,loc,y,y1
		ksel,r,loc,z,z1
		nslk,s
		d,all,uz,0
		
		! BENDING
		! aplicar condicoes de contorno nos nodes da linha: x=0, z=0
		allsel
		lsel,s,loc,x,x1
		lsel,r,loc,z,z1
		nsll,s
		d,all,ux,-0.03
		
		allsel
		lsel,s,loc,x,x1
		lsel,r,loc,z,-z2
		nsll,s
		d,all,ux,0.03
		
		allsel
		/solu
		solve
		
		/post1
		/view,1,1,1,1