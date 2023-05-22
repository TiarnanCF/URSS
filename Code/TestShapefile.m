
%Read in shapefile 
% found in http://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-admin-0-countries/
%save in directory

World=shaperead('ne_10m_admin_0_countries/ne_10m_admin_0_countries');

%find countries to plot
for i=1:length(World)
    
    x(i)=strcmp(deblank(World(i).NAME),'United Kingdom');
    y(i)=strcmp(deblank(World(i).NAME),'Ireland');
end
GB=World(find(x==1));
ROI=World(find(y==1));


%plot those countries on a map
figure

mapshow(GB,'EdgeColor',[1 1 1],'FaceColor','b')

hold on

mapshow(ROI,'EdgeColor',[1 1 1],'FaceColor',[73, 222, 47]./255)


        