susAve1 = permute(residentsAve1(5,:,:,:),[3 4 2 1]);
susAve2 = permute(residentsAve2(5,:,:,:),[3 4 2 1]);
susAve3 = permute(residentsAve3(5,:,:,:),[3 4 2 1]);
susAve4 = permute(residentsAve4(5,:,:,:),[3 4 2 1]);
susAve5 = permute(residentsAve5(5,:,:,:),[3 4 2 1]);
susAve6 = permute(residentsAve6(5,:,:,:),[3 4 2 1]);
susAveBase = permute(residentsAveBase(5,:,:,:),[3 4 2 1]);

deathsAve1 = permute(sum(residentsAve1([10 18],:,:,:),1),[3 4 2 1]);
deathsAve2 = permute(sum(residentsAve2([10 18],:,:,:),1),[3 4 2 1]);
deathsAve3 = permute(sum(residentsAve3([10 18],:,:,:),1),[3 4 2 1]);
deathsAve4 = permute(sum(residentsAve4([10 18],:,:,:),1),[3 4 2 1]);
deathsAve5 = permute(sum(residentsAve5([10 18],:,:,:),1),[3 4 2 1]);
deathsAve6 = permute(sum(residentsAve6([10 18],:,:,:),1),[3 4 2 1]);
deathsAveBase = permute(sum(residentsAveBase([10 18],:,:,:),1),[3 4 2 1]);

deathsTot1 = sum(deathsAve1,3);
deathsTot2 = sum(deathsAve2,3);
deathsTot3 = sum(deathsAve3,3);
deathsTot4 = sum(deathsAve4,3);
deathsTot5 = sum(deathsAve5,3);
deathsTot6 = sum(deathsAve6,3);
deathsTotBase = sum(deathsAveBase,3);

