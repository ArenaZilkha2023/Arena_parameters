classdef MissingWhite
    %Read list of white circles without rfid identification. And insert into the original data 
    
    properties
        Number_Mouse;
        AntennaCoord;
    end
    
    methods
         function [ArrayXM,ArrayYM,Index]=FindMissingWhite(obj,Timeline,RepeatedFrames,TimeMissingFile,CoordMissingFile)
          
            %% Go through the file with the position of the white
              
             Number_Mouse=obj.Number_Mouse;
            ArrayXM=cell(size(Timeline,1),Number_Mouse);
            ArrayYM =cell(size(Timeline,1),Number_Mouse);
            
             TimeMissingFile= TimeMissingFile(~cellfun('isempty',TimeMissingFile)); %remove empty spaces
             %retain only the dates which looks as dates.
             IndexTime=find(~cellfun(@isempty,strfind(TimeMissingFile,':')));
             
             TimeMissingNumber=datenum(TimeMissingFile(IndexTime),'HH:MM:SS.FFF');
             TimeMissingNumber=TimeMissingNumber';
             TimelineNumber=datenum(Timeline,'HH:MM:SS.FFF');
             
             
             Index=find(ismember( TimelineNumber,TimeMissingNumber)==1);%look for index in the original time
             IndexMissing=find(ismember(TimeMissingNumber,TimelineNumber(Index))==1);%look for the index in the missing correspond to the time considered
             
             % %Find the index of the coordinates which aren't in the original file
             %if there is a NaN in the excel files
              ArrayXM(Index,:)=(CoordMissingFile(IndexMissing,1:2:(2*Number_Mouse)));
             ArrayYM(Index,:)=(CoordMissingFile(IndexMissing,2:2:(2*Number_Mouse)));
            
