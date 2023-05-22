lockdownStart1 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd1 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownStart2 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd2 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownStart3 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd3 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownStart4 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd4 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownStart5 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd5 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownStart6 = ones(numIts,maxtime,countryCount) .* (maxtime+1);
lockdownEnd6 = ones(numIts,maxtime,countryCount) .* (maxtime+1);

j =1;
for k=1:countryCount
    for i =1:numIts
        lockdownStart1(i,j,k) = find(lockdownAve1(k,:,i),1,'first');
        lockdownEnd1(i,j,k) = find(lockdownAve1(k,lockdownStart1(i,j,k)+1:end,i)==0,1,'first') + lockdownStart1(i,j,k) -1;
        lockdownStart2(i,j,k) = find(lockdownAve2(k,:,i),1,'first');
        lockdownEnd2(i,j,k) = find(lockdownAve2(k,lockdownStart2(i,j,k)+1:end,i)==0,1,'first') + lockdownStart2(i,j,k) -1;
        lockdownStart3(i,j,k) = find(lockdownAve3(k,:,i),1,'first');
        lockdownEnd3(i,j,k) = find(lockdownAve3(k,lockdownStart3(i,j,k)+1:end,i)==0,1,'first') + lockdownStart3(i,j,k) -1;
        lockdownStart4(i,j,k) = find(lockdownAve4(k,:,i),1,'first');
        lockdownEnd4(i,j,k) = find(lockdownAve4(k,lockdownStart4(i,j,k)+1:end,i)==0,1,'first') + lockdownStart4(i,j,k) -1;
        lockdownStart5(i,j,k) = find(lockdownAve5(k,:,i),1,'first');
        lockdownEnd5(i,j,k) = find(lockdownAve5(k,lockdownStart5(i,j,k)+1:end,i)==0,1,'first') + lockdownStart5(i,j,k) -1;
        lockdownStart6(i,j,k) = find(lockdownAve6(k,:,i),1,'first');
        lockdownEnd6(i,j,k) = find(lockdownAve6(k,lockdownStart6(i,j,k)+1:end,i)==0,1,'first') + lockdownStart5(i,j,k) -1;
    end
end

