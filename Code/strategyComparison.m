%HISTOGRAM
figure(18)
clf

econBase = permute(touristGain .* sum(visitorsBase,2) - sum(lockdownAveBase,2) .* lockdownLoss.* populations',[1 3 2]);
econAve1 = permute(touristGain .* sum(visitors1,2) - sum(lockdownAve1,2) .* lockdownLoss.* populations',[1 3 2]);
econAve2 = permute(touristGain .* sum(visitors2,2) - sum(lockdownAve2,2) .* lockdownLoss.* populations',[1 3 2]);
econAve3 = permute(touristGain .* sum(visitors3,2) - sum(lockdownAve3,2) .* lockdownLoss.* populations',[1 3 2]);
econAve4 = permute(touristGain .* sum(visitors4,2) - sum(lockdownAve4,2) .* lockdownLoss.* populations',[1 3 2]);
econAve5 = permute(touristGain .* sum(visitors5,2) - sum(lockdownAve5,2) .* lockdownLoss.* populations',[1 3 2]);
econAve6 = permute(touristGain .* sum(visitors6,2) - sum(lockdownAve6,2) .* lockdownLoss.* populations',[1 3 2]);

tiledlayout(2,countryCount, 'TileSpacing', 'compact')
for i=1:countryCount
    nexttile
    hold on;
    histogram(deathsAveBase(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(7,:))
    histogram(deathsAve5(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(5,:))
    
    histogram(deathsAve1(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(1,:))
    histogram(deathsAve6(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(6,:))
    histogram(deathsAve3(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(3,:))
    
    histogram(deathsAve2(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(2,:))
    histogram(deathsAve4(:,731,i),'numbins',20,'normalization','probability','FaceColor',color(4,:))
    
    
    if i==2
        title({'Histograms Showing the Distribution of Total Deaths for each Strategy','In ROI'})
        xlabel('Deaths')
    elseif i ==3
        title({'','in NI'})
        legend('No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')
    else
        title({'','in Britain'})
        ylabel('Probability')
    end

end

for i=1:countryCount
    nexttile
    hold on;
    histogram(econBase(i,:),'numbins',20,'normalization','probability','FaceColor',color(7,:))
    histogram(econAve5(i,:),'numbins',20,'normalization','probability','FaceColor',color(5,:))
    
    histogram(econAve1(i,:),'numbins',20,'normalization','probability','FaceColor',color(1,:))
    histogram(econAve6(i,:),'numbins',20,'normalization','probability','FaceColor',color(6,:))
    histogram(econAve3(i,:),'numbins',20,'normalization','probability','FaceColor',color(3,:))

    histogram(econAve2(i,:),'numbins',20,'normalization','probability','FaceColor',color(2,:))
    histogram(econAve4(i,:),'numbins',20,'normalization','probability','FaceColor',color(4,:))

    if i==2
        title({'Histograms Showing the Distribution of Total Revenue for each Strategy','In ROI'})
        xlabel('Revenue')
    elseif i ==3
        title({'','in NI'})
        legend('No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')
    else
        title({'','in Britain'})
        ylabel('Probability')
    end
end


%STACKED BAR CHARTS

%Create storage matrices of the detected outbreaks (including the same
%number for each strategy). Each columns is a strategy
deathRank = [deathsAve1(:,731,:) deathsAve6(:,731,:) deathsAve3(:,731,:) deathsAve2(:,731,:) deathsAve4(:,731,:)];
econRank = [permute(econAve1, [2 3 1]) permute(econAve6, [2 3 1]) permute(econAve3, [2 3 1]) permute(econAve2, [2 3 1]) permute(econAve4, [2 3 1])];

%Create matrices which denote which strategy is optimal for the different
%objectives
optEcon = zeros(numIts,5,3);
optDeath =zeros(numIts,5,3);

%Update the matrices depending on which strategy minimises each objective
for r=1:numIts
    [ix,iy1]=min(deathRank(r,:,1));
    [ix,iy2]=min(deathRank(r,:,2));
    [ix,iy3]=min(deathRank(r,:,3));
    optDeath(r,iy1,1)=1;
    optDeath(r,iy2,2)=1;
    optDeath(r,iy3,3)=1;
    
    [ix,iy1]=max(econRank(r,:,1));
    [ix,iy2]=max(econRank(r,:,2));
    [ix,iy3]=max(econRank(r,:,3));
    optEcon(r,iy1,1)=1;
    optEcon(r,iy2,2)=1;
    optEcon(r,iy3,3)=1;

end

%Compute the probability that each strategy is optimal for each objective
%by dividing through by the number of detected outbreaks
probOptimal(1,:,:) = sum(optDeath,1)./numIts;
probOptimal(2,:,:) = sum(optEcon,1)./numIts;

%Plot the results in a stacked barplot to show probability each strategy is
%best for each fundamental objective
figure(19)
clf
%Plotting first bar plot for K_1
tiledlayout(1,countryCount, 'TileSpacing', 'compact')
for i=1:countryCount
    nexttile
    b=bar(probOptimal(:,:,i),'stacked');
    xticklabels({'Deaths','Economy'})
    %assigning colours to each portion of the bar plot, for the third portion I
    %stuck to the default colour as I was happy with it presentationally
    b(1).FaceColor = color(1,:);
    b(2).FaceColor = color(6,:);
    b(3).FaceColor = color(3,:);
    b(4).FaceColor = color(2,:);
    b(5).FaceColor = color(4,:);
    
    if i==2
        title({'Bar Graph Showing the Proportion of Times Each Strategy is Optimum','For ROI'})
        xlabel('Revenue')
    elseif i ==3
        title({'','for NI'})
    else
        title({'','for Britain'})
        ylabel('Proportion')
    end
end
legend('Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')

figure(20)
tiledlayout(2,1, 'TileSpacing', 'compact')
nexttile
hold on;

histogram(sum(deathsAveBase(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(7,:))
histogram(sum(deathsAve5(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(5,:))

histogram(sum(deathsAve1(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(1,:))
histogram(sum(deathsAve6(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(6,:))
histogram(sum(deathsAve3(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(3,:))

histogram(sum(deathsAve2(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(2,:))
histogram(sum(deathsAve4(:,731,:),3),'numbins',20,'normalization','probability','FaceColor',color(4,:))
title('Histograms Showing the Distribution of Total Deaths for each Strategy')
xlabel('Deaths')
ylabel('Probability')
legend('No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')

nexttile
hold on;
histogram(sum(econBase,1),'numbins',20,'normalization','probability','FaceColor',color(7,:))
histogram(sum(econAve5,1),'numbins',20,'normalization','probability','FaceColor',color(5,:))

histogram(sum(econAve1,1),'numbins',20,'normalization','probability','FaceColor',color(1,:))
histogram(sum(econAve6,1),'numbins',20,'normalization','probability','FaceColor',color(6,:))
histogram(sum(econAve3,1),'numbins',20,'normalization','probability','FaceColor',color(3,:))

histogram(sum(econAve2,1),'numbins',20,'normalization','probability','FaceColor',color(2,:))
histogram(sum(econAve4,1),'numbins',20,'normalization','probability','FaceColor',color(4,:))
title('Histograms Showing the Distribution of Total Revenue for each Strategy')
xlabel('Revenue')
ylabel('Probability')
legend('No Vaccination','Limitless Supply','Britain Hoards','Divided Proportionally','NI Hoards','Divided Equally','location','eastoutside')
legend('No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')
%STACKED BAR CHARTS

%Create storage matrices of the detected outbreaks (including the same
%number for each strategy). Each columns is a strategy
deathRankTot = [sum(deathsAve1(:,731,:),3) sum(deathsAve6(:,731,:),3) sum(deathsAve3(:,731,:),3) sum(deathsAve2(:,731,:),3) sum(deathsAve4(:,731,:),3)];
econRankTot = [sum(permute(econAve1, [2 3 1]),3) sum(permute(econAve6, [2 3 1]),3) sum(permute(econAve3, [2 3 1]),3) sum(permute(econAve2, [2 3 1]),3) sum(permute(econAve4, [2 3 1]),3)];

%Create matrices which denote which strategy is optimal for the different
%objectives
optEcon = zeros(numIts,5);
optDeath =zeros(numIts,5);

%Update the matrices depending on which strategy minimises each objective
for r=1:numIts
    [ix,iy]=min(deathRankTot(r,:));
    optDeath(r,iy)=1;
    
    [ix,iy]=max(econRankTot(r,:));
    optEcon(r,iy)=1;

end

%Compute the probability that each strategy is optimal for each objective
%by dividing through by the number of detected outbreaks
probOptimalTot(1,:) = sum(optDeath,1)./numIts;
probOptimalTot(2,:) = sum(optEcon,1)./numIts;

%Plot the results in a stacked barplot to show probability each strategy is
%best for each fundamental objective
figure(21)
clf
%Plotting first bar plot for K_1
b=bar(probOptimalTot(:,:),'stacked');
xticklabels({'Deaths','Economy'})
%assigning colours to each portion of the bar plot, for the third portion I
%stuck to the default colour as I was happy with it presentationally
b(1).FaceColor = color(1,:);
b(2).FaceColor = color(6,:);
b(3).FaceColor = color(3,:);
b(4).FaceColor = color(2,:);
b(5).FaceColor = color(4,:);
title({'Bar Graph Showing the Proportion of Times', 'Each Strategy is Optimal'})
ylabel('Proportion')
legend('Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')

figure(22)
tiledlayout(2,countryCount, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    boxplot(deathRank(:,:,i),'Labels',{'Britain Hoards','ROI Hoards','NI Hoards','Proportional','Equal'})
    if i==2
        title({'Boxplots Showing the Distribution of Total Deaths for each Strategy','In ROI'})
    elseif i ==3
        title({'','in NI'})
    else
        title({'','in Britain'})
        ylabel('Deaths')
    end

end

for i = 1:countryCount
    nexttile
    boxplot(econRank(:,:,i),'Labels',{'Britain Hoards','ROI Hoards','NI Hoards','Proportional','Equal'})
    if i==2
        title({'Boxplots Showing the Distribution of Revenue for each Strategy','In ROI'})
    elseif i ==3
        title({'','in NI'})
    else
        title({'','in Britain'})
        ylabel('Revenue')
    end
end