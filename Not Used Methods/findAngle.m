% <--    This function find the angle between two line which passes through
% points present in firstLine and secondLine array -->

function [angle] = findAngle(firstLine, secondLine)
ab1x = (firstLine(1,1)-firstLine(2,1));
ab1y = (firstLine(1,2)-firstLine(2,2));
ab2x = (secondLine(1,1)-secondLine(2,1));
ab2y = (secondLine(1,2)-secondLine(2,2));
vect1 = [ab1x ab1y]; % create a vector based on the line equation
vect2 = [ab2x ab2y];
dp = (dot(vect1, vect2));

% compute vector lengths
length1 = sqrt(sum(vect1.^2));
length2 = sqrt(sum(vect2.^2));

% obtain the smaller angle of intersection in degrees
angle = acos(dp/(length1*length2))*180/pi;
