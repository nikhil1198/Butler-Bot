function [ y ] = segment( x )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
double(x);
[m,n]=size(x);


for i=1:1:m
    for j=1:1:n
        if (x(i,j)<=10 )
            
            a1=i-2;
            break;
            
        end
    end
end


for i=1:1:n
    for j=1:1:m
        if (x(j,i)<=10 )
            
            b1=i-2;
            break;
        end
    end
end


for i=m:-1:1
    for j=1:1:n
        if (x(i,j)<=10 )
            
            a2=i+2;
            break;
        end
    end
end


for i=n:-1:1
    for j=1:1:m
        if (x(j,i)<=10 )
            
            b2=i+2;
            break;
        end
    end
end
            
y=zeros(a1-a2+1,b1-b2+1);        

for i=a2:1:a1
    for j=b2:1:b1
        y(i-a2+1,j-b2+1)=x(i,j);
    end
end
% 
% disp(a1);
% disp(a2);
% disp(b1);
% disp(b2);
end

