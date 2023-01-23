function [NewIndex,Days]=GetOrderFiles(TimeArray)

Time=TimeArray(:,2:6);
[~,NewIndex]=sortrows(Time);

Days=unique(Time(NewIndex,3),'stable'); % for days



end