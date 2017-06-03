function[sortRefCoord] = arrange(refCoord)
a = mean(refCoord);
cx = a(1);
cy = a(2);
sortRefCoord = zeros(4,2);
if(refCoord(1,1) < cx && refCoord(1,2) < cy)
    sortRefCoord(1,:) = refCoord(1,:);
end
if(refCoord(2,1) < cx && refCoord(2,2) < cy)
    sortRefCoord(1,:) = refCoord(2,:);
end
if(refCoord(3,1) < cx && refCoord(3,2) < cy)
    sortRefCoord(1,:) = refCoord(3,:);
end
if(refCoord(4,1) < cx && refCoord(4,2) < cy)
    sortRefCoord(1,:) = refCoord(4,:);
end

if(refCoord(1,1) > cx && refCoord(1,2) < cy)
    sortRefCoord(2,:) = refCoord(1,:);
end
if(refCoord(2,1) > cx && refCoord(2,2) < cy)
    sortRefCoord(2,:) = refCoord(2,:);
end
if(refCoord(3,1) > cx && refCoord(3,2) < cy)
    sortRefCoord(2,:) = refCoord(3,:);
end
if(refCoord(4,1) > cx && refCoord(4,2) < cy)
    sortRefCoord(2,:) = refCoord(4,:);
end

if(refCoord(1,1) > cx && refCoord(1,2) > cy)
    sortRefCoord(3,:) = refCoord(1,:);
end
if(refCoord(2,1) > cx && refCoord(2,2) > cy)
    sortRefCoord(3,:) = refCoord(2,:);
end
if(refCoord(3,1) > cx && refCoord(3,2) > cy)
    sortRefCoord(3,:) = refCoord(3,:);
end
if(refCoord(4,1) > cx && refCoord(4,2) > cy)
    sortRefCoord(3,:) = refCoord(4,:);
end

if(refCoord(1,1) < cx && refCoord(1,2) > cy)
    sortRefCoord(4,:) = refCoord(1,:);
end
if(refCoord(2,1) < cx && refCoord(2,2) > cy)
    sortRefCoord(4,:) = refCoord(2,:);
end
if(refCoord(3,1) < cx && refCoord(3,2) > cy)
    sortRefCoord(4,:) = refCoord(3,:);
end
if(refCoord(4,1) < cx && refCoord(4,2) > cy)
    sortRefCoord(4,:) = refCoord(4,:);
end