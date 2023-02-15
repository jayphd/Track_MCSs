% Function for storing CSs info of 1st images

function [nmc,mccn,mcclog,mark] = storom(dt,mt, tm,mm, cent,areaa,sareaa, nob,nmc,mccloc,IR)

mccn = zeros(nob,15);
mcclog = zeros(1000000,15);
[r ,c] = size(IR);


 for m = 1:nob
      
     
     %%%%%%%%%%%%%%%%%%%%%%% Find minimum tempearture %%%%%%%%%%%%%%%%%%
     
       tempK = 1000; temp = 0; ct = 0; 
       
       for j = 1:c
           for i = 1:r
               
               if(mccloc(i,j,m) > 0)
                   
                   temp = temp + IR(i,j); 
                   ct = ct + 1; 
                   
                   if IR(i,j) < tempK 
                       
                       tempK = IR(i,j); 
                       
                   end
               end
           end
       end
         
         mtep = temp/ct;

%       [ind_i ind_j] = find( mccloc(m,:,:) > 0);
%       temp = min(IRG(ind_i,ind_j));
       
       
       %%%%%%%%%%%%%%%%%%%%%% Store CS info %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        mcclog(m,1) = m;             % ID
        mcclog(m,2) = dt;            % Date
        mcclog(m,3) = mt;            % Months
        mcclog(m,4) = tm;            % Hour
        mcclog(m,5) = (mm-1)*30;     % Minutes
        mcclog(m,6) = cent(m,1);     % Center Latitude 
        mcclog(m,7) = cent(m,2);     % Center Longitude
        mcclog(m,8)= round(areaa(m));       % Area
        mcclog(m,9) = 1;             % Life
        mcclog(m,10) = 0;             % Split from
        mcclog(m,11) = 0;            % Merged into
        mcclog(m,12) = 0;            % Merging CS ID
        mcclog(m,13) = round(tempK);        % Minimum temperature 
        mcclog(m,14) = round(sareaa(m));    % Area of 208 K 
        mcclog(m,15) = round(mtep);          % mean tb 

        mccn(m,1) = m;
        mccn(m,2) = dt;
        mccn(m,3) = mt;
        mccn(m,4) = tm;
        mccn(m,5) = (mm-1)*30;
        mccn(m,6) = cent(m,1);
        mccn(m,7) = cent(m,2);
        mccn(m,8)= round(areaa(m));
        mccn(m,9) = 1;
        mccn(m,10) = 0;
        mccn(m,11) = 0;
        mccn(m,12) = 0; 
        mccn(m,13) = round(tempK); 
        mccn(m,14)= round(sareaa(m));
        mccn(m,15) = round(mtep);      
end
    
    nmc = nmc + nob;
    mark = nmc;
   
end