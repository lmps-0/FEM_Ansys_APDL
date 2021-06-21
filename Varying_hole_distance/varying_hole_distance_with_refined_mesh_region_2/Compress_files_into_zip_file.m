% The following code compress files into zipfiles
clear all
close all
%mkdir plots
axial={'uniaxial','biaxial'};
[m t] = size(axial);
t=1; %por enquanto, lembrar de tirar -> t=2
n=0;
for cont=1:1:t
   
    diff=[6.0:2:20]; %Point differences to be read
    [m n] = size(diff);

    for a=1:1:n %going through each point difference
        %the folder adress in the variable path
        path=['C:\Manasses\varying_hole_distance_with_refined_mesh_region_2\',axial{cont},'\difference',num2str(diff(a)),'mm'];%address
        %cd command change the corrent directory
        cd(path)
        %concatenate the new zip file name
        zipfilename=strcat('difference0',num2str(diff(a)),'mm');
        %concatenate the file name and the extension
        filenames=strcat('difference',num2str(diff(a)),'mm.*');
        %compress the file in the current path
        zip(zipfilename,filenames);
        
        delete(filenames);
        %unzip(zipfilename);

        %uigetfile('*.m', 'Select Multiple Files', 'MultiSelect', 'on' )
        %name = strcat('difference',num2str(diff(a)),'mm')
        %listing = dir(name)   
    end
end

