!center_hole_2d (08/06/2018) sigma Y + sigma X

finish
/cle
/title, center_hole_2d
!save
/prep7

!precision
seltol,0.000001

!Geometry Parameters
!Plate
x1 = 0 
x2 = 150
y1 = 0
y2 = 150
!Hole
r=2
d=4

!Residual Stress(MPa)
p=1

!Properties Material
mp,ex,1,2e5
mp,prxy,1,0.3

!Save procedures
*dim,wd,string,200,1
wd(1,1)='C:\Manasses\center_hole_2d\uniaxial'
/cwd,wd(1,1)
/mkdir,%x2%mmx%y2%mm
/cwd,%wd(1,1)%\%x2%mmx%y2%mm
/Title,%x2%mmx%y2%mm
finish
/filname,%x2%mmx%y2%mm
/prep7

!Creating Geometry
rectng,x1,x2,y1,y2

allsel
*get,area1,area,0,num,max

xcenter1 	= (x2)/2		
ycenter1 	= y2/2
raio_int1 	= r
raio_ext1	= 0.0
angle_int1  = 360
angle_ext1  = 0.0
depth1 	    = 0.0

cyl4,xcenter1,ycenter1,raio_int1,angle_int1,raio_ext1,angle_ext1,depth1
allsel

asel,u,area,,area1
*get,area2,area,0,num,max	

!areas Subtraction
allsel
asba,all,area2
aplot
*get,area3,area,0,num,max

!creating a line to subtract from the area to obtain the nodes
k,100,x1,ycenter1
k,101,x2,ycenter1
l,100,101
allsel
lsel,s,loc,y,ycenter1
lsel,r,loc,x,x2/2

*get,line1,line,0,num,max	
allsel

asbl,area3,line1
allsel
aplot
/pnum,area,1
aplot

!meshing
asel,all
et,1,182
esize,0.5
amesh,all

!boundery conditions
allsel
aplot

!first kp
ksel,s,loc,x,x1
ksel,r,loc,y,y2/2
nslk,s
d,all,uy,0
d,all,ux,0

!second kp 'engaste'
ksel,s,loc,x,x2
ksel,r,loc,y,y2/2
nslk,s
d,all,uy,0
!d,all,ux,0

!loading

!loading sigma Y
allsel
lsel,s,loc,y,y2
sfl,all,pres,-p
lsel,s,loc,y,y1
sfl,all,pres,-p
allsel
!lswrite,1

!loading sigma X	
allsel
lsel,s,loc,x,x2
sfl,all,pres,-p
lsel,s,loc,x,x1
sfl,all,pres,-p
allsel
!lswrite,2

*set,area1
*set,area2
*set,area3
*set,line1

! solution
allsel
finish
/solu
allsel
solve
!lssolve,1
save
allsel
!set
/post1
plnsol,sy

!node selection data
!allsel
!lsel,s,loc,y,ycenter1
!lsel,r,loc,x,x2/2
!nsll,s

seltol,0.000001

nsel,s,loc,x,xcenter1+r
nsel,r,loc,y,y2/2
*get,node1,node,0,num,max

!/pnum,node,1
!nplot
*get,node_sy_data,node,node1,s,y
ans=node_sy_data


