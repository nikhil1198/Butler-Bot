% <--    This function find the angle between two line which passes through
% points present in firstLine and secondLine array -->

function [angle] = findAngleVect(vect1, vect2)

dp = (dot(vect1, vect2));

% compute vector lengths
length1 = sqrt(sum(vect1.^2));
length2 = sqrt(sum(vect2.^2));

% obtain the smaller angle of intersection in degrees
angle = acos(dp/(length1*length2))*180/pi;
