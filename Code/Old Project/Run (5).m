%Start by defining font sizes etc...
clear
set(gca,'fontsize',20)
set(0,'defaultaxesfontsize',20)
set(0,'defaultlinelinewidth',2)

%Loading in Posterior and Defining initial conditions for initial
%simulation to find initial conditions for when trialling strategies
load('locations.mat');
numFarms = length(locations);
%Calculating the distance matrix for the distance between each farm
d = zeros(numFarms,numFarms);
for i = 1:numFarms
    for j = i:numFarms
        d(i,j) = ((locations(i,1) - locations(j,1))^2 + (locations(i,2) - locations(j,2))^2)^(0.5);
        %Distance matrix is symmetric so cutting corners by just doing
        %calculation once
        d(j,i) = d(i,j);
    end
end

%BEGINNING OF QUESTION 1
%Defining some initial parameters
maxtime = 3*365;
A = [4,1,0.2];
B = [0.4,0.1,0.02];
n = 200;
Detect = 10;

%Calculating K for each of our three pairs of A,B values
K = zeros(numFarms,numFarms,3);
for i = 1:3
    K(:,:,i) = A(i) * exp(-B(i) * d .* d);
end
%Defining our parameters as a structure
para = struct('p',0.0005,'sigma',1/5,'gamma',1/14,'K',K(:,:,2),'numFarms',numFarms,'Detect',Detect,'d',d,'delay',5,'ConfTime',9);

%Defining our initial conditions
ICs = struct('S',n*ones(1,numFarms),'E',zeros(1,numFarms),'I',zeros(1,numFarms),'R',zeros(1,numFarms));
ICs.S(1) = ICs.S(1) - 2;
ICs.I(1) = ICs.I(1) + 2;

%Running our simulation
[Classes] = Tauleap_SEIR(para,ICs,1,maxtime,1);
%Finding the index position of when the outbreak is detected and
%calculating the total number of animals infectious or removed on the farms
idx = find(Classes.t==Classes.DetectCaseTime);
totalInf = Classes.R + Classes.I;

%Producing a scatter plot of our farms with their infection levels
figure(1)
clf
%Storing the positions we are interested in
pos = [1, idx, length(totalInf)];

%Running through all three plots we want to make
for j = 1:3
    subplot(1,3,j)
    hold on;
    %Finding idx positions of farms with a certain range of infected
    %animals
    idxnone = find(totalInf(:,pos(j)) == 0);
    idx0 = find(totalInf(:,pos(j)) > 0);
    idx2 = find(totalInf(:,pos(j)) > 2);
    idx5 = find(totalInf(:,pos(j)) > 5);
    idx10 = find(totalInf(:,pos(j)) >= 10);
    idx20 = find(totalInf(:,pos(j)) >= 20);
    idx50 = find(totalInf(:,pos(j)) >= 50);
    idx100 = find(totalInf(:,pos(j)) >= 100);
    idx150 = find(totalInf(:,pos(j)) >= 150);

    %Plotting the farms with different colours based on the number of
    %affected animals on that farm
    h1 = scatter(locations(idxnone,1),locations(idxnone,2),25,[21, 130, 63]./255,'filled');
    h2 = scatter(locations(idx0,1),locations(idx0,2),25,[245,221,66] ./ 255,'filled');
    h3 = scatter(locations(idx2,1),locations(idx2,2),25,[237, 161, 9] ./ 255,'filled');
    h4 = scatter(locations(idx5,1),locations(idx5,2),25,[255, 102, 46] ./ 255,'filled');
    h5 = scatter(locations(idx10,1),locations(idx10,2),25,[196, 45, 45] ./ 255,'filled');
    h6 = scatter(locations(idx20,1),locations(idx20,2),25,[83, 79, 224] ./ 255,'filled');
    h7 = scatter(locations(idx50,1),locations(idx50,2),25,[31, 21, 212] ./ 255,'filled');
    h8 = scatter(locations(idx100,1),locations(idx100,2),25,[122, 12, 166] ./ 255,'filled');
    h9 = scatter(locations(idx150,1),locations(idx150,2),25,'fill','k');
    
    %Displaying the legend
    if j == 1
        legend([h1 h2 h3],'0','1-2','3-5','location','southeast')
        ylabel('y-coordinate');
        title({'','', 'on Day 0'})
    elseif j == 2
        legend([h4 h5 h6],'6-9','10-19','20-49','location','southeast')
        xlabel('x-coordinate');
        title({'Number of Livestock Infectious or Recovered per Farm', 'for a Detected Outbreak with No Control under K_2','When Outbreak Detected'})
    else
        legend([h7 h8 h9],'50-99','100-149','150-200','location','southeast')
        title({'','','Post-Epidemic'})
    end
