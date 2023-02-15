
% This function calculates the area of globe for the mentioned lat-lon mesh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;

cd('/user1/jayesh/SATELLITE DATA/KALPANA/Grid/IR_8/India/Jun')
LaGrid = load('Latitude.mat');
LoGrid = load('Longitude.mat');
LatGrid = LaGrid.Lt;
LonGrid = LoGrid.Lg;

earthellipsoid = referenceSphere('earth','km'); % Declare the sphere as globe

s = size(LatGrid);
[r,c] = size(LatGrid);

area_globe = zeros(r,c);

for j =1:c
    for i = 1:r

if i < r && j < c
area_globe(i,j) = areaquad(LatGrid(i,j),LonGrid(i,j),LatGrid(i,j+1),LonGrid(i+1,j),earthellipsoid);
elseif i == r && j < c
area_globe(i,j) = areaquad(LatGrid(i,j),LonGrid(i,j),LatGrid(i,j+1),100.0947,earthellipsoid);
elseif i < r && j == c
area_globe(i,j) = areaquad(LatGrid(i,j),LonGrid(i,j),-10.0304,LonGrid(i+1,j),earthellipsoid);
else
area_globe(i,j) = areaquad(LatGrid(i,j),LonGrid(i,j),-10.0304,100.0947,earthellipsoid);   
end

    end
end

 cd('/user1/jayesh/Work/MATLAB Codes/Kalpana Final');
 save('pxarea','area_globe');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  a = areaquad(-20,50.4,-19.92,50.48,earthellipsoid);
