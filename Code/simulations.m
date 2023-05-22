%Selfish Scenario One Country Keeps all Vaccines
para1 = para;
para1.totVacc = [TotalVaccinesMonthly 0 0];

%Proporional Scenario Divided by population size
para2 = para;
para2.totVacc = round((populations .* TotalVaccinesMonthly) ./ sum(populations));

%Vaccinating Smallest Population
para3 = para;
para3.totVacc = [0 0 TotalVaccinesMonthly];

%Scenario Divided Equally (Not Proportionally) Between Countries
para4 = para;
para4.totVacc = ones(1,countryCount) .* round(TotalVaccinesMonthly / 3);

%Essentially Infinite Supply
para5 = para;
para5.totVacc = ones(1,countryCount) .* 100000000;

%ROI Hoards
para6 = para;
para6.totVacc = [0 TotalVaccinesMonthly 0];



residentsAve1 = zeros(classCount,countryCount,numIts,maxtime);
residentsAve2 = zeros(classCount,countryCount,numIts,maxtime);
residentsAve3 = zeros(classCount,countryCount,numIts,maxtime);
residentsAve4 = zeros(classCount,countryCount,numIts,maxtime);
residentsAve5 = zeros(classCount,countryCount,numIts,maxtime);
residentsAve6 = zeros(classCount,countryCount,numIts,maxtime);

lockdownAve1 = zeros(countryCount,maxtime,numIts);
lockdownAve2 = zeros(countryCount,maxtime,numIts);
lockdownAve3 = zeros(countryCount,maxtime,numIts);
lockdownAve4 = zeros(countryCount,maxtime,numIts);
lockdownAve5 = zeros(countryCount,maxtime,numIts);
lockdownAve6 = zeros(countryCount,maxtime,numIts);

vaccLeft1 = zeros(numIts,maxtime);
vaccLeft2 = zeros(numIts,maxtime);
vaccLeft3 = zeros(numIts,maxtime);
vaccLeft4 = zeros(numIts,maxtime);
vaccLeft6 = zeros(numIts,maxtime);

visitors1 = zeros(countryCount,maxtime,numIts);
visitors2 = zeros(countryCount,maxtime,numIts);
visitors3 = zeros(countryCount,maxtime,numIts);
visitors4 = zeros(countryCount,maxtime,numIts);
visitors5 = zeros(countryCount,maxtime,numIts);
visitors6 = zeros(countryCount,maxtime,numIts);

residentsAve1(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);
residentsAve2(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);
residentsAve3(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);
residentsAve4(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);
residentsAve5(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);
residentsAve6(:,:,:,1:vaccStart) = residentsAveBase(:,:,:,1:vaccStart);

lockdownAve1(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);
lockdownAve2(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);
lockdownAve3(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);
lockdownAve4(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);
lockdownAve5(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);
lockdownAve6(:,1:vaccStart,:) = lockdownAveBase(:,1:vaccStart,:);

visitors1(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);
visitors2(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);
visitors3(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);
visitors4(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);
visitors5(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);
visitors6(:,1:vaccStart,:) = visitorsBase(:,1:vaccStart,:);

lockdownStart = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd = ones(numIts,maxtime,countryCount) .* (maxtime+1);

j =1;
for k=1:countryCount
    for i =1:numIts
        lockdownStart(i,j,k) = find(lockdownAveBase(k,:,i),1,'first');
        lockdownEnd(i,j,k) = find(lockdownAveBase(k,lockdownStart(i,j,k)+1:end,i)==0,1,'first') + lockdownStart(i,j,k) -1;
    end
end