end

%QUESTION 1(b)- Detected Outbreaks
%We begin by running 1000 outbreaks where we discard any undetected
%outbreaks
for i = 1:1000
    while true
        Classes2(i) = Tauleap_SEIR(para,ICs,1,maxtime,1);
        if Classes2(i).DetectCaseTime < maxtime
            break;
        end
    end
    %We record key details like duration, size of outbreak, and number of
    %farms infected
    duration2(i) = Classes2(i).Duration;
    size2(i) = sum(Classes2(i).R(:,end));
    farmsInf2(i) = sum(Classes2(i).R(:,end)>0);
    totalInf2(:,i) = Classes2(i).R(:,end);
end

data2 = [duration2; size2; farmsInf2];

figure(2)
clf
for j =1:3
    subplot(1,3,j)
    histogram(data2(j,:),'numbins',20,'normalization','probability')
    
    if j==1
        ylabel('Probability')
        xlabel('Duration (Days)');
    elseif j==2
        xlabel('Final Outbreak Size');
        title({'Histograms Showing the Distribution of the Duration of an outbreak,','Final Outbreak Size, and Number of Farms Infected for K_2'})
    else
        xlabel('Number of Farms Infected');
    end
end

%QUESTION 1(c) - other kernels
%Running again for K1 and K3
para1 = para;
para1.K = K(:,:,1);
para3 = para;
para3.K = K(:,:,3);
for i = 1:1000
    while true
        Classes1(i) = Tauleap_SEIR(para1,ICs,1,maxtime,1);
        if Classes1(i).DetectCaseTime < maxtime
            break;
        end
    end
    while true
        Classes3(i) = Tauleap_SEIR(para3,ICs,1,maxtime,1);
        if Classes3(i).DetectCaseTime < maxtime
            break;
        end
    end
    %We record key details like duration, size of outbreak, and number of
    %farms infected
    duration1(i) = Classes1(i).Duration;
    size1(i) = sum(Classes1(i).R(:,end));
    farmsInf1(i) = sum(Classes1(i).R(:,end)>0);
    totalInf1(:,i) = Classes1(i).R(:,end);
    
    duration3(i) = Classes3(i).Duration;
    size3(i) = sum(Classes3(i).R(:,end));
    farmsInf3(i) = sum(Classes3(i).R(:,end)>0);
    totalInf3(:,i) = Classes3(i).R(:,end);
end

%A plot of the different K functions from x = 0:20

%Calculating K(d) for each K_i
x = 0:0.5:10;
for i = 1:3
    y(:,i) = A(i) * exp(-B(i) * x .* x);
end

%Plotting the graphs
figure(3)
clf
plot(x,y(:,1),x,y(:,2),x,y(:,3));
xlabel('d / km')
ylabel('K(d)')
title('Plot of Each K_i Against Distance')
legend('K_1','K_2','K_3','location','NorthEast')

%Plotting scatter of end of AVERAGE epidemic for each Ki

aveTotalInf(:,1) = sum(totalInf1,2) / 1000;
aveTotalInf(:,2) = sum(totalInf2,2) / 1000;
aveTotalInf(:,3) = sum(totalInf3,2) / 1000;

