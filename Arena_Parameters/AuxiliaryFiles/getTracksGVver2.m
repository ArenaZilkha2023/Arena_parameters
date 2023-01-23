function positionMat=getTracksGVver2(num)

series=3:size(num,2);
j=1;
for i=series
    positionMat(:,j)=num{i};
    j=j+1;
end
end