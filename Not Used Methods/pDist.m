function [d] = pDist(point, line)
vect = point - line(1,:);
d = cross(vect, line(2,:))/sqrt(line(2,1)^2 + line(2,2)^2 + line(2,3)^2);
end