%Plotting representation of different kernels and spread of outbreak
figure(4)
clf
for j = 1:3
    subplot(1,3,j)
    hold on;
    %Finding which farms are in which interval in terms of number of
    %infected animals
    idxnone = find(aveTotalInf(:,j) == 0);
    idx0 = find(aveTotalInf(:,j) > 0);
    idx2 = find(aveTotalInf(:,j) > 2);
    idx5 = find(aveTotalInf(:,j) > 5);
    idx10 = find(aveTotalInf(:,j) >= 10);
    idx20 = find(aveTotalInf(:,j) >= 20);
    idx50 = find(aveTotalInf(:,j) >= 50);
    idx100 = find(aveTotalInf(:,j) >= 100);
    idx150 = find(aveTotalInf(:,j) >= 150);
    
    %Plotting each farm along with a colour representing the number of
    %infected animals (I+R) on that farm
    h1 = scatter(locations(idxnone,1),locations(idxnone,2),25,[21, 130, 63]./255,'filled');
    h2 = scatter(locations(idx0,1),locations(idx0,2),25,[245,221,66] ./ 255,'filled');
    h3 = scatter(locations(idx2,1),locations(idx2,2),25,[237, 161, 9] ./ 255,'filled');
    h4 = scatter(locations(idx5,1),locations(idx5,2),25,[255, 102, 46] ./ 255,'filled');
    h5 = scatter(locations(idx10,1),locations(idx10,2),25,[196, 45, 45] ./ 255,'filled');
    h6 = scatter(locations(idx20,1),locations(idx20,2),25,[83, 79, 224] ./ 255,'filled');
    h7 = scatter(locations(idx50,1),locations(idx50,2),25,[31, 21, 212] ./ 255,'filled');
    h8 = scatter(locations(idx100,1),locations(idx100,2),25,[122, 12, 166] ./ 255,'filled');
    h9 = scatter(locations(idx150,1),locations(idx150,2),25,'fill','k');
    
    %Plotting the legend
    if j == 1
        legend([h1 h2 h3],'0','1-2','3-5','location','southeast')
        ylabel('y-coordinate');
        title({'','','for K_1'})
    elseif j == 2
        legend([h4 h5 h6],'6-9','10-19','20-49','location','southeast')
        title({'Average Number of Livestock Lost per Farm', 'for a Detected Outbreak with No Control','for K_2'})
        xlabel('x-coordinate');
    else
        legend([h7 h8 h9],'50-99','99-149','150-200','location','southeast')
        title({'','','for K_3'})
    end
end

%Plotting histogram showing results for each Ki
figure(5)
clf
data1 = [duration1; size1; farmsInf1; size1./ 100];
data3 = [duration3; size3; farmsInf3; size3 ./ 100];
data2 = [data2; data2(2,:) ./ 100];


for j =1:4
    subplot(2,2,j)
    hold on;
    %Plotting 3 histograms on top of each other one for each kernel
    histogram(data1(j,:),'numbins',20,'normalization','probability')
    histogram(data2(j,:),'numbins',20,'normalization','probability')
    histogram(data3(j,:),'numbins',20,'normalization','probability')
    
    %Labelling axis and adding a legend
    if j==1
        ylabel('Probability')
        xlabel('Duration (Days)')
        legend('K_1','K_2','K_3','location','northeast')
    elseif j==2
        xlabel('Number of Livestock Lost')
    elseif j == 3
        xlabel('Number of Farms Infected')
        ylabel('Probability')
    else
        xlabel('Percentage of Livestock Infected')
    end
end

%END OF QUESTION 1 - BEGINNING OF QUESTION 2

%QUESTION 2(a)
%We begin by running all 3 Kernels for the other two strategies we have not
%yet run
para1 = para;
para1.K = K(:,:,1);
para2 = para;
para2.K = K(:,:,2);
para3 = para;
para3.K = K(:,:,3);
for i = 1:1000
    %Each while loop insures that we simulate a detected outbreak
    while true
        IP1 = Tauleap_SEIR(para1,ICs,1,maxtime,2);
        %The while loop repeats until we receive a detected outbreak
        if IP1.DetectCaseTime < maxtime
           break; 
        end
    end
    while true
        IP2 = Tauleap_SEIR(para2,ICs,1,maxtime,2);
        if IP2.DetectCaseTime < maxtime
           break; 
        end
    end
    while true
        IP3 = Tauleap_SEIR(para3,ICs,1,maxtime,2);
        if IP3.DetectCaseTime < maxtime
           break; 
        end
    end   
    %We record key details like duration, size of outbreak, and number of
    %farms infected
    IPdur1(i) = IP1.Duration;
    IPsize1(i) = sum(IP1.R(:,end));
    IPdur2(i) = IP2.Duration;
    IPsize2(i) = sum(IP2.R(:,end));
    IPdur3(i) = IP3.Duration;
    IPsize3(i) = sum(IP3.R(:,end));
    
    while true
        RC1 = Tauleap_SEIR(para1,ICs,1,maxtime,3);
        if RC1.DetectCaseTime < maxtime
           break; 
        end
    end   
    while true
        RC2 = Tauleap_SEIR(para2,ICs,1,maxtime,3);
        if RC2.DetectCaseTime < maxtime
           break; 
        end
    end   
    while true
        RC3 = Tauleap_SEIR(para3,ICs,1,maxtime,3);
        if RC3.DetectCaseTime < maxtime
           break; 
        end
    end   
    %We record key details like duration, size of outbreak, and number of
    %farms infected
    RCdur1(i) = RC1.Duration;
    RCsize1(i) = sum(RC1.R(:,end));
    RCdur2(i) = RC2.Duration;
    RCsize2(i) = sum(RC2.R(:,end));
    RCdur3(i) = RC3.Duration;
    RCsize3(i) = sum(RC3.R(:,end));
