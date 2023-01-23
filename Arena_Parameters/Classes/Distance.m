function Distance = Distance( X,Y )
Distance=sqrt(sum([diff(X) diff(Y)].^2,2))


end

