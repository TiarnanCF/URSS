setUp

% econBase = median(touristGain .* sum(visitorsBase,2) .* ones(1,21) - sum(lockdownAveBase,2) .* (0:0.05:1).* populations',3);
% econAve1 = median(touristGain .* sum(visitors1,2) .* ones(1,21) - sum(lockdownAve1,2) .* (0:0.05:1).* populations',3);
% econAve2 = median(touristGain .* sum(visitors2,2) .* ones(1,21) - sum(lockdownAve2,2) .* (0:0.05:1).* populations',3);
% econAve3 = median(touristGain .* sum(visitors3,2).* ones(1,21) - sum(lockdownAve3,2) .* (0:0.05:1).* populations',3);
% econAve4 = median(touristGain .* sum(visitors4,2).* ones(1,21) - sum(lockdownAve4,2) .* (0:0.05:1).* populations',3);
% econAve5 = median(touristGain .* sum(visitors5,2) .* ones(1,21) - sum(lockdownAve5,2) .* (0:0.05:1).* populations',3);
% 
% % figure(1)
% % tiledlayout(countryCount,1)
% % nexttile
% % b=bar(probOptimalTot(:,:),'stacked');
% % xticklabels({'Deaths','Economy'})
% % %assigning colours to each portion of the bar plot, for the third portion I
% % %stuck to the default colour as I was happy with it presentationally
% % b(1).FaceColor = color(1,:);
% % b(2).FaceColor = color(6,:);
% % b(3).FaceColor = color(3,:);
% % b(4).FaceColor = color(2,:);
% % b(5).FaceColor = color(4,:);
% % title({'Bar Graph Showing the Proportion of Times','Each Strategy is Optimum'})
% % ylabel({'100,000',''})
% % 
% % figure(1)
% % nexttile
% % b=bar(probOptimalTot(:,:),'stacked');
% % xticklabels({'Deaths','Economy'})
% % %assigning colours to each portion of the bar plot, for the third portion I
% % %stuck to the default colour as I was happy with it presentationally
% % b(1).FaceColor = color(1,:);
% % b(2).FaceColor = color(6,:);
% % b(3).FaceColor = color(3,:);
% % b(4).FaceColor = color(2,:);
% % b(5).FaceColor = color(4,:);
% % legend('Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')
% % ylabel({'500,000','Vaccines/Month'})
% % 
% % figure(1)
% % nexttile
% % b=bar(probOptimalTot(:,:),'stacked');
% % xticklabels({'Deaths','Economy'})
% % %assigning colours to each portion of the bar plot, for the third portion I
% % %stuck to the default colour as I was happy with it presentationally
% % b(1).FaceColor = color(1,:);
% % b(2).FaceColor = color(6,:);
% % b(3).FaceColor = color(3,:);
% % b(4).FaceColor = color(2,:);
% % b(5).FaceColor = color(4,:);
% % ylabel({'5,000,000',''})
% 
% figure(1)
% hold on;
% plot(1:length(vaccSupply),median(vaccSupply - vaccLeft1),'color',color(1,:))
% plot(1:length(vaccSupply),median(vaccSupply - vaccLeft2),'color',color(2,:))
% plot(1:length(vaccSupply),median(vaccSupply - vaccLeft3),'color',color(3,:))
% plot(1:length(vaccSupply),median(vaccSupply - vaccLeft4),'color',color(4,:))
% plot(314:length(vaccSupply),35714.*(0:length(vaccSupply)-314))
% %plot(314:length(vaccSupply),sum(populations .* vaccRate).*(0:length(vaccSupply)-314))
% 
% figure(2)
% tiledlayout(1,countryCount, 'TileSpacing', 'compact')
% 
% for i=1:countryCount    
%     nexttile
%     hold on;
%     plot((0:0.05:1),econBase(i,:),'color',color(6,:))
%     plot((0:0.05:1),econAve1(i,:),'color',color(1,:))
%     plot((0:0.05:1),econAve2(i,:),'color',color(2,:))
%     plot((0:0.05:1),econAve3(i,:),'color',color(3,:))
%     plot((0:0.05:1),econAve4(i,:),'color',color(4,:))
% end



% %Running Rep Simulation
% set(gca,'fontsize',20)
% set(0,'defaultaxesfontsize',20)
% set(0,'defaultlinelinewidth',2)
% numIts = 1;
% baseSimulation
% TotalVaccinesMonthly = 500000;
% simulations
% 
% deathsAve1 = permute(sum(residentsAve1([10 18],:,:,:),1),[3 4 2 1]);
% deathsAve2 = permute(sum(residentsAve2([10 18],:,:,:),1),[3 4 2 1]);
% deathsAve3 = permute(sum(residentsAve3([10 18],:,:,:),1),[3 4 2 1]);
% deathsAve4 = permute(sum(residentsAve4([10 18],:,:,:),1),[3 4 2 1]);
% deathsAve5 = permute(sum(residentsAve5([10 18],:,:,:),1),[3 4 2 1]);
% deathsAve6 = permute(sum(residentsAve6([10 18],:,:,:),1),[3 4 2 1]);
% deathsAveBase = permute(sum(residentsAveBase([10 18],:,:,:),1),[3 4 2 1]);
% 
% figure(1)
% tiledlayout(countryCount,1, 'TileSpacing', 'compact')
% for i = 1:countryCount
%     nexttile
%     
%     hold on;
%     x=0:maxtime-1;
%     
%     x2 = [x fliplr(x)];
%     scaler = max([deathsAve1(:,end,i) deathsAve2(:,end,i) deathsAve3(:,end,i) deathsAve4(:,end,i)])./10000;
%     Shaded = [zeros(1,maxtime) fliplr(lockdownAve4(i,:)) .* (scaler /5)];
%     h = fill(x2, Shaded, color(4,:),'facealpha',0.3,'EdgeColor','none');
%     
%     Shaded = [lockdownAve2(i,:).* (scaler /5)  fliplr(lockdownAve2(i,:)) .* (scaler *2/5)];
%     h = fill(x2, Shaded, color(2,:) ,'facealpha',0.3,'EdgeColor','none');
%     
%     Shaded = [lockdownAve3(i,:).* (scaler * 2/5) fliplr(lockdownAve3(i,:)) .* (scaler * 3/5)];
%     h = fill(x2, Shaded, color(3,:),'facealpha',0.3,'EdgeColor','none');
% 
%     Shaded = [lockdownAve6(i,:) .* (scaler * 3/5) fliplr(lockdownAve6(i,:)) .* (scaler * 4/5)];
%     h = fill(x2, Shaded, color(6,:),'facealpha',0.3,'EdgeColor','none');
%     
%     Shaded = [lockdownAve1(i,:) .* (scaler * 4/5) fliplr(lockdownAve1(i,:)) .* scaler];
%     h = fill(x2, Shaded, color(1,:),'facealpha',0.3,'EdgeColor','none');
%     
%     %Then plot median line
%     h1=plot(x,deathsAve1(:,:,i)./10000,'color',color(1,:));
%     
%     %Then plot median line
%     h3=plot(x,deathsAve2(:,:,i)./10000,'color',color(2,:));
% 
%     %Then plot median line
%     h5=plot(x,deathsAve3(:,:,i)./10000,'color',color(3,:));
%     
%     %Then plot median line
%     h7=plot(x,deathsAve4(:,:,i)./10000,'color',color(4,:));
%     
%     %Then plot median line
%     h10=plot(x,deathsAve6(:,:,i)./10000,'color',color(6,:));
%     
%     %Then plot median line
%     h9=plot(x,deathsAve5(:,:,i)./10000,'color',color(5,:));
%     
%     %Then plot median line
%     h11=plot(x,deathsAveBase(:,:,i)./10000,'color',color(7,:));
%     
%     plot([vaccStart-1 vaccStart-1],[0 max([max(deathsAve1(:,:,i)),max(deathsAve2(:,:,i)),max(deathsAve3(:,:,i)),max(deathsAve4(:,:,i))]./10000)],'--k')
%     
%     if i == 2
%         ylabel('ROI')
%         legend([h11 h9 h1 h10 h5 h3 h7],'No Vaccination','Limitless Supply','GB Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','eastoutside')
%     elseif i==1
%         ylabel('GB')
%         title({'Plot of the Total Deaths Over Time','in Tens of Thousands'})
%     else
%         ylabel('NI')
%         xlabel('Days')
%     end
% end