end

%Storing our data in a matrix for convenience
NCdata = [data1(1,:); data2(1,:);data3(1,:);data1(2,:); data2(2,:);data3(2,:)];
IPdata = [IPdur1; IPdur2; IPdur3; IPsize1; IPsize2; IPsize3];
RCdata = [RCdur1; RCdur2; RCdur3; RCsize1; RCsize2; RCsize3];
%Now to plot our results
figure(6)
clf
for j = 1:6
    subplot(2,3,j)
    hold on;
    %plotting historgrams for each strategy on top of each other to compare
    histogram(NCdata(j,:),'numbins',20,'normalization','probability')
    histogram(IPdata(j,:),'numbins',20,'normalization','probability')
    histogram(RCdata(j,:),'numbins',20,'normalization','probability')
    
    %Labelling axis and adding a legend
    if j== 1 || j == 4
        ylabel('Probability')
        if j==1
            title({'','','for K_1'})
        end
    elseif j == 2
        xlabel('Duration(Days)')
        title({'Histograms Showing the Distribution of the Duration of an outbreak,','Final Outbreak Size, and Number of Farms Infected for each Strategy','for K_2'})
    elseif j==3
        title({'','','for K_3'})
    elseif j == 5
        xlabel('Number of Livestock Lost') 
    elseif j==6
        legend('NC','IP','RC','location','northwest')
    end
end

%Q2(b)

