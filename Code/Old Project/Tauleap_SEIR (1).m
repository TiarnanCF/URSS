%Tauleap for SIR on farms

function Classes = Tauleap_SEIR(para,ICs,tau,maxtime,Strat)

%Create storage matrices (one row per farm)
Classes.t = 0:tau:maxtime;
%we use the length of the time vector as this allows us to use other
%timesteps like tau=0.5 and still have our code work
len = length(Classes.t);
Classes.S = zeros(para.numFarms,len);
Classes.E = zeros(para.numFarms,len);
Classes.I = zeros(para.numFarms,len);
Classes.R = zeros(para.numFarms,len);

%Store the starting point of the simultion from the ICs and copy to a new
%structure called Classes. Define the starting time to be 0
Classes.S(:,1) = ICs.S';
Classes.E(:,1) = ICs.E';
Classes.I(:,1) = ICs.I';
Classes.R(:,1) = ICs.R';
Classes.t(:,1) = 0;

%Define the current state of the model from the ICs
S=ICs.S';
E=ICs.E';
I=ICs.I';
R=ICs.R';

%Define the current time in the model as 0
t=0;

%Count number of steps (this will increment at the end with other values
%are updated
i=2;

%Set DetectCaseTime as a placeholder to be updated when there are
%more than 10 animals infectious or removed
Classes.DetectCaseTime=maxtime;
%CullFarmTime stores the time a farm is scheduled to be culled
Classes.CullFarmTime=maxtime * ones(para.numFarms,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Run the model until either the maxtime is exceeded or until there are no
%infected animals remaining on any farm
while ((t<maxtime) && (sum(E + I)>0))

    %Define event rates as column vectors (one row for each farm) 
    infection = para.p*sum(S.*para.K.*I',2);
    latency = para.sigma*E;
    death = para.gamma*I;

    %Compute how many events occur for each time step
    inf_events=poissrnd(tau*infection);
    latency_events=poissrnd(tau*latency);
    death_events=poissrnd(tau*death);

    %Update events
    S = S - inf_events;
    E = E + inf_events - latency_events;
    I = I + latency_events - death_events;
    R = R + death_events;
    t =t + tau;
    
    %Checking for negative S values and fixing them
    idxS = find(S<0);
    for j = idxS
        E(j) = E(j) + S(j);
        S(j) = 0;
    end
    
    %Checking for negative E values and fixing them
    idxE = find(E<0);
    for j = idxE
        I(j) = I(j) + E(j);
        E(j) = 0;
    end
    
    %Checking for negative I values and fixing them
    idxI = find(I<0);
    for j = idxI
        R(j) = R(j) + I(j);
        I(j) = 0;
    end
    
    
    %Save the time when we hit more than 10 Infectious or Recovered individuals
    if sum(Classes.R(:,i-1) + Classes.I(:,i-1)) <=para.Detect && sum(R + I)>para.Detect
%         disp("detected outbreak at time " + t);
        Classes.DetectCaseTime = t;
    end
    
    %Checking if we are culling and if enough time has passed to start
    %culling
    if Strat > 1 && t >= Classes.DetectCaseTime + para.ConfTime
        %Find all farms with at least 5 recovered or infectious animals
        idxNewCases = find(R + I >= 5);
        %Finding all farms which up until do not have a culling scheduled
        idxOldCases = find(Classes.CullFarmTime == maxtime);
        %Taking the intersection of these farms as they are the farms that
        %have only just been identified
        updateCases = intersect(idxNewCases,idxOldCases);
        %We save the time at which they will be culled
        Classes.CullFarmTime(updateCases) = t + para.delay;
        
        %Finding which farms need to be culled today or before today and
        %then moving all animals into the R class
        
        cullFarms = find(Classes.CullFarmTime <= t); 
        S(cullFarms) = 0;
        E(cullFarms) = 0;
        I(cullFarms) = 0;
        R(cullFarms) = 200; 
        
        
        %An additional culling for RC strategy
        if Strat == 3
           %For each farm we just culled we cull all the neighbouring farms
           %within 3km
           for j = cullFarms'
               %Finding the farms that are nearby and also need culled
               nearby = find(para.d(:,j) <= 3);
               
               %Moving all animals into R class (culling)
               S(nearby) = 0;
               E(nearby) = 0;
               I(nearby) = 0;
               R(nearby) = 200;
               
               %To stop neighbouring farms of neighbouring farms being
               %culled if the neighbouring farm has not been detected by
               %time of culling we reset the cull time for maxtime + 1
               
               %To do this we first find the list of farms that currently
               %have not been identified for culling
               notDetected = find(Classes.CullFarmTime == maxtime);
               %We intersect this list with the list of nearby farms and
               %set the cullFarmTime to maxtime + 1 so that they will never
               %be culled
               Classes.CullFarmTime(intersect(nearby,notDetected)) = maxtime + 1;
           end
        end
    end
    
    

    %Save information in the Classes structure
    Classes.t(:,i) = t;
    Classes.S(:,i) = S;
    Classes.E(:,i) = E;
    Classes.I(:,i) = I;
    Classes.R(:,i) = R;
    i=i+1;
end

%Store the duration of the outbreak in Classes
Classes.Duration=t;

%Append the results with constant outputs if the simulation is over before
%maxtime
if t<maxtime

    Classes.S(:,[i:maxtime+1])=repmat(Classes.S(:,i-1),1,maxtime-t);
    Classes.E(:,[i:maxtime+1])=repmat(Classes.E(:,i-1),1,maxtime-t);
    Classes.I(:,[i:maxtime+1])=repmat(Classes.I(:,i-1),1,maxtime-t);
    Classes.R(:,[i:maxtime+1])=repmat(Classes.R(:,i-1),1,maxtime-t);
  
end