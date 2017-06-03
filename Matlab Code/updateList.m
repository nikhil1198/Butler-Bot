function [listRedUp, listGreenUp] = updateList(listRed,listGreen)
listRedUp = zeros(2,2);
listGreenUp = zeros(2,2);
listRedUp(1,:) = listRed;

d1= dist(listGreen(1,:),listGreen(2,:));
d2= dist(listGreen(1,:),listGreen(3,:));
d3= dist(listGreen(2,:),listGreen(3,:));

least = min([d1, d2, d3]);

if(least==d1)
    listRedUp(2,:)=listGreen(3,:);
    listGreenUp(1,:) = listGreen(1,:);
    listGreenUp(2,:) = listGreen(2,:);
elseif(least==d2)
     listRedUp(2,:)=listGreen(2,:);
    listGreenUp(1,:) = listGreen(1,:);
    listGreenUp(2,:) = listGreen(3,:);
else
     listRedUp(2,:)=listGreen(1,:);
    listGreenUp(1,:) = listGreen(3,:);
    listGreenUp(2,:) = listGreen(2,:);
end
end
