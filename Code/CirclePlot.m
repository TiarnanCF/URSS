figure(1)
clf
hold on;
for i=100:500
    for j=1:countryCount
        subplot(1,countryCount,j)
        pie(sum(Classes.country(:,:,j,i),2),{'S','E','I_S','I_A','I_{SD}','I_{AD}','R','E','H','D','V','E','I_S','I_A','I_{SD}','I_{AD}','H','D'})
    end
    pause(0.0001)
end