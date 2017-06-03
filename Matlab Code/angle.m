function [ d,x,v ] = angle1( a,b )
%angle Summary of this function goes here
%   Detailed explanation goes here

v=cross(a,b);
c=dot(a,b);
l1=sqrt((a(1,1))^2+(a(1,2))^2);
l2=sqrt((b(1,1))^2+(b(1,2))^2);

x=(180/pi)*acos((c/(l1*l2)));



if(v(3)<0)
    d=-1;
else
    d=1;
end

end

