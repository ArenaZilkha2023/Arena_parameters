classdef Hiding
    %Find hiding box with the antenna
    
    properties
     AntennaNumber ;  
     AntennaHidingBox ;  
     CoordinateX;
     CoordinateY;
     HidingCoord ;  
     InHidingBox;  
     TimeHiding;
     HidingBox;
     
    end
    
    methods
        %%---------------- Find where is hiding and assign 1-find according to antenna and by assuming that there are not coordinates values
         function IsHiding=IsHiding(obj)
%        
          X=obj.CoordinateX;
          Y=obj.CoordinateY;
          xv=obj.HidingCoord(:,1);
          yv=obj.HidingCoord(:,2);
         %Find inside hiding box without borders
           %% For the first hiding box
                         [ins1,on1]=inpolygon(X,1139-Y,[xv(1:4,1);xv(1,1)],[1139-yv(1:4,1);1139-yv(1,1)]);
                          in1=ins1 ;
                        %% For the second hiding box
                        [ins2,on2]=inpolygon(X,1139-Y,[xv(5:8,1);xv(5,1)],[1139-yv(5:8,1);1139-yv(5,1)]);
                          in2=ins2 ;
                     %% For the third hiding box
                        [ins3,on3]=inpolygon(X,1139-Y,[xv(9:12,1);xv(9,1)],[1139-yv(9:12,1);1139-yv(9,1)]);
                        in3=ins3 ;
                     %% For the four hiding box
                        [ins4,on4]=inpolygon(X,1139-Y,[xv(13:16,1);xv(13,1)],[1139-yv(13:16,1);1139-yv(13,1)]);
                         in4=ins4 ;
          
          %% 

            IsHiding=(in1|in2|in3|in4);


            
          end   
          %% 
          %%----------- Find the intervals frames for hiding-----------
          function  IsHidingInterval=IsHidingInterval(obj,IsHiding)
                 
               [EventsBeg EventsEnd]=getEventsIndexesGV(IsHiding,length(IsHiding));  
               IsHidingInterval=[EventsBeg EventsEnd];
              
          end
        
          %%    %% -----------find the number of hiding box per interval------------
             %since in a same interval there could be different antenna
             %for-Perhaps in the FUTURE
             %the same hiding box we are doing a mean and find the exact cage
             
             function IsHidingCage=IsHidingCage(obj,HidingInterval)
                
                 IsHidingCage=zeros(size(obj.CoordinateX,1),1);
                 for i=1:length(HidingInterval(:,1))
                   
                        X=obj.CoordinateX;
                        Y=obj.CoordinateY;
                        xv=obj.HidingCoord(:,1);
                        yv=obj.HidingCoord(:,2);
                        
                        Xh=X(HidingInterval(i,1):HidingInterval(i,2),1);
                        Yh=Y(HidingInterval(i,1):HidingInterval(i,2),1);
         
                        %% For the first hiding box
                         [ins1,on1]=inpolygon(Xh,1139-Yh,[xv(1:4,1);xv(1,1)],[1139-yv(1:4,1);1139-yv(1,1)]);
                         
%                           figure
%                         plot([xv(13:16,1);xv(13,1)],[1139-yv(13:16,1);1139-yv(13,1)],'-')
                         
                         
                          in1=ins1;
                        %% For the second hiding box
                        [ins2,on2]=inpolygon(Xh,1139-Yh,[xv(5:8,1);xv(5,1)],[1139-yv(5:8,1);1139-yv(5,1)]);
                          in2=ins2;
                     %% For the third hiding box
                        [ins3,on3]=inpolygon(Xh,1139-Yh,[xv(9:12,1);xv(9,1)],[1139-yv(9:12,1);1139-yv(9,1)]);
                        in3=ins3;
                     %% For the four hiding box
                        [ins4,on4]=inpolygon(Xh,1139-Yh,[xv(13:16,1);xv(13,1)],[1139-yv(13:16,1);1139-yv(13,1)]);
                         in4=ins4;
                     
                     
                     if any(in1)
                         
                         IsHidingCage(HidingInterval(i,1):HidingInterval(i,2),1)=1;
                     elseif any(in2)
                          IsHidingCage(HidingInterval(i,1):HidingInterval(i,2),1)=2;
                     elseif any(in3)
                          IsHidingCage(HidingInterval(i,1):HidingInterval(i,2),1)=3;
                     elseif any(in4)
                          IsHidingCage(HidingInterval(i,1):HidingInterval(i,2),1)=4;
                          
                     end
                         
                          
                          
                         
                     
                     
                     
                     
                     
        
                   
                     
                 end
                 
                 
             end
             
             
             %%       %% ------change the coordinates of the hiding to the position of the entrance to the hiding box---------
             
             function IsHidingCoord=IsHidingCoord(obj,IsHidingInterval,IsHidingCage)
                 clear X
                 clear Y
                 X=obj.CoordinateX;
                 Y=obj.CoordinateY;
                 X=cell2mat(X);
                 Y=cell2mat(Y);
                for i=1:length(IsHidingInterval(:,1))
                   clear ReferenceCage 
                   ReferenceCage=IsHidingCage(IsHidingInterval(i,1)); 
                   X(IsHidingInterval(i,1):IsHidingInterval(i,2))=obj.HidingCoord(ReferenceCage,1); %for the x  
                   Y(IsHidingInterval(i,1):IsHidingInterval(i,2))=obj.HidingCoord(ReferenceCage,2); %for the y   
                    
                end
                 IsHidingCoord=[X,Y];
                 
                 
                 
             end
             
          
        
        
        
        
        
        
    end
    
end
%% %% AUXILIARY FUNCTIONS
function [EventsBeg EventsEnd]=getEventsIndexesGV(IndLogical,n)

EventsBeg=find(diff(IndLogical)==1)+1;
EventsEnd=find(diff(IndLogical)==-1);

if isempty(EventsBeg)||isempty(EventsEnd)
    if(isempty(EventsBeg)&&~isempty(EventsEnd))
        EventsBeg=[1;EventsBeg];
    elseif(isempty(EventsEnd)&&~isempty(EventsBeg))
        EventsEnd=[EventsEnd;n];
    else
        if sum(IndLogical)==n
            EventsBeg=1;
            EventsEnd=n;
        end
    end
else
    if(EventsBeg(1)>EventsEnd(1))
        EventsBeg=[1;EventsBeg];
    end
    
    if(EventsBeg(end)>EventsEnd(end))
        EventsEnd=[EventsEnd;n];
    end
end

end
%% %% 
function result=NumberConversion(x)
result=str2num(x);

end

