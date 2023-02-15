%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code extracts MCSs from gridded IR images of INSAT3D satellite.
% Use Grid_data.m for gridding raw data from INSAT3D satellite.
% MCS are extracted, tracked and then stored in .csv files.
% Contact: Jayesh Phadtare. jayesh.phadtare@gmail.com


%% Declaring Variables

clc; clear;close all;
%%%%%%%%%%%%%%%%%%%%%%% Latitude and Longitude Grid %%%%%%%%%%%%%%%%%%%%%%%

[LatGrid, LonGrid] = meshgrid(0:(1/12):30,(60.08:(1/12):100)); % declare native lat-lon grid


%%%%%%%%%%%%%%%%%%%%%%%%% Declare Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = size(LatGrid);
yr = [2018,2019]; % study years
tbct = [208 220 230 240 233]; % Cut-off IR temperatures
ar_threshold = 2000; % Area threshold

for tc = 1:1 % loop for temperature cutoff
    
    disp([' Tb threshold = ', num2str(tbct(tc)), ' K']);
    disp([' Size threshold = ', num2str(ar_threshold), ' sq.km']);
             
 for y = 1:1 % loop for  years
       
      nmc = 0;                                                    
      nim = 0;
      biir = zeros(s);                                         % binary IR matrix
      IRG = zeros(s);                                         % IR value Matrix
      nomcc_im = zeros(length(tbct),1);              % No of CSs with IR cut-offs 
      
 for mt = 6:6 % loop for  months
        
         
        disp(['Tracking started for Month == ', num2str(mt), ',', ' Year == ', num2str(yr(y))]) 
        
        if mt == 6 || mt == 9
            dt = 30;  % 30 days for June and Sept
        else
            dt = 31;   % 31 days for July and Aug
        end
        
    for d = 4:15 % loop for days
       
       dstr =  [num2str(d), num2str(6), '2018_']; % DayMonthYear_;
       ind = 1; % image number
       
        for n = 0:1:23 % loop for  hours
                        
            for m = 1:2 % loop for  minutes
    
                if m == 1
                    tstr = [num2str(n),'00']; %Hour_Min;
                else
                    tstr = [num2str(n),'30'];
                end
                  
                % gridded IR data path
                path_ir = 'D:\Satellite_Data\INSAT3D\IRBT\June\gridded';
                cd(path_ir)
                
                file_name =  [dstr,tstr];
                
                %%%%%%%%%%%%%%%%%%%%%%%%% Extract variables from the file %%%%%%%%%%%%%%%%%
         
                try
                    load(file_name);  %% load structure of IR  image in variable 'IRG'
                     catch exception
                          
                    continue
                end
                
                [r,c] = size(IRG); % IRG = IR temperature
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Refine data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  
                % Drop excessively high and low temperatures
                for j = 1:1:c
                    for i = 1:1:r
                        
                        if   IRG(i,j) > 350 || IRG(i,j) < 150
                             IRG(i,j) = NaN;
                        end
                        
                    end
                    
                end
                
                %%%%%%%%% Get binary image applying temperature threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%
                                              
                for j = 1:1:c
                    for i = 1:1:r

                        if    IRG(i,j) > tbct(tc) || isnan(IRG(i,j))
                            IRG(i,j) = NaN; biir(i,j) = 0;
                        else
                            biir(i,j) = 1;
                        end

                    end
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%% Get CS structure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
                %Remove objects below no of pixel
                biir = double(bwareaopen(biir,50));
                cd('D:\Matlab_Scripts\INSAT3D\Track_MCSs');
                %  Filter out smaller objects
                biir = filterarea(biir, ar_threshold);

                % get center, area, count, B & W image,location of all CS
                [cent, mccarea,smallarea, nob,CC,mccloc] = findconn(biir,IRG,LatGrid,LonGrid);

                % Store CS info of image (image 2 onwards)
                if nmc > 0
                    [nmc, mccn, mcclog, mark] = storem(d,mt,n,m,cent,mccarea,smallarea,nob,nmc,mccloc,mcclog,lastnob,mark,lastloc,mccn,lastarea,IRG);

                % Store CS info of 1st image
                else
                    [nmc, mccn, mcclog, mark] = storom(d,mt, n,m,cent,mccarea,smallarea,nob,nmc,mccloc,IRG);
                end

                % store last image CS info
                lastcent = cent;
                lastnob = nob;
                lastarea = mccarea;
                lastloc = mccloc;
                lastmccn = mccn;               
             
               clear IRG;
               clear biir;
                
                ind = ind + 1;
            end
           
        end
    end
 end
 
mcclog = mcclog(1:mark,:);
mcclog = mcclog(1:mark,:);
mccsort = zeros(mark,15);
t = 1;

%%%%%%%%%%%%%%%%%%%%%% Arrage Data CS according to id %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:nmc
    for j = 1:mark
        
        if mcclog(j,1) == i
            mccsort(t,:) = mcclog(j,:);
            t = t+1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%% Save CS data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MCS_dataset = array2table(mccsort,'VariableNames', {'ID','Day','Month', 'Hour','Minutes', 'lat','lon','Area','ImageNumber','SplitParentID','MergeParentID', ...
                         ' MergeChldArea', 'MinT','CoreArea', 'AvgT'});
                     
clear mcclog;
clear mccsort;
    
     %%%%%%%%%%% Save MCSs table in .csv format %%%%%%%%%%%%
            
out_path = 'D:\Matlab_Scripts\INSAT3D\Track_MCSs\MCSs_dataset';       
cd(out_path);
% Output file name
mccstr = ['MCS_List_',num2str(tbct(tc)),'_',num2str(yr(y)), 'MISO-BOB-Leg1.csv']; 
writetable(MCS_dataset, mccstr);
    
 end
end








