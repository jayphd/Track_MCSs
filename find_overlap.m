
%%%% Code extracting MMCs from IR image of Kalpana 1 satellite.

%% Declaring Variables

clc; clear all;close all;
clock

tbct = [201 211 221 231 241 251 261];                        % Cut-off IR temperatures
biir1 = zeros(626,626); biir2 = zeros(626,626); 
biir3 = zeros(626,626);                                      % binary IR matrix
IR1 = zeros(626,626); IR2 = zeros(626,626);                  % IR value Matrix
nomcc_im = zeros(length(tbct),1);                            % No of MCCs for IR cut-offs 

[LatGrid, LonGrid] = meshgrid(-20:(1/12.5):30,(50.04:(1/12.5):100.04));


for l = 3:3 %length(tbct)
    
    display(tbct(l));
    
     
    nmc = 0;                          
    
    for d = 1:1
        tic
     
        for n = 0:1:0
                        
            for m = 1:1
                
                
                dstr = [num2str(d),'JUL2012'];
                
                if m ==1
                    tstr1 = [num2str(n),'00.mat'];
                    tstr2 = [num2str(n+1),'00.mat'];
                else
                    tstr1 = [num2str(n),'30.mat'];
                    tstr2 = [num2str(n+1),'30.mat'];
                end
                
                
                %%  Extract file name
                  cd('/user1/jayesh/SATELLITE DATA/Grid/IR_8/India/July')
                
                
                file_name1 =  [dstr, tstr1];
                file_name2 =  [dstr, tstr2];
                
                %%
                
                
                
                %%  Extract variables from the file
                try
                    IRVIS1 = load(file_name1); %% load structure of IR 
                    IRVIS2 = load(file_name2); %% 
                catch exception
                    continue
                end
                IR1 = IRVIS1.IRm;  %% Extract IR
                IR2 = IRVIS2.IRm;
                cd('/user1/jayesh/Work/MATLAB Codes/Kalpana Final')
                
                
                
                %%
                % Refine data
                for j = 1:1:626
                    for i = 1:1:626
                        
                        if   IR1(i,j) > 350
                             IR1(i,j) = NaN;
                            
                        end
                        if   IR2(i,j) > 350
                             IR2(i,j) = NaN;
                            
                        end
                    end
                    
                end
                
                %%
                
                %% Process Data : Get binary image
                
                for j = 1:1:626
                    for i = 1:1:626
                        
                        
                        if   IR1(i,j) > tbct(l)
                             biir1(i,j) = 0 ; IR1(i,j) = NaN;
                        else
                             biir1(i,j) = 1;
                        end
                        
                        if   IR2(i,j) > tbct(l)
                             biir2(i,j) = 0 ; IR2(i,j) = NaN;
                        else
                             biir2(i,j) = 1;
                        end
                        
                    end
                    
                end
                
                %%
                
                
                %% MCC structure
             
                
                biir1 = double(bwareaopen(biir1,39));
                biir2 = double(bwareaopen(biir2,39));  %  Remove objects bwlow no of pixel
                
                biir1 = filterarea(biir1);            %  Filter out smaller objects 
                biir2 = filterarea(biir2);
                
%                 get center, area, location of all CS
%                 [cent1, mccarea1, nob1, CC1,mccloc1] = findconn(biir1,LatGrid,LonGrid);
%                 [cent2, mccarea2, nob2, CC2,mccloc2] = findconn(biir2,LatGrid,LonGrid);
                
%                 if nmc > 0;
%                     [nmc mccn mcclog mark] = storem(d,n,cent,mccarea,nob,nmc,mccloc,mcclog,lastnob,mark,lastloc,mccn); 
%                     
%                 end              
%                 
%                 if nmc == 0
%                     [nmc mccn mcclog mark] = storom(d, n, cent,mccarea, nob,nmc); % Store CS info
%                 end 
%                 
%                 nomcc_im(l) = nomcc_im(l) + nob;
%                 
%              
%                 lastcent = cent;
%                 lastnob = nob;
%                 lastarea = mccarea;
%                 done = 1;
%                 lastloc = mccloc;
%                 lastmccn = mccn;
                
                %% Plot data
                
                for j = 1:1:626
                    for i = 1:1:626
                        
                     biir3(i,j) = biir1(i,j) + biir2(i,j);                    
                        
                    end
                end
                
                for j = 1:1:626
                    for i = 1:1:626
                        
                        if    biir1(i,j) == 0 ;
                              biir1(i,j) = NaN ; 
                        else 
                              biir1(i,j) = 1;
                        end
                        
                        if    biir2(i,j) == 0 ;
                              biir2(i,j) = NaN ;
                        else 
                              biir2(i,j) = 3;
                        end  
%                         
                        if    biir3(i,j) == 2 ;
                              biir3(i,j) = 2;
                        else
                              biir3(i,j) = NaN;
                        end  
%                         
                        
                    end
                end
                
                
                
                lat=[-20  30];
                lon=[50 100];
                mapgrid(LatGrid,LonGrid,biir1,lat,lon,n,m,d);
                cd('/user1/jayesh/Work/MATLAB Codes/Kalpana Final')
                mapgrid(LatGrid,LonGrid,biir2,lat,lon,n+1,m,d);
                cd('/user1/jayesh/Work/MATLAB Codes/Kalpana Final')
                mapoverlap(LatGrid,LonGrid,biir1,biir2,biir3,lat,lon,n,m,d);
                cd('/user1/jayesh/Work/MATLAB Codes/Kalpana Final')
               
                
             
                %%
%                clear IR;
%                clear biir; 
                
            end
           
        end
     d
     toc   
    end
    

   

end


% CC = bwconncomp(biir3);
% nob = CC.NumObjects;
% labelp = labelmatrix(CC);
% 
% 
% 
% calarea = zeros(nob,1);
% 
% 
% garea = load('pxarea.mat');
% garea = garea.parea;
% 
% for k =1:nob
%     for j =1:600
%         for i = 1:700
%             
%             if labelp(i,j) == k
%                 calarea(k,1) = calarea(k,1) + garea(i,j);
%             end
%             
%         end
%     end
% end
% 
% csarea = zeros(nob,1);
% i = 1;
% 
% for k =1:nob
%     
%     if calarea(k) > 2000
%         csarea(i) = calarea(k);
%         i = i +1;
%     end
% end
% 
% csarea = csarea(1:i-1);
% 
% 
% plot(csarea,'--ob','LineWidth',2)
% set(gca,'fontsize',24,'fontweight','bold');
% title('Area of overlaps');
% ylabel(['km^{2}'])
% ylim([0 10000])
% cd('/user1/jayesh/MATLAB Codes/Kalpana Final')
% 
% 
% 
% clock

%% Windows paths

% D:\Studies\CAOS\MATLAB Codes\Data\Kalpana -1\AUGUST
% D:\Studies\CAOS\MATLAB Codes\Kalpana-I

%% Ubuntu paths
% /user1/jayesh/SATELLITE DATA/Grid/IR/India/AUGUST
% /user1/jayesh/MATLAB Codes/Kalpana Windows





