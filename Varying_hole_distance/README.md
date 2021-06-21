# Residual Stress Analysis

The analysis of residual stresses has fundamental importance for understanding the damage introduced to components as a result of manufacturing processes, as well as enabling the identification of the state in service of pipelines used by the oil and gas industry.

Residual stresses are usually undesirable because they can cause premature failure of manufactured parts. For this reason, the development of efficient methods to measure them is relevant.
One of the most widely used methods for measuring residual stresses is called the Hole-Drilling Method, which is based on the observation of the deformations the surroundings of a hole produced in a piece. The machining of this hole must be done with a good control of the process, since it is one of the sources of uncertainty in the calculation of residual stresses. This technique requires a hole with high precision and the stress levels introduced by machining should be minimized, since changes in the strain field by the production of the hole can mask measurement results.

In addition to the accuracy required in the machining of the hole, the distance between the holes also has an influence on the stress results. This influence can be evaluated numerically by means of Finite Element Analysis (FEA).

# The Finite Element Analysis

The finite element method (FEM) or Finite Element Analysis (FEA) is a numerical method widely used in many fields of study to find approximate solutions to real problems by solving (partial) differential equations. 

In a generic way, the method consists of partitioning the domain of the unknown function, associating shape functions to the partitions, which by combining them with the unknowns of the physical problem constitute an approximate solution of the desired physical quantity. FEM was first developed to solve problems related to structural analysis and then gained space in other research fields. 
It is commonly used to solve problems that do not have a direct analytical solution. 

A finite element analysis (FEA) can be subdivided into four main steps:
1. The discretization  of the continuum by dividing the domain into subdomains or finite elements, which requires the definition of the element shape, 
number of nodes and the interpolation function (shape function).
2. The determination of the element equations that describe the relationship between the relationship between the primary unknowns, such as the displacement, and the secondary 
secondary unknowns, such as stress and strain.
3. Combining the element equations into a global matrix, taking into account the boundary and loading conditions.
4. The solution of the system of equations to obtain the results of the numerical simulation results.


# Varying Hole Distance

The project aimed to expand the knowledge of the Blind Hole Method 
(MFC), by numerical analysis of the influence of the distance between holes on 
on the stresses identified at the hole border. Numerical 
numerical simulations were performed in order to predict variations in the stresses around 
the hole as a function of the distance between the holes. The influence of the distance 
was evaluated with the aid of Ansys Mechanical APDL® and Matlab® software. 
For this, it was developed a parameterized numerical model in 
APDL language in order to enable the variation of the geometry and verify the 
influence.
To make the analysis more robust and, at the same time, to enable 
comparison with models already developed, the following geometries were 
case with through hole, thin case with blind hole, and thick case with blind hole. 
case with blind hole. In this way, the results obtained for the through hole 
through hole case could be compared with data found in the literature for 
the distance between holes in thin slabs. On the other hand, the values presented for the 
thick case, a condition widely used by CBM researchers, 
could be obtained and compared with the results obtained for the case of through hole in thin plate. 
through hole in thin plate.
The theme of the project is related to the continuity of research activities 
activities in the area of Modeling and Simulation developed at LMP/UFSC and 
at Labmetro/UFSC. The activities developed from the partnership between 
these laboratories are focused on the optimization of the residual stress measurement equipment 
residual stresses and the measurement process.
