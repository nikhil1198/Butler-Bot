function [ numb ] = textrec(test)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% functions used - segment(),InvertIm()

% z9=imread('9.bmp');
% z8=imread('8.bmp');
% z7=imread('7.bmp');
% z6=imread('6.bmp');
% z5=imread('5.bmp');
% z4=imread('4.bmp');
z3=imread('3.bmp');
z2=imread('2.bmp');
z1=imread('1.bmp');
% z0=imread('0.bmp');


% img={z0,z1,z2,z3,z4,z5,z6,z7,z8,z9};
img={z1,z2,z3};
reso = [100 70];
for i=1:1:3
  
    img{i}=rgb2gray(img{i});
    img{i}=segment(img{i});
    img{i}=imresize(img{i},[reso(1) reso(2)]);
end

m=reso(1);
n=reso(2);

%test=imread('three.jpg');
test=imadjust(test,[0.95 0.95 0.95 ; 1 1 1 ]);   %change the range according to situation
%imtool(test);
test=InvertIm(test);   %as we are using white text and black background
%test=rgb2gray(test);


test=im2bw(test);
test=test.*255;
%imtool(test);
test=segment(test);
test=imresize(test,[reso(1) reso(2)]);
%imtool(test);


for i=1:1:3
    img{i}=test.*img{i};
   img{i}=img{i}./255;
end

s=zeros(1,3);


for i=1:1:3
    for j=1:1:m
    
        for k=1:1:n/2
            l=img{i}(j,k);
            l=double(l);
           
            s(1,i)=s(1,i)+l;
    
        end
    end
end

max=s(1,1);
k=1;
for i=1:1:3
    if(s(1,i)>=max)
        max=s(1,i);
        k=i;
    end
end

numb = k;   % detected number

%fprintf('\n  The number is %i\n',numb);


end

