% The following code cpy files inside folders to another folder
clear all
close all
path1=['C:\Manasses'];%address -> THIS CAN CHANGE
path_destination=['C:\Users\TTR01\Desktop']; %-> THIS CAN CHANGE
cd(path_destination)
mkdir Manasses
path_destination=['C:\Users\TTR01\Desktop\Manasses']; %Update path destination
cd(path1); %enters in the C:\Manasses folder

%this block colect the folder names in the C:\Manasses folder
clear folder_name
folder_name{1}='0';
vector=dir; %vector is a struct array
vetor=struct2cell(vector); %vetor is matrix, 30 colunms and 5 rows
[t1 n1]=size(vetor);
temp=0;
for cont=1:1:n1
    if vetor{4,cont}==1
        temp = temp + 1;
        %temp=strcat(temp)
        folder_name{temp}=vetor{1,cont};% folder_name has the names of the inside folders of C:\Manasses
    end
end
%folder_name has the names of the inside folders of C:\Manasses

%THE MAIN BLOCK, includ all folder in the C:\Manasses folder
cont=0;
[t2 n2]=size(folder_name); %size of the folder_name vector
%for test only, 18 -> 'varying_hole_distance_with_refined_mesh_region_2'
for cont=3:1:n2 %always start cont=2 because the first folder is windows, cont=2:1:n2
   path2=strcat(path1,'\',folder_name(1,cont));
   path2=path2{1};
   
   cd(path_destination) 
   foldername1 = folder_name(1,cont);
   foldername1=foldername1{1};
   mkdir(foldername1)
   path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1]; %Update path destination
   
   cd(path2)%enter the subfolder, for test only, cont=18 -> 'varying_hole_distance_with_refined_mesh_region_2'
   vector2=dir
   vetor2=struct2cell(vector2); %vetor2 is matrix, 9 colunms and 1 rows
   [t3 n3]=size(vetor2);
   temp=0;
   
   %this block colect the folder names in the subfolder 
   clear folder_name_2
   folder_name_2{1}='0';
   for cont2=3:1:n3 %always start cont2=3 because the first 2 folder is windows
       if vetor2{4,cont2}==1
           temp = temp + 1;
           folder_name_2{temp}=vetor2{1,cont2};
       end
   end
   %if temp==1
   %    folder_name_2{2}=0;
       %[ai aj]=size(folder_name_2);
       %folder_name_2(10:1:aj)=0
   %end
   %folder_name_2 %vector with the folders names, inside one of the folders inside C:\Manasses
   
   [t4 n4]=size(folder_name_2);
   
   %this block select 'uniaxial' and 'biaxial' folder
   for cont3=1:1:n4 %select the 'uniaxial' and 'biaxial' folder
       a=folder_name_2{1,cont3};
       u='uniaxial';
       b='biaxial';
       logical_teste1 = strcmp(a,u); %comparison of strings
       logical_teste2 = strcmp(a,b);
       
       if logical_teste1==1|logical_teste2==1
           path3=[path2,'\',folder_name_2{1,cont3}];
           
           cd(path_destination) 
           foldername2 = folder_name_2(1,cont3);
           foldername2=foldername2{1};
           mkdir(foldername2)
           %path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1,'\',foldername2] %Update path destination
           path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1,'\',foldername2]; %Update path destination

           cd(path3)
           
           %selectin all subfolders 
           vector3=dir
           vetor3=struct2cell(vector3); %vetor3 is matrix, 37 colunms and 1 rows
           [t5 n5]=size(vetor3);
           temp=0;
           
           %
           %this block colect the folder names in the subfolder 
           clear folder_name_3
           folder_name_3{1}='0';
           for cont3=3:1:n5 %always start cont2=3 because the first 2 folder is windows
               if vetor3{4,cont3}==1
                   temp = temp + 1;
                   folder_name_3{temp}=vetor3{1,cont3};
               end
           end
           folder_name_3 %vector with the folders names, inside one of the folders inside C:\Manasses
           %
         
           [t6 n6]=size(folder_name_3);
           %this block ENTERS the folders in the folder_name_3 names
           for cont4=1:1:n6 % n6, for teste only, cont4=1
              path4=[path3,'\',folder_name_3{1,cont4}];
              
              cd(path_destination) 
              foldername3 = folder_name_3(1,cont4);
              foldername3=foldername3{1};
              mkdir(foldername3)
              %path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1,'\',foldername2] %Update path destination
              path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1,'\',foldername2,'\',foldername3] %Update path destination
              
              cd(path4)
       
              filepah=path_destination;
              filename='*.txt';
              copyfile(filename,filepah)
              %now we have to copy txt files
              %back one level of folder
              path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1,'\',foldername2]; %Update path destination 
           end
           %back one level of folder
           path_destination=['C:\Users\TTR01\Desktop\Manasses\',foldername1]; %Update path destination   
       else
           continue
       end
   end
   
   %back one level of folder
   path_destination=['C:\Users\TTR01\Desktop\Manasses']; %Update path destination
       
   %now we need enter the folder with the names 'uniaxial' and 'biaxial'
   %after, we need select all folder inside 'uniaxial' and 'biaxial' and enter in them
   %and then, in wich one select only txt files, copy them and paste
   %somewhere
      
end
%filepath = getdir('.C:\Manasses');
%[~,name_folder] = fileparts(filepath)
%path2=['C:\Manasses\',name_folder]
%cd(path2)
%dinfo = dir(name_folder)
%names_cell = {dinfo.name}
%strcat('YourDirectory', '/', names_cell)
%listing=dir
%name='varying_hole_distance_with_refined_mesh_region_2';
%listing = dir(name)