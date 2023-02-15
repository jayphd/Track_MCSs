% The fuction filters out small CS than the defined limit. 
% The input is binary matrix associated with the actual data (IR) matrix.
% 

function [biir] = filterarea(biir, arc)

[m,n] = size(biir);

CC = bwconncomp(biir);          % finds the connected objects
nob = CC.NumObjects;            
labelp = labelmatrix(CC);       % labels the connected objects with integer nos

calarea = zeros(nob,1);         % Array for storing area of pixels of objects

cd('D:\Matlab_Scripts\INSAT3D\Track_MCSs\supplementary')
garea = load('pxarea.mat');     % Area matrix: Area of globe for defined lat-lon 
garea = garea.area_globe;


%%%%%%%%%%%%%%%%%%%% Calculate area of connected Objects %%%%%%%%%%%%%%%%%%
for k =1:nob
    for j =1:n
        for i = 1:m
            
            if labelp(i,j) == k
                calarea(k,1) = calarea(k,1) + garea(i,j);
            end
            
        end
    end
end

%%%%%%%%%%%%%%%%%%% Filter out smaller objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k =1:nob
    
    if calarea(k,1) < arc %% Area < XXXX km2
        
        for j =1:n
            for i = 1:m
                
                if labelp(i,j) == k
                    biir(i,j) = 0;
                end
                
            end
        end
    end
end
cd('D:\Matlab_Scripts\INSAT3D\Track_MCSs')


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


