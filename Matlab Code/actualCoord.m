function [list] = actualCoord(coord, refCoord, row, dim1,dim2)
list = zeros(row, 2);
for i=1:row
    [c1, c2] = coordinates(refCoord(1,1), refCoord(1,2), refCoord(2,1), refCoord(2,2), refCoord(3,1), refCoord(3,2), refCoord(4,1), refCoord(4,2), coord(i,1), coord(i,2), dim1,dim2);
    list(i,1) = c1;
    list(i,2) = c2;
end
end