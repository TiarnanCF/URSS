set(gca,'fontsize',20)
set(0,'defaultaxesfontsize',20)
set(0,'defaultlinelinewidth',2)

setUp
close all;

while true
    [Classes] = Tauleap(para,initialVacc,ICs,1,maxtime,1);
    if Classes.cases > 50
        break
    end
    
end
para2 = para;
para2.betaRestric = 1;

while true
    [Classes2] = Tauleap(para2,initialVacc,ICs,1,maxtime,1);
    if Classes2.cases > 50
        break
    end
    
end
residents = sum(Classes.country,3);
residents2 = sum(Classes2.country,3);

regularPlot

%CirclePlot

numIts = 2;
residentsAve = zeros(classCount,countryCount,numIts,maxtime);
for i =1:numIts
    while true
        [Classes] = Tauleap(para,initialVacc,ICs,1,maxtime,1);
        if Classes.cases > 50
            break
        end
    end
    residentsAve(:,:,i,:) = sum(Classes.country,3);
    
end

averagePlot
