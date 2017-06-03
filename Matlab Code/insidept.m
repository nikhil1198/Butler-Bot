function [ d ] = insidept( x,y,dimx,dimy,squarefact )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a=(x-squarefact)*(y-squarefact)*(x-(dimx-squarefact))*(y-(dimy-squarefact)));

if(a<0)
    d=-1;
else
    d=1;
end
end

