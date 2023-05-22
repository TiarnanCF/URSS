%Number of simulations per strat
%numIts = 1000;

%No intervention/Base initial case
paraBase = para;
paraBase.totVacc = zeros(1,countryCount);

residentsAveBase = zeros(classCount,countryCount,numIts,maxtime);
lockdownAveBase = zeros(countryCount,maxtime,numIts);
ICsNew = zeros(length(transMx),length(populations),length(populations),numIts);
visitorsBase = zeros(countryCount,maxtime,numIts);

%Initial pre-vaccine simulation
for i =1:numIts
    while true
        [Classes] = Tauleap(paraBase,initialVacc,ICs,1,maxtime,1);
        if Classes.cases > 50
            break
        end
    end
    
    ICsNew(:,:,:,i) = Classes.country(:,:,:,vaccStart + 1);
    residentsAveBase(:,:,i,:) = sum(Classes.country,3);
    lockdownAveBase(:,:,i) = Classes.lockdown;
    visitorsBase(:,:,i) = Classes.visitors;
end