%Add the repeats
     %find  upper bounding
     UB=bsxfun(@gt,RepeatedFrames,Index');
       UB=num2cell(UB,1);
       Upperlimit=cellfun(@Find_Upper,UB,'UniformOutput',false);
       Upperlimit=[Upperlimit{1,:}];
       RepeatUpper=RepeatedFrames( Upperlimit');
       
       %find  lower bounding
     LB=bsxfun(@le,RepeatedFrames,Index');
        LB=num2cell(LB,1);
       Lowerlimit=cellfun(@Find_Lower,LB,'UniformOutput',false);
       Lowerlimit=[Lowerlimit{1,:}];
        RepeatLower=RepeatedFrames( Lowerlimit');
      
       for i=1:length(RepeatLower)-1
           
        L= RepeatUpper(i,1)- RepeatLower(i,1); 
      ArrayXM(RepeatLower(i,1):RepeatUpper(i,1)-1,:)=repmat(ArrayXM(Index(i,1),:),L,1);
        ArrayYM(RepeatLower(i,1):RepeatUpper(i,1)-1,:)= repmat(ArrayYM(Index(i,1),:),L,1);  
       end
        
         end
        
        
        
        
        
    end
    
end

%% %% -------------------------------Auxiliary functions---------------------------------------------
% 
function bound=Find_Upper(x)

bound=find(x==1,1,'first');

end

function bound=Find_Lower(x)

bound=find(x==1,1,'last');

end


%% 

% function Irepeated=FindRepeatedFrames(Index,ArrayXM,ArrayYM,RepeatedFrames,L)
% 
% if ~isempty(find(RepeatedFrames==Index))
%     Ii=Index;
%     
%     if (find(RepeatedFrames==Index)+1)<=L %far from the file finish
%     Ifinal=RepeatedFrames(find(RepeatedFrames==Index)+1);
%     Irepeat=[Ii Ifinal];
%     else
%          Irepeat=[Ii Ii ];
%     end
%   else
%     Ii=RepeatedFrames(find((RepeatedFrames-Index)<0,1,'last'));
%     Ifinal=RepeatedFrames(find((RepeatedFrames-Index)>0,1,'first'));
%      Irepeat=[Ii Ifinal];
% end
%   for o=[Irepeat(1):Irepeat(2)]
%          ArrayXM(o,:)=ArrayXM(Index,:);
%          ArrayYM(o,:)=ArrayYM(Index,:);
%     end

% end




















% function [ArrayXM,ArrayYM]=Read_File_With_White(ArrayXM,ArrayYM,TimeMissingFile,CoordMissingFile,Timeline,Number_Mouse,RepeatedFrames)
% %Note about variables - ArrayX must be a column for each mouse 
% %-RFID_Mouse include a column with rfid identity of each mouse 
% 
% 
% try
% %Look for the exact time
% Index=find(datenum(Timeline,'HH:MM:SS.FFF')==datenum(TimeMissingFile,'HH:MM:SS.FFF'));
% catch
%    return; %in  the case the date is not in the correct format
%     
% end
% % %Find the index of the coordinates which aren't in the original file
% try %if there is a NaN in the excel files
% Xblank=cell2mat(CoordMissingFile(1:2:(2*Number_Mouse)));
% Yblank=cell2mat(CoordMissingFile(2:2:(2*Number_Mouse)));
% catch
% return
% end
% 
% %remove NAN
% Xblank=Xblank(1:find(isnan(Xblank)==1,1,'first')-1);
% Yblank=Yblank(1:find(isnan(Yblank)==1,1,'first')-1);
% 
% %add repeats
%     Irepeat=FindRepeatedFrames(Index,RepeatedFrames,size(Timeline,1));
%     
%     for o=[Irepeat(1):Irepeat(2)];
%          ArrayXM(o,1:length(Xblank))=Xblank;
%          ArrayYM(o,1:length(Yblank))=Yblank;
%     end
%   
%    
%    
% 
% 
% 
% end
% 
% %% Auxiliary function to find the repeated frames related to a given index
% 

% 
% %% ---------------Find duplicates----------
% 
% % function [IndexDuplicate CoordDuplicate]=Find_Duplicates(X,Y,Xblank,Yblank)
% % IndexDuplicate=[];
% % CoordDuplicate=[];
% % 
% % [~,indX]=unique(X,'stable');
% % duplicate_indX=setdiff(1:size(X,2),indX);
% % 
% % [~,indY]=unique(Y,'stable');
% % duplicate_indY=setdiff(1:size(Y,2),indY);
% % 
% % if ~isempty(duplicate_indX)
% % %Find the duplicates in the list with white positions
% % 
% % IndexDuplicateReal=find((ismember(X(duplicate_indX),Xblank)& ismember(Y(duplicate_indY),Yblank))==1); %the duplicate must be in xblank this is for avoiding the non undefined positions
% % 
% % if ~isempty(IndexDuplicateReal)
% %     
% % IndexDuplicate=duplicate_indX(IndexDuplicateReal);
% % CoordDuplicate=[(X(IndexDuplicate))' (Y(IndexDuplicate))'];%to be included in the list
% % end
% % end
% % 
% % 
% % end
% % 
% % %% 
% % function [ID ,Coord]=Find_ID_For_Position(New_Coord,IndexMouse,RFID,AntennaCoord)
% % 
% %        for i=1:size(New_Coord,1)
% %            RFIDN=str2num(char(RFID(IndexMouse)));
% %           distancia=Calc_dist(New_Coord(i,:),AntennaCoord(RFIDN,:));
% %            
% %           %Find minimum distance for each antenna
% %          [M,I]=min(distancia); %should be a unique value
% %          ID(i)=IndexMouse(I);
% %          Coord(i,:)=New_Coord(i,:);
% %            
% %        end
% % 
% % 
% % 
% % 
% % 
% % 
% % end
% % %% 
% % function distancia=Calc_dist(coord,MatrixRFID)
% % 
% %   distancia=sqrt(sum((repmat(coord,size(MatrixRFID,1),1)-MatrixRFID).^2,2));
% % 
% % 
% % 
% % end
% % 
% % 
