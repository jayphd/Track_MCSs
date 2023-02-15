% This function finds the identifies the connected pixels, labels them.
% Then stores the pixels locations in 3D array with each CS in one plane. 
% It also calculates the area of CS and locates their centers

function [cent, mccarea,smallarea, nob, I,mccloc,ecc] = findconn(A,B,Lt,Lg)

cd('D:\Matlab_Scripts\INSAT3D\Track_MCSs\supplementary')

[m,n] = size(A);
CC = bwconncomp(A);
labeled = labelmatrix(CC);    % get the CS labeled matrix from IR matrix 
garea = load('pxarea.mat');
garea = garea.area_globe;     % Area of earth's surface
nob = CC.NumObjects;                                                             
cent = zeros(nob,2);          % Centroids
ecc = zeros(nob,1);           % Eccentricity
mccarea = zeros(nob,1);       % Area 
smallarea = zeros(nob,1);     % <= 221K
mccloc = zeros(m,n,nob);      % CS locations 3D array. A CS on each plane

% L = bwlabel(CC);

 for k =1:1:nob
     ar = 0;
     
%%%%%%%%%%%%% Get the location of kth CS on kth plane of mccloc %%%%%%%%%%%
 for j =1:n
     for i = 1:m
         
         if labeled(i,j) == k
             mccloc(i,j,k) = 1;
         else
             mccloc(i,j,k) = 0;
         end
         
         
     end
 end
 
%%%%%%%%%%%%%%%%%% Calculate area of kth CS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for j =1:n
        for i = 1:m
            
            if labeled(i,j) == k
               ar = ar + garea(i,j);
            end
            
        end
    end
    
    mccarea(k) = ar;
    
%%%%%%%%%%%%%%%%%% Calculate core area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ar = 0;
    
    for j =1:n
        for i = 1:m
            
            if B(i,j) <= 208 % specify core temperature
                
                if labeled(i,j) == k
                    ar = ar + garea(i,j);
                end
                
            end
            
        end
    end
%     
%%
   smallarea(k) = ar; 
    

end 

 I = im2bw(A); % B and W image
 
%%%%%%%%%%%%%%%%%%%%%%% Get the center of kth CS %%%%%%%%%%%%%%%%%%%%%%%%% 
 
 stats = regionprops(I,'centroid');
 
 for k = 1 : length(stats) 
    cen  = stats(k).Centroid; 
    cent(k,1) = round(10*Lt(round(cen(2)),round(cen(1))))/10;
    cent(k,2) = round(10*Lg(round(cen(2)),round(cen(1))))/10;
        
 end
 clear A;
cd('D:\Matlab_Scripts\INSAT3D\Track_MCSs')

 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%