%Create storage matrices of the detected outbreaks (including the same
%number for each strategy). Each columns is a strategy
DurationRank1 = [NCdata(1,:)' IPdata(1,:)' RCdata(1,:)'];
DurationRank2 = [NCdata(2,:)' IPdata(2,:)' RCdata(2,:)'];
DurationRank3 = [NCdata(3,:)' IPdata(3,:)' RCdata(3,:)'];
DeathRank1 = [NCdata(4,:)' IPdata(4,:)' RCdata(4,:)'];
DeathRank2 = [NCdata(5,:)' IPdata(5,:)' RCdata(5,:)'];
DeathRank3 = [NCdata(6,:)' IPdata(6,:)' RCdata(6,:)'];

%Create matrices which denote which strategy is optimal for the different
%objectives
Opt_Duration1 = zeros(1000,3);
Opt_Deaths1=zeros(1000,3);

Opt_Duration2 = zeros(1000,3);
Opt_Deaths2=zeros(1000,3);

Opt_Duration3 = zeros(1000,3);
Opt_Deaths3=zeros(1000,3);
%Update the matrices depending on which strategy minimises each objective
for r=1:1000
    [ix,iy]=min(DurationRank1(r,:));
    Opt_Duration1(r,iy)=1;
    [ix,iy]=min(DeathRank1(r,:));
    Opt_Deaths1(r,iy)=1;
    
    [ix,iy]=min(DurationRank2(r,:));
    Opt_Duration2(r,iy)=1;
    [ix,iy]=min(DeathRank2(r,:));
    Opt_Deaths2(r,iy)=1;
    
    [ix,iy]=min(DurationRank3(r,:));
    Opt_Duration3(r,iy)=1;
    [ix,iy]=min(DeathRank3(r,:));
    Opt_Deaths3(r,iy)=1;
end

%Compute the probability that each strategy is optimal for each objective
%by dividing through by the number of detected outbreaks
Prob_Optimal1(1,:) = sum(Opt_Duration1)./1000;
Prob_Optimal1(2,:) = sum(Opt_Deaths1)./1000;
Prob_Optimal2(1,:) = sum(Opt_Duration2)./1000;
Prob_Optimal2(2,:) = sum(Opt_Deaths2)./1000;
Prob_Optimal3(1,:) = sum(Opt_Duration3)./1000;
Prob_Optimal3(2,:) = sum(Opt_Deaths3)./1000;

%Plot the results in a stacked barplot to show probability each strategy is
%best for each fundamental objective
figure(7)
clf
%Plotting first bar plot for K_1
subplot(1,3,1)
b=bar(Prob_Optimal1,'stacked');

%assigning colours to each portion of the bar plot, for the third portion I
%stuck to the default colour as I was happy with it presentationally
b(1).FaceColor = [233,163,201]./255;
b(2).FaceColor = [161,215,106]./255;

%Labelling barplot
ylabel('Probability optimal')
xticklabels({'Duration','Size'})
title({'','for K_1'});

%Plotting bar plot for K_2
subplot(1,3,2)
b=bar(Prob_Optimal2,'stacked');

%colouring
b(1).FaceColor = [233,163,201]./255;
b(2).FaceColor = [161,215,106]./255;

%Labelling plot
title({'Bar Plot Showing the Probability Each Strategy is Best','for K_2'});
xticklabels({'Duration','Size'})

%Plotting for K_3
subplot(1,3,3)
b=bar(Prob_Optimal3,'stacked');

%Colouring
b(1).FaceColor = [233,163,201]./255;
b(2).FaceColor = [161,215,106]./255;

%Labelling and including a legend
xticklabels({'Duration','Size'})
legend('NC','IP','RC','location','southeast')
title({'','for K_3'});

%Q2(c)
%Calculating expected number of animals lost for each strat
sizeNoAction = (0.25 * sum(size1) + 0.5*sum(size2) + 0.25*sum(size3)) / 1000;
sizeIP = (0.25 * sum(IPsize1) + 0.5*sum(IPsize2) + 0.25*sum(IPsize3))/1000;
sizeRC = (0.25 * sum(RCsize1) + 0.5*sum(RCsize2) + 0.25*sum(RCsize3))/1000;

%Calculating expected duration of outbreak for each strat
durNoAction = (0.25 * sum(duration1) + 0.5*sum(duration2) + 0.25*sum(duration3)) / 1000;
durIP = (0.25 * sum(IPdur1) + 0.5*sum(IPdur2) + 0.25*sum(IPdur3))/1000;
durRC = (0.25 * sum(RCdur1) + 0.5*sum(RCdur2) + 0.25*sum(RCdur3))/1000;

%Converting to a table for ease of access when I need the results
Exptable = array2table([sizeNoAction sizeIP sizeRC; durNoAction durIP durRC]);
Exptable.Properties.VariableNames={'NC','IP','RC'};


%Q2(d)
%We must calculate the expected duration and size for a delay in starting
%by two weeks - ie increase confirmation time to 9 + 14 days
para.ConfTime = 23;
para1 = para;
para2 = para;
para3 = para;
para1.K = K(:,:,1);
para2.K = K(:,:,2);
para3.K = K(:,:,3);

%We want to get 1000 detected outbreaks for each pair of K_j and strategy -
%we don''t need to redo NC as there is no difference to NC regardless of
%delay before acting so can reuse old simulations
for i = 1:1000
    while true
        IP1 = Tauleap_SEIR(para1,ICs,1,maxtime,2);
        if IP1.DetectCaseTime < maxtime
            break;
        end
    end
    while true
        IP2 = Tauleap_SEIR(para2,ICs,1,maxtime,2);
        if IP2.DetectCaseTime < maxtime
            break;
        end
    end
    while true
        IP3 = Tauleap_SEIR(para3,ICs,1,maxtime,2);
        if IP3.DetectCaseTime < maxtime
            break;
        end
    end
    
    while true
        RC1 = Tauleap_SEIR(para1,ICs,1,maxtime,3);
        if RC1.DetectCaseTime < maxtime
            break;
        end
    end
    while true
        RC2 = Tauleap_SEIR(para2,ICs,1,maxtime,3);
        if RC2.DetectCaseTime < maxtime
            break;
        end
    end
    while true
        RC3 = Tauleap_SEIR(para3,ICs,1,maxtime,3);
        if RC3.DetectCaseTime < maxtime
            break;
        end
    end
    %We record key details like duration, size of outbreak, and number of
    %farms infected
    newIPdata(:,i) = [IP1.Duration; IP2.Duration; IP3.Duration; sum(IP1.R(:,end)); sum(IP2.R(:,end)); sum(IP3.R(:,end))];
    newRCdata(:,i) = [RC1.Duration; RC2.Duration; RC3.Duration; sum(RC1.R(:,end)); sum(RC2.R(:,end)); sum(RC3.R(:,end))];
end
newNCdata = NCdata;
%We calculate the average result accross all 1000 simulations
aveIPdata = sum(newIPdata,2) ./1000;
aveRCdata = sum(newRCdata,2) ./1000;
aveNCdata = sum(newNCdata,2) ./1000;

ave = [aveNCdata, aveIPdata, aveRCdata];

%We confirm which strategy we should switch to after two weeks by checking
%which is the optimal strategy
for j =1:6
    [expectation(j),optStrat(j)] = min(ave(j,:));
end

%We calculated our expectation for our Active Adaptive Management
expDur = 0.25 * expectation(1) + 0.5 * expectation(2) + 0.25*expectation(3);
expLoss = 0.25 * expectation(4) + 0.5* expectation(5) + 0.25*expectation(6);