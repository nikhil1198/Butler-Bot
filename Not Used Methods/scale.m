function [out] = scale(x , a, b, max, min)
out = (a-b)(x-min)/(max-min);
