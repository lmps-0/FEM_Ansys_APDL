# Ansys Mechanical APDL

Numerical Simulations via Finite Elements of the Hole Drilling Method for Measuring Residual Stress.

Ansys APDL or Ansys Parametric Design Language is the primary language used to commute with the Mechanical APDL solver. APDL can be used to automate tasks or to create a complete parametric model. 

Ansys APDL is considered as an old-fashioned command-driven program that permits the user to input line by line codes and execute them on request. The advantage and what justified the choice of this tool to model and run the numerical simulations is in the level of control over the model. The possibility of writing optimized scripts allows for quick changes in geometry. It also allows more precise control of model mesh parameters. Such a tool is commonly used by many researchers in the field of the hole-drilling method simulations.


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

There are different types of elements with 1,2 or 3 dimensions, and the user is usually free to choose them according to his or her needs. 

In initial simulations, the element size should be larger to avoid unnecessary  expenditure of time and computational resources. However, the element size significantly affects the accuracy of the simulation results and consequently, more refined meshes lead to better results. To speed up the solution, it is common to implement different mesh densities according to the local stress and displacement gradients. The influence of the element size can be identified with a mesh refinement study, keeping the other parameters constant.