for k=1:countryCount
    for i =1:numIts
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAveBase(k,lockdownEnd(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart(i,j,k) = newpos + lockdownEnd(i,j-1,k);
            newpos = find(lockdownAveBase(k,lockdownStart(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd(i,j,k) = maxtime;
                break
            end
            
            lockdownEnd(i,j,k) =  newpos + lockdownStart(i,j,k) -1;
        end
    end
end

lockdownStart = permute(round(sum(lockdownStart,1) ./ numIts),[3 2 1]);
lockdownEnd = permute(round(sum(lockdownEnd,1) ./ numIts),[3 2 1]);

lockdown = zeros(3,maxtime);
for i = find(lockdownStart(1,:) <= maxtime)
    lockdown(1,lockdownStart(1,i):min([lockdownEnd(1,i),maxtime])) = 1;
end
for i = find(lockdownStart(2,:) <= maxtime)
    lockdown(2,lockdownStart(2,i):min([lockdownEnd(2,i),maxtime])) = 1;
end
for i = find(lockdownStart(3,:) <= maxtime)
    lockdown(3,lockdownStart(3,i):min([lockdownEnd(3,i),maxtime])) = 1;
end




for i =1:numIts
    para1.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes1] = Tauleap(para1,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes1.cases > 50
            break
        end
    end
    para2.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes2] = Tauleap(para2,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes2.cases > 50
            break
        end
    end
    para3.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes3] = Tauleap(para3,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes3.cases > 50
            break
        end
    end
    para4.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes4] = Tauleap(para4,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes4.cases > 50
            break
        end
    end
    para5.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes5] = Tauleap(para5,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes5.cases > 50
            break
        end
    end
    para6.restric = lockdownAveBase(:,vaccStart,i)';
    while true
        [Classes6] = Tauleap(para6,initialVacc,ICsNew(:,:,:,i),vaccStart,maxtime,1);
        if Classes6.cases > 50
            break
        end
    end
    
    
    
    
    residentsAve1(:,:,i,vaccStart+1:end) = sum(Classes1.country(:,:,:,vaccStart+1:end),3);
    residentsAve2(:,:,i,vaccStart+1:end) = sum(Classes2.country(:,:,:,vaccStart+1:end),3);
    residentsAve3(:,:,i,vaccStart+1:end) = sum(Classes3.country(:,:,:,vaccStart+1:end),3);
    residentsAve4(:,:,i,vaccStart+1:end) = sum(Classes4.country(:,:,:,vaccStart+1:end),3);
    residentsAve5(:,:,i,vaccStart+1:end) = sum(Classes5.country(:,:,:,vaccStart+1:end),3);
    residentsAve6(:,:,i,vaccStart+1:end) = sum(Classes6.country(:,:,:,vaccStart+1:end),3);
    
    lockdownAve1(:,vaccStart+1:end,i) = Classes1.lockdown(:,vaccStart+1:end);
    lockdownAve2(:,vaccStart+1:end,i) = Classes2.lockdown(:,vaccStart+1:end);
    lockdownAve3(:,vaccStart+1:end,i) = Classes3.lockdown(:,vaccStart+1:end);
    lockdownAve4(:,vaccStart+1:end,i) = Classes4.lockdown(:,vaccStart+1:end);
    lockdownAve5(:,vaccStart+1:end,i) = Classes5.lockdown(:,vaccStart+1:end);
    lockdownAve6(:,vaccStart+1:end,i) = Classes6.lockdown(:,vaccStart+1:end);
    
    vaccLeft1(i,vaccStart+1:end) = sum(Classes1.vaccLeft(:,vaccStart+1:end),1);
    vaccLeft2(i,vaccStart+1:end) = sum(Classes2.vaccLeft(:,vaccStart+1:end),1);
    vaccLeft3(i,vaccStart+1:end) = sum(Classes3.vaccLeft(:,vaccStart+1:end),1);
    vaccLeft4(i,vaccStart+1:end) = sum(Classes4.vaccLeft(:,vaccStart+1:end),1);
    vaccLeft6(i,vaccStart+1:end) = sum(Classes6.vaccLeft(:,vaccStart+1:end),1);

    visitors1(:,vaccStart+1:end,i) = Classes1.visitors(:,vaccStart+1:end);
    visitors2(:,vaccStart+1:end,i) = Classes2.visitors(:,vaccStart+1:end);
    visitors3(:,vaccStart+1:end,i) = Classes3.visitors(:,vaccStart+1:end);
    visitors4(:,vaccStart+1:end,i) = Classes4.visitors(:,vaccStart+1:end);
    visitors5(:,vaccStart+1:end,i) = Classes5.visitors(:,vaccStart+1:end);
    visitors6(:,vaccStart+1:end,i) = Classes5.visitors(:,vaccStart+1:end);
end
vaccSupply = sum(Classes1.vaccSupply,1);