% figure(15)
% tiledlayout(countryCount,1, 'TileSpacing', 'compact')
% for i = 1:countryCount
%     nexttile
%     x=1:maxtime;
%     %Then plot median line
%     
%     hold on;
%     x=1:maxtime;
%     x2 = [x fliplr(x)];
%     scaler = max([max(median(susAve1(:,:,i))), max(median(susAve2(:,:,i))), max(median(susAve3(:,:,i))), max(median(susAve4(:,:,i)))]);
%     Shaded = [zeros(1,maxtime) fliplr(lockdown1(i,:)) .* (scaler /4)];
%     h = fill(x2, Shaded, color(1,:),'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown2(i,:) == 1)) = 1;
%     Shaded = [test.* (scaler/4)  fliplr(lockdown2(i,:)) .* (scaler /2)];
%     h = fill(x2, Shaded, color(2,:),'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown3(i,:) == 1)) = 1;
%     Shaded = [test.* (scaler/2) fliplr(lockdown3(i,:)) .* (scaler * 3/4)];
%     h = fill(x2, Shaded, color(3,:),'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown4(i,:) == 1)) = 1;
%     Shaded = [test .* (scaler * 3/4) fliplr(lockdown4(i,:)) .* scaler];
%     h = fill(x2, Shaded, color(4,:),'facealpha',0.3,'EdgeColor','none');
%     
%     
%     
%     h1=plot(x,median(susAve1(:,:,i),1),'color',color(1,:));
%     
%     
%     %Then plot median line
%     h3=plot(x,median(susAve2(:,:,i),1),'color',color(2,:));
%     
% 
%     %Then plot median line
%     h5=plot(x,median(susAve3(:,:,i),1),'color',color(3,:));
%     
%     %Then plot median line
%     h7=plot(x,median(susAve4(:,:,i),1),'color',color(4,:));
%     
%     %Then plot median line
%     h10=plot(x,median(susAve6(:,:,i),1),'color',color(6,:));
%     
%     %Then plot median line
%     h9=plot(x,median(susAve5(:,:,i),1),'color',color(5,:));
%     
%     %Then plot median line
%     h11=plot(x,median(susAveBase(:,:,i),1),'color',color(7,:));
%     
%     plot([vaccStart vaccStart],[0 max([max(median(susAve1(:,:,i))),max(median(susAve2(:,:,i))),max(median(susAve3(:,:,i))),max(median(susAve4(:,:,i)))])],'--k')
%     if i == 2
%         ylabel('ROI')
%     elseif i==1
%         ylabel('GB')
%         title('Plot of the Median Symptomatics Over Time')
%     else
%         legend([h11 h9 h1 h10 h5 h3 h7],'No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','southoutside')
%         ylabel('NI')
%     end
%     
% end
% % nexttile
% % title('Plot of the Vaccines Available Over Time')
% % hold on;
% % plot(x,median(vaccLeft1,1),'color',color(1,:))
% % plot(x,median(vaccLeft2,1),'color',color(2,:))
% % plot(x,median(vaccLeft3,1),'color',color(3,:))
% % plot(x,median(vaccLeft4,1),'color',color(4,:))
% % plot(x,vaccSupply);
% 
% % h1 = plot([vaccStart vaccStart],[0 vaccSupply(end)],'--k');
% % legend('Britain Hoards','Divided Proportionally','NI Hoards','Divided Equally','Total Vaccines','location','eastoutside')
% % 
% % xlabel('Time (days)')
% % title('Vaccine Supply for Each Strategy')
% 
% 
% 
% figure(16)
% tiledlayout(countryCount+1,1, 'TileSpacing', 'compact')
% for i = 1:countryCount
%     nexttile
%     
%     hold on;
%     x=0:maxtime-1;
%     
%     x2 = [x fliplr(x)];
%     scaler = max([median(deathsAve1(:,end,i)) median(deathsAve2(:,end,i)) median(deathsAve3(:,end,i)) median(deathsAve4(:,end,i))]);
%     Shaded = [zeros(1,maxtime) fliplr(lockdown1(i,:)) .* (scaler /4)];
%     h = fill(x2, Shaded, color(1,:),'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown2(i,:) == 1)) = 1;
%     Shaded = [test.* (scaler/4)  fliplr(lockdown2(i,:)) .* (scaler /2)];
%     h = fill(x2, Shaded, color(2,:) ,'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown3(i,:) == 1)) = 1;
%     Shaded = [test.* (scaler/2) fliplr(lockdown3(i,:)) .* (scaler * 3/4)];
%     h = fill(x2, Shaded, color(3,:),'facealpha',0.3,'EdgeColor','none');
%     
%     test = zeros(1,maxtime);
%     test(find(lockdown4(i,:) == 1)) = 1;
%     Shaded = [test .* (scaler * 3/4) fliplr(lockdown4(i,:)) .* scaler];
%     h = fill(x2, Shaded, color(4,:),'facealpha',0.3,'EdgeColor','none');
%     
%     %Then plot median line
%     h1=plot(x,median(deathsAve1(:,:,i),1),'color',color(1,:));
%     
%     %Then plot median line
%     h3=plot(x,median(deathsAve2(:,:,i),1),'color',color(2,:));
% 
%     %Then plot median line
%     h5=plot(x,median(deathsAve3(:,:,i),1),'color',color(3,:));
%     
%     %Then plot median line
%     h7=plot(x,median(deathsAve4(:,:,i),1),'color',color(4,:));
%     
%     %Then plot median line
%     h10=plot(x,median(susAve6(:,:,i),1),'color',color(6,:));
%     
%     %Then plot median line
%     h9=plot(x,median(deathsAve5(:,:,i),1),'color',color(5,:));
%     
%     %Then plot median line
%     h11=plot(x,median(deathsAveBase(:,:,i),1),'color',color(7,:));
%     
%     plot([vaccStart vaccStart],[0 max([max(median(deathsAve1(:,:,i))),max(median(deathsAve2(:,:,i))),max(median(deathsAve3(:,:,i))),max(median(deathsAve4(:,:,i)))])],'--k')
%     
%     if i == 2
%         legend([h11 h9 h1 h10 h5 h3 h7],'No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','southoutside')
%         ylabel('ROI')
%     elseif i==1
%         ylabel('GB')
%         title('Plot of the Median Total Deaths Over Time')
%     else
%         ylabel('NI')
%     end
% end
% 
% nexttile
% title('Plot of the Vaccines Available Over Time')
% hold on;
% plot(x,median(vaccLeft1,1),'color',color(1,:))
% plot(x,median(vaccLeft2,1),'color',color(2,:))
% plot(x,median(vaccLeft3,1),'color',color(3,:))
% plot(x,median(vaccLeft4,1),'color',color(4,:))
% plot(x,vaccSupply);
% 
% h1 = plot([vaccStart vaccStart],[0 vaccSupply(end)],'--k');
% legend('Britain Hoards','Divided Proportionally','NI Hoards','Divided Equally','Total Vaccines','location','eastoutside')
% 
% xlabel('Time (days)')
% title('Vaccine Supply for Each Strategy')
% 
% 
% 
% figure(17)
% hold on;
% x=0:maxtime-1;
% %Then plot median line
% h1=plot(x,median(deathsTot1(:,:),1),'color',color(1,:));
%         
% %Then plot median line
% h3=plot(x,median(deathsTot2(:,:),1),'color',color(2,:));
% 
% %Then plot median line
% h5=plot(x,median(deathsTot3(:,:),1),'color',color(3,:));
%     
% %Then plot median line
% h7=plot(x,median(deathsTot4(:,:),1),'color',color(4,:));
% 
% %Then plot median line
% h10=plot(x,median(susAve6(:,:,i),1),'color',color(6,:));
%     
% %Then plot median line
% h9=plot(x,median(deathsTot5(:,:),1),'color',color(5,:));
%     
% %Then plot median line
% h11=plot(x,median(deathsTotBase(:,:),1),'color',color(7,:));
%     
% 
% plot([vaccStart vaccStart],[0 max([median(deathsTot1(:,end),1) median(deathsTot2(:,end),1) median(deathsTot3(:,end),1) median(deathsTot4(:,end),1)])],'--k')
% 
% legend([h11 h9 h1 h10 h5 h3 h7],'No Vaccination','Limitless Supply','Britain Hoards','ROI Hoards','NI Hoards','Divided Proportionally','Divided Equally','location','southoutside')
% title('Plot of the Median Total Deaths Over Time')
% xlabel('Time (days)')
