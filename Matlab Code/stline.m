function [ a,b,c ] = stline( x1,y1,x2,y2 )
%stline Summary of this function goes here
% returns a,b,c of ax+by+c=0
%   Detailed explanation goes here

a=(y2-y1);
b=(x1-x2);
c=(x2-x1)*y2-x2*(y2-y1);

end

