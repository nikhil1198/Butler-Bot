% <-- This function find the centroids of point from a list which are very close to
% each other -->

function [list] = distinctPoint(centroids, leastDist)
list = [];
countCentroids = 1;
[length ~] = size(centroids); 
i=1;
while(i<=length)
    isBreak = false;
    flag = 0;
     a = [];
     count = 1;
     a(1,:) = [centroids(i,1), centroids(i,2)];
     j = i+1;
     while(j<=length)
       d = ((centroids(i,1)-centroids(j,1))^2 + (centroids(i,2)-centroids(j,2))^2)^0.5;
       if(d>leastDist)
           i = j;
           flag = 1;
           break
       else
            count = count+1;
           a(count,:) = [centroids(j,1), centroids(j,2)];
       end
       if(j==length)
isBreak = true;
           [row ~] = size(a);
     if(row>1)
     avg = mean(a);
list(countCentroids,1) = avg(1,1);
list(countCentroids,2) = avg(1,2);
     else
       list(countCentroids,1) = a(1,1);
list(countCentroids,2) = a(1,2);
     end
 end
       j = j+1;
     end
     if(isBreak)
         break
     end
     [row ~] = size(a);
     if(row>1)
     avg = mean(a);
list(countCentroids,1) = avg(1,1);
list(countCentroids,2) = avg(1,2);
     else
       list(countCentroids,1) = a(1,1);
list(countCentroids,2) = a(1,2);
     end
countCentroids = countCentroids + 1;
if(flag == 0)
i =i+1;
end
 end
end