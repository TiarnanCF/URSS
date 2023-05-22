susceptibles = permute(residents(1,:,:),[2 3 1]);
allInfGroups = permute(sum(residents([2 3 4 5 6 9],:,:),1),[2 3 1]);
partialImmune = permute(sum(residents([7 8 11 12 13 14 15 16 17],:,:),1), [2 3 1]);
deathGroup = permute(sum(residents([10 18],:,:),1),[2 3 1]);
sympInf = permute(sum(residents([3 5],:,:),1),[2 3 1]);
asympInf = permute(sum(residents([4 6],:,:),1),[2 3 1]);
hospInf = permute(sum(residents([9 17],:,:),1),[2 3 1]);
detAsmp = permute(sum(residents(6,:,:),1),[2 3 1]);
detSym = permute(sum(residents([3 5 9],:,:),1),[2 3 1]);

deathGroup2 = permute(sum(residents2([10 18],:,:),1),[2 3 1]);

figure(2)
tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    plot(1:maxtime,susceptibles(i,:),1:maxtime,allInfGroups(i,:),1:maxtime,partialImmune(i,:),1:maxtime,deathGroup(i,:))
    if i == 2
        legend('Susceptible','Infectious','Immune Group', 'Deaths','location','eastoutside')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Distribution of Population Between Susecptible, Infectious, and Immune Classes')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end

figure(3)
tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    plot(1:maxtime,Classes.vaccLeft(i,:),1:maxtime,Classes.vaccSupply(i,:))
    if i == 2
        legend('Vaccine Supply','Total Vaccines in Country','location','eastoutside')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Plot of Vaccine Supply and Vaccines Available Over Time')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end

figure(4)
tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    hold on;
    x=1:maxtime;
    x2 = [x fliplr(x)];
    Shaded = [zeros(1,maxtime) .* max([max(sympInf(i,:) + hospInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(allInfGroups(i,:))])  fliplr(Classes.lockdown(i,:)) .* max([max(sympInf(i,:) + hospInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(allInfGroups(i,:))])];
    h1 = fill(x2, Shaded, 'r','facealpha',0.3,'EdgeColor','none');
    
    h2 = plot(1:maxtime,sympInf(i,:) + hospInf(i,:),1:maxtime,asympInf(i,:),1:maxtime,allInfGroups(i,:));
    plot([vaccStart vaccStart],[0 max([max(sympInf(i,:) + hospInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(allInfGroups(i,:))])],'--k')
    if i == 2
        legend(h2,'Symptomatic','Asymptomatic','Both','location','eastoutside')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Plot of Symptomatic and Asymptomatic Cases Over Time')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end

figure(5)
tiledlayout(2,1, 'TileSpacing', 'compact')
nexttile
hold on;
x1=1:maxtime;
x2 = [x fliplr(x)];
Shaded = [zeros(1,maxtime) .* max(hospInf(i,:))./ populations(i)  fliplr(Classes.lockdown(i,:)) .* max(hospInf(i,:))./ populations(i)];
h1 = fill(x2, Shaded, 'r','facealpha',0.3,'EdgeColor','none');

for i = 1:countryCount
    hold on;
    h(i) =plot(1:maxtime,hospInf(i,:) ./ populations(i));
end
plot([vaccStart vaccStart],[0 max(hospInf(i,:))./ populations(i)],'--k')

legend(h,'GB','ROI','NI','location','eastoutside')
ylabel('Hospitalisations per Person')
title('Plot of the Hospitalisations per Person Over Time')

nexttile
hold on;
x1=1:maxtime;
x2 = [x fliplr(x)];
Shaded = [zeros(1,maxtime) .* max(deathGroup(i,:) ./ populations(i))  fliplr(Classes.lockdown(i,:)) .* max(deathGroup(i,:) ./ populations(i))];
h1 = fill(x2, Shaded, 'r','facealpha',0.3,'EdgeColor','none');

for i = 1:countryCount
    hold on;
    plot(1:maxtime,deathGroup(i,:) ./ populations(i))
end

plot([vaccStart vaccStart],[0 max(hospInf(i,:) ./ populations(i))],'--k')

ylabel('Deaths per Person')
xlabel('Time (days)')
title('Plot of the Deaths per Person Over Time')

figure(6)
tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    hold on;
    x=1:maxtime;
    x2 = [x fliplr(x)];
    Shaded = [zeros(1,maxtime) .* max([max(sympInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(deathGroup(i,:))])  fliplr(Classes.lockdown(i,:)) .* max([max(sympInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(deathGroup(i,:))])];
    h1 = fill(x2, Shaded, 'r','facealpha',0.3,'EdgeColor','none');
    h2 = plot(1:maxtime,sympInf(i,:),1:maxtime,asympInf(i,:),1:maxtime,hospInf(i,:),1:maxtime,deathGroup(i,:));
    plot([vaccStart vaccStart],[0 max([max(sympInf(i,:)), max(asympInf(i,:)), max(hospInf(i,:)), max(deathGroup(i,:))])],'--k')
    if i == 2
        legend(h2, 'Symptomatic','Asymptomatic','Hospitalised','Dead','location','eastoutside')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Plot of the Symptomatic Classes Over Time')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end

figure(7)
tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
for i = 1:countryCount
    nexttile
    hold on;
    x=1:maxtime;
    x2 = [x fliplr(x)];
    Shaded = [zeros(1,maxtime) .* max([max(deathGroup(i,:)), max(deathGroup2(i,:))])  fliplr(Classes.lockdown(i,:)) .* max([max(deathGroup(i,:)), max(deathGroup2(i,:))])];
    h1 = fill(x2, Shaded, 'r','facealpha',0.3,'EdgeColor','none');
    
    h2 = plot(1:maxtime,deathGroup(i,:),1:maxtime,deathGroup2(i,:));
    
    plot([vaccStart vaccStart],[0 max([max(deathGroup(i,:)), max(deathGroup2(i,:))])],'--k')
    if i == 2
        legend(h2,'Lockdown','No Lockdown','location','eastoutside')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Plot of the Total Deaths Over Time With and Without Lockdowns')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end

