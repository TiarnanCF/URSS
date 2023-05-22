clear
set(gca,'fontsize',20)
set(0,'defaultaxesfontsize',20)
set(0,'defaultlinelinewidth',2)
close all

scenario = [100000 500000 1000000 5000000];
setUp
baseSimulation

for thisCount=1:length(scenario)
    %Based on vaccines given daily in all 3 countries
    TotalVaccinesMonthly = scenario(thisCount);
    simulations
    saveData
end
%lockdownFinder
%plotSimulations
%strategyComparison