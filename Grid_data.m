
%*********** Grid INSAT3D data on a regular lat-lon grid *************** 

clc; clear all; close all;
ni = 1;

lat= linspace(-10,45.5,1616);
int_lat = 0.034;
Lat=[];

for I = 1:length(lat)
    lat1 = lat(1)+((int_lat)*I)./0.916;
    Lat = [Lat;lat1];
end
lat=Lat;

lon = linspace(44.5-0.04,105.5,1618);
int_lon = 0.037;
Lon=[];
for I = 1:length(lon)
    lon1 = lon(1)+((int_lon)*I)*1.01;
    Lon = [Lon;lon1];
end
lon=Lon;
            
[Lat_INS ,Lon_INS] = meshgrid(lat,lon);




for d = 1:1:20
    
    dstr = ['3DIMG_',num2str(d,'%02d'),'JUN2018_']; 
    
    for n = 0:1:23
        
        tstr1 = num2str(n,'%02d');
        
        for m = 1:2
            
            
            %%  Extract file name
            cd('D:\Satellite_Data\INSAT3D\IRBT\June')
            
            if m == 1
                
                file_name1 =  [dstr, tstr1, '00','_L1C_ASIA_MER.h5'];
            else
                file_name1 = [dstr, tstr1, '30','_L1C_ASIA_MER.h5'];
                
            end
            
           
            %%
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Extract variables from data %%%%%%%%%%%%%%%%%
            %%
            try
                
                bt=double(h5read(file_name1,'/IMG_TIR1'));
                bt_t=double(h5read(file_name1,'/IMG_TIR1_TEMP'));
                
                for i = 1:1618
                    for j =1:1616
                        
                        bt(i,j) = bt_t(bt(i,j));
                        
                    end
                end
                
                
            catch exception
                continue
            end
            
            IR = bt;
            
            [r,c] = size(IR);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Grid Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Grid Data
            
           % specify lat-lon grid
            [LatGrid, LonGrid] = meshgrid(-10.00:(1/12):50,(45:(1/12):105.0));
            IRG = griddata(Lat_INS,Lon_INS, IR, LatGrid, LonGrid);
            
            IRG = fliplr(IRG);
             
             % Crop data
             LatGrid = LatGrid(181:661, 121:481);
             LonGrid =  LonGrid(181:661, 121:481);
            IRG = IRG(181:661, 121:481);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % %%
            
            if m == 1
                ttl_name = [num2str(d), num2str(6), '2018_', num2str(n),'00']; % DayMonthYear_Hour_Min
            else
                ttl_name = [num2str(d), num2str(6), '2018_', num2str(n),'30']; 
            end
            
            % save data
            cd('D:\Satellite_Data\INSAT3D\IRBT\June\gridded')
            save('latitude.mat','lat')
            save('longitude.mat','lon')
            save([ttl_name,'.mat'],'IRG')
            
            disp([ttl_name,'.mat'])
                                   
            h = figure; 
            set(h,'Visible','off');
            h = pcolor(LonGrid,LatGrid,(IRG)); shading flat;
            xlim([60 100]);
            ylim([0 30]);
            caxis([180 300]);
            S = shaperead('landareas.shp','UseGeoCoords',true);
            h = geoshow([S.Lat],[S.Lon],'Color','black','LineWidth',2);
            title(ttl_name)
            colorbar
            box on
            
            cd('D:\Satellite_Data\INSAT3D\IRBT\June\gridded\plots');
            set(gcf,'PaperPosition',[0.3 0.3 20 15]);
            figname = [ttl_name,'.png'];
            print(gcf,'-r300','-dpng',figname);
            ni = ni+1;
            %
            close all;
            
        end
    end
end




