%Stochastic (tau leap) SIR model with demography code

function [Classes] = Tauleap(para,initialVacc,ICs,mintime,maxtime,tau)

%para.Beta is a matrix, para.trans is a matrix
%para.ICs is initial cons for each country
%Run the tauleap algorithm for an SIR model
restric = para.restric;
info = size(ICs);
classCount = info(1);
countryCount = info(2);
%Store the starting point ofCl the simultion from the ICs and copy to a new
%structure called Classes. Define the starting time to be 0
Classes.country = zeros(classCount,countryCount, countryCount,maxtime - mintime + 1);
Classes.vaccSupply = ones(countryCount,maxtime) .* initialVacc';
Classes.vaccLeft = ones(countryCount,maxtime) .* initialVacc';
Classes.country(:,:,:,1) = ICs;
Classes.cases = 0;
Classes.visitors = zeros(countryCount, maxtime);
Classes.t = mintime;
Classes.lockdown = zeros(countryCount,maxtime);
totVacc = initialVacc;
%numFails stores the number of times a time-step produces a negative number
%of individuals in a class
Classes.numFails = 0;

%Define the current state of the model from the ICs
country = ICs;

%Define the current time in the model as 0
t=mintime;
%Important transmission matrix
mx = ones(classCount,classCount);
infMx = tril(mx,-1) - tril(mx,-2);

%Run the model until either the maxtime is exceeded or until there are no
%infected people remaining
while (t<maxtime)
    scale = sum(country,1);
    pos = scale == 0;
    scale(pos) = 1;
    travelRate = (para.travelRate .* country)./ scale;
    counter = 0;
    
    travelRestrictions = ones(1,1,countryCount,countryCount);
    restrictions = restric <= t+1;
    for i = restrictions
        for j = 1:countryCount
            travelRestrictions(1,1,j,i) = para.travelRestric;
            travelRestrictions(1,1,i,j) = para.travelRestric;
        end
    end
    travelRate = travelRate .* travelRestrictions;
    
    while true
        travel = poissrnd(tau*travelRate);
        leavingTravel = sum(travel,4);
        comingTravel = permute(sum(travel,3),[1 2 4 3]);
    
        newCountry = country - leavingTravel + comingTravel;
        if min(newCountry) >= 0
           break; 
        else
           Classes.numFails = Classes.numFails + 1;
           if counter == 50
               Classes.cases = 0;
               t = maxtime-1;
               newCountry = country .* 0;
               break;
           end
           counter = counter +1;
        end
    end
    country = newCountry;
    i=1;
    Classes.visitors(:,t+1) = sum(permute(sum(comingTravel,1),[3 2 1]) .* (ones(countryCount,countryCount) - eye(countryCount)),2);
    
    if mod(t-para.vaccStart,para.supplyDay) ==0 && t>=para.vaccStart
        totVacc = totVacc + para.totVacc;
        Classes.vaccSupply(:,t+tau:end) = Classes.vaccSupply(:,t+tau:end) + para.totVacc';
    end
    
    counter = 0;
    while i <= countryCount
        if t >= restric(i)
            scaleRes = para.betaRestric;
            Classes.lockdown(i,t+1) = 1;
        else
            scaleRes =1;
        end

        %Define event rates 
        infRate = (scaleRes .* para.beta(:,:,i) * sum(country(:,:,i),2)) .* country(:,:,i) ./ (max(sum(sum(country(:,:,i),1),2),1));
        %transRate = para.trans .* country(:,i)';
        
        transRate = ones(classCount,classCount,countryCount);
        for j =1:countryCount
            transRate(:,:,j) = transRate(:,:,j) .* country(:,j,i)' .* para.trans;
        end
        
        if t > para.vaccStart
            %vaccRate = country(:,i,i) .* para.vacc(:,i);        
   
            vaccRate = (para.vacc(:,i)) .* country(:,i,i) ./ max(sum(country([1 7],i,i)),1);
            if max(vaccRate) > totVacc(i)/2
                pos = vaccRate > totVacc(i)/2;
                vaccRate(pos) = totVacc(i) /2;
            end
            
            %If people who can be vaccinated dips below number of daily
            %vaccinations we send everyone off to be vaccinated :)
            pos = vaccRate > country(:,i,i);
            country(para.vaccPos,i) = newCountry(para.vaccPos,i) + sum(country(pos,i,i));
            country(pos,i,i) = 0;
            
        else
            vaccRate = zeros(length(country(:,i,i)),1);
        end
        
        %Compute how many events occur for each time step
        infEvents = poissrnd(tau*infRate);
        transEvents = poissrnd(tau*transRate);
        vaccEvents = poissrnd(tau*vaccRate);
        
        leavingEvents = permute(sum(transEvents,1),[2 3 1]);
        comingEvents = permute(sum(transEvents,2), [1 3 2]);
        
        totalVaccs = sum(vaccEvents);
        infs = infMx*infEvents;
        %Check nothing less than zero
        newCountry = country(:,:,i) + comingEvents - leavingEvents - infEvents + infs;
        newCountry(para.vaccPos,i) = newCountry(para.vaccPos,i) + totalVaccs;
        newCountry(:,i) = newCountry(:,i) - vaccEvents;
        
        
        vacLeft = totVacc(i) - totalVaccs;
        
        if (min(min(newCountry)) >= 0) && (vacLeft >= 0)
            Classes.cases = Classes.cases + sum(sum(infs,1),2);
            if restric(i) == maxtime && sum(sum(sum(transEvents([17 9],:,:),3),1),2) > para.facRestric(i)
                restric(i) = t + 14;
            elseif sum(sum(sum(transEvents([17 9],:,:),3),1),2) <= para.facRelax(i)
                restric(i) = maxtime;
            end
            
            %If nothing is less than zero then we update the classes and time
            country(:,:,i) = newCountry;
            totVacc(i) = vacLeft;
            Classes.vaccLeft(i,t+tau) = vacLeft;
            %Update the info
            Classes.country(:,:,i,t+tau) = country(:,:,i);
            i = i+1;
        else
            Classes.numFails = Classes.numFails + 1;
            if counter == 50
               Classes.cases = 0;
               t = maxtime-1;
               country = country .* 0;
               break;
           end
           counter = counter +1;
        end
    end
    
    %Update time
    t = t+tau;   
end
    
