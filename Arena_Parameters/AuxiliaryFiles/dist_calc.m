function dist = dist_calc(T1,T2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dist=sqrt(sum((T1-T2).^2,2));

end

