function [ p,q,r ] = normal( a,b,x,y )
%normal Summary of this function goes here
%   Detailed explanation goes here

if( a==0 && b~=0)
    q=0;r=-x;p=1;
    
elseif( b==0 && a~=0)
    p=0;q=1;r=-y;
else
    p=-b/a;q=1;r=-p*x-y;
end
end