for k=1:countryCount
    for i =1:numIts
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve1(k,lockdownEnd1(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart1(i,j,k) = newpos + lockdownEnd1(i,j-1,k);
            newpos = find(lockdownAve1(k,lockdownStart1(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd1(i,j,k) = maxtime;
                break
            end
            
            lockdownEnd1(i,j,k) =  newpos + lockdownStart1(i,j,k) -1;
        end
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve2(k,lockdownEnd2(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart2(i,j,k) = newpos + lockdownEnd2(i,j-1,k);
            
            newpos = find(lockdownAve2(k,lockdownStart2(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd2(i,j,k) = maxtime;
                break
            end
            lockdownEnd2(i,j,k) = newpos + lockdownStart2(i,j,k) -1;
        end
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve3(k,lockdownEnd3(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart3(i,j,k) = newpos + lockdownEnd3(i,j-1,k);
            
            newpos = find(lockdownAve3(k,lockdownStart3(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd3(i,j,k) = maxtime;
                break
            end
            lockdownEnd3(i,j,k) = newpos + lockdownStart3(i,j,k) -1;
        end
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve4(k,lockdownEnd4(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart4(i,j,k) = newpos + lockdownEnd4(i,j-1,k);
            
            newpos = find(lockdownAve4(k,lockdownStart4(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd4(i,j,k) = maxtime;
                break
            end
            lockdownEnd4(i,j,k) = newpos + lockdownStart4(i,j,k) -1;
        end
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve5(k,lockdownEnd5(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart5(i,j,k) = newpos + lockdownEnd5(i,j-1,k);
            
            newpos = find(lockdownAve5(k,lockdownStart5(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd5(i,j,k) = maxtime;
                break
            end
            lockdownEnd5(i,j,k) = newpos + lockdownStart5(i,j,k) -1;
        end
        j=1;
        while true
            j=j+1;
            newpos = find(lockdownAve6(k,lockdownEnd6(i,j-1,k)+1:end,i),1,'first');
            if isempty(newpos)
                break
            end
            lockdownStart6(i,j,k) = newpos + lockdownEnd6(i,j-1,k);
            
            newpos = find(lockdownAve6(k,lockdownStart6(i,j,k)+1:end,i)==0,1,'first');
            if isempty(newpos)
                lockdownEnd6(i,j,k) = maxtime;
                break
            end
            lockdownEnd6(i,j,k) = newpos + lockdownStart6(i,j,k) -1;
        end
        
    end
end

lockdownStart1 = permute(round(sum(lockdownStart1,1) ./ numIts),[3 2 1]);
lockdownStart2 = permute(round(sum(lockdownStart2,1) ./ numIts),[3 2 1]);
lockdownStart3 = permute(round(sum(lockdownStart3,1) ./ numIts),[3 2 1]);
lockdownStart4 = permute(round(sum(lockdownStart4,1) ./ numIts),[3 2 1]);
lockdownStart5 = permute(round(sum(lockdownStart5,1) ./ numIts),[3 2 1]);
lockdownStart6 = permute(round(sum(lockdownStart6,1) ./ numIts),[3 2 1]);
lockdownEnd1 = permute(round(sum(lockdownEnd1,1) ./ numIts),[3 2 1]);
lockdownEnd2 = permute(round(sum(lockdownEnd2,1) ./ numIts),[3 2 1]);
lockdownEnd3 = permute(round(sum(lockdownEnd3,1) ./ numIts),[3 2 1]);
lockdownEnd4 = permute(round(sum(lockdownEnd4,1) ./ numIts),[3 2 1]);
lockdownEnd5 = permute(round(sum(lockdownEnd5,1) ./ numIts),[3 2 1]);
lockdownEnd6 = permute(round(sum(lockdownEnd6,1) ./ numIts),[3 2 1]);


lockdown1 = zeros(3,maxtime);
for i = find(lockdownStart1(1,:) <= maxtime)
    lockdown1(1,lockdownStart1(1,i):min([lockdownEnd1(1,i),maxtime])) = 1;
end
for i = find(lockdownStart1(2,:) <= maxtime)
    lockdown1(2,lockdownStart1(2,i):min([lockdownEnd1(2,i),maxtime])) = 1;
end
for i = find(lockdownStart1(3,:) <= maxtime)
    lockdown1(3,lockdownStart1(3,i):min([lockdownEnd1(3,i),maxtime])) = 1;
end

lockdown2 = zeros(3,maxtime);
for i = find(lockdownStart2(1,:) <= maxtime)
    lockdown2(1,lockdownStart2(1,i):min([lockdownEnd2(1,i),maxtime])) = 1;
end
for i = find(lockdownStart2(2,:) <= maxtime)
    lockdown2(2,lockdownStart2(2,i):min([lockdownEnd2(2,i),maxtime])) = 1;
end
for i = find(lockdownStart2(3,:) <= maxtime)
    lockdown2(3,lockdownStart2(3,i):min([lockdownEnd2(3,i),maxtime])) = 1;
end

lockdown3 = zeros(3,maxtime);
for i = find(lockdownStart3(1,:) <= maxtime)
    lockdown3(1,lockdownStart3(1,i):min([lockdownEnd3(1,i),maxtime])) = 1;
end
for i = find(lockdownStart3(2,:) <= maxtime)
    lockdown3(2,lockdownStart3(2,i):min([lockdownEnd3(2,i),maxtime])) = 1;
end
for i = find(lockdownStart3(3,:) <= maxtime)
    lockdown3(3,lockdownStart3(3,i):min([lockdownEnd3(3,i),maxtime])) = 1;
end

lockdown4 = zeros(3,maxtime);
for i = find(lockdownStart4(1,:) <= maxtime)
    lockdown4(1,lockdownStart4(1,i):min([lockdownEnd4(1,i),maxtime])) = 1;
end
for i = find(lockdownStart4(2,:) <= maxtime)
    lockdown4(2,lockdownStart4(2,i):min([lockdownEnd4(2,i),maxtime])) = 1;
end
for i = find(lockdownStart4(3,:) <= maxtime)
    lockdown4(3,lockdownStart4(3,i):min([lockdownEnd4(3,i),maxtime])) = 1;
end

lockdown5 = zeros(3,maxtime);
for i = find(lockdownStart5(1,:) <= maxtime)
    lockdown5(1,lockdownStart5(1,i):min([lockdownEnd5(1,i),maxtime])) = 1;
end
for i = find(lockdownStart5(2,:) <= maxtime)
    lockdown5(2,lockdownStart5(2,i):min([lockdownEnd5(2,i),maxtime])) = 1;
end
for i = find(lockdownStart5(3,:) <= maxtime)
    lockdown5(3,lockdownStart5(3,i):min([lockdownEnd5(3,i),maxtime])) = 1;
end

lockdown6 = zeros(3,maxtime);
for i = find(lockdownStart6(1,:) <= maxtime)
    lockdown6(1,lockdownStart6(1,i):min([lockdownEnd6(1,i),maxtime])) = 1;
end
for i = find(lockdownStart6(2,:) <= maxtime)
    lockdown6(2,lockdownStart6(2,i):min([lockdownEnd6(2,i),maxtime])) = 1;
end
for i = find(lockdownStart6(3,:) <= maxtime)
    lockdown6(3,lockdownStart6(3,i):min([lockdownEnd6(3,i),maxtime])) = 1;
end