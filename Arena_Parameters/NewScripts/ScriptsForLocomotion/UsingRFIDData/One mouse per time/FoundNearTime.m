function result = FoundNearTime( x)
global SubsetRFIDDataTime

%% convert time into number
xTime=datevec( x,'HH:MM:SS.FFF');
TimeDif=abs(etime(SubsetRFIDDataTime,repmat(xTime,size(SubsetRFIDDataTime,1),1)));
%find the nearest time of rfid to frame video
MinimumTime=min(TimeDif);

result=find(TimeDif==MinimumTime);
result=result(1);

end

