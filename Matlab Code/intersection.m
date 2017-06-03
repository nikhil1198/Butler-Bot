function [ x,y ] = intesection( a,b,c,p,q,r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x=(r*b-q*c)/(a*q-p*b);
y=(a*r-c*p)/(b*p-a*q);
end

