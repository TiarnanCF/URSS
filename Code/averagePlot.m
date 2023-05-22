susAve = permute(residentsAve(1,:,:,:),[3 4 2 1]);
deathAve = permute(sum(residentsAve([10 18],:,:,:),1),[3 4 2 1]);

%First plot the shaded 95% area
figure(9)
for i = 1:countryCount
    subplot(countryCount,1,i)
    hold on;
    x=1:maxtime;
    x2 = [x fliplr(x)];
    y1=quantile(deathAve(:,:,i),[0.975]); %upper CI
    y3=quantile(deathAve(:,:,i),[0.025]); %lower CI
    Shaded = [y3 fliplr(y1)];
    h2=fill(x2, Shaded, 'b','facealpha',0.3,'EdgeColor','none');
    
    %Then plot median line
    h1=plot(x,median(deathAve(:,:,i),1),'b');
    
    if i == 2
        legend([h1 h2],'Median Total Deaths','95% CI Total Deaths','location','northwest')
        ylabel('ROI')
    elseif i==1
        ylabel('GB')
        title('Plot of the Median Total Deaths Over Time with 95% Confidence Intervals')
    else
        xlabel('Time (days)')
        ylabel('NI')
    end
end


