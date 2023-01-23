classdef MissingWhite
    %Read list of white circles without rfid identification. And insert into the original data 
    
    properties
        Number_Mouse;
        AntennaCoord;
    end
    
    methods
         function [ArrayX,ArrayY]=FindMissingWhite(obj,Timeline,ArrayX,ArrayY,RepeatedFrames,TimeMissingFile,CoordMissingFile,ArrayRFID)
          
            %% Go through the file with the position of the white
              
             Number_Mouse=obj.Number_Mouse;
             AntennaCoord=obj.AntennaCoord;
             
             TimeMissingFile= TimeMissingFile(~cellfun('isempty',TimeMissingFile)); %remove empty spaces
%              for t=1:length(TimeMissingFile)
            for t=1:6000
            t
               
             [ArrayX,ArrayY]=Read_File_With_White(TimeMissingFile(t),CoordMissingFile(t,:),Timeline,ArrayX,ArrayY,Number_Mouse,ArrayRFID,AntennaCoord,RepeatedFrames);
             
             
             end
             
             
             
         end
        
        
        
        
        
    end
    
end

%% %% -------------------------------Auxiliary functions---------------------------------------------
function [ArrayX,ArrayY,Index]=Read_File_With_White(TimeMissingFile,CoordMissingFile,Timeline,ArrayX,ArrayY,Number_Mouse,ArrayRFID,AntennaCoord,RepeatedFrames)
%Note about variables - ArrayX must be a column for each mouse 
%-RFID_Mouse include a column with rfid identity of each mouse 
New_Coord=[];
IndexMouse_NoPosition=[];
X=[];
Y=[];
IndexC=[];

try
%Look for the exact time
Index=find(datenum(Timeline,'HH:MM:SS.FFF')==datenum(TimeMissingFile,'HH:MM:SS.FFF'));
catch
   return; %in  the case the date is not in the correct format
    
end
% %Find the index of the coordinates which aren't in the original file
try %if there is a NaN in the excel files
Xblank=cell2mat(CoordMissingFile(1:2:(2*Number_Mouse)));
Yblank=cell2mat(CoordMissingFile(2:2:(2*Number_Mouse)));
catch
return
end

%remove NAN
Xblank=Xblank(1:find(isnan(Xblank)==1,1,'first')-1);
Yblank=Yblank(1:find(isnan(Yblank)==1,1,'first')-1);

X=ArrayX(Index,:);
Y=ArrayY(Index,:);

%Find the coordinates which miss the mouse identity. Find which indices of Xblank /Yblank aren't in the original array
IndexC=~(ismember(Xblank,ArrayX(Index,:))& ismember(Yblank,ArrayY(Index,:))); 

if any(IndexC)%if non zero elements
New_Coord=[(Xblank(IndexC))',(Yblank(IndexC))'];

%Find the mice with non defined position.Find which position doesn't appear
%in the white mice position list

IndexMouse_NoPosition=find(~(ismember(ArrayX(Index,:),Xblank)& ismember(ArrayY(Index,:),Yblank))==1);



end
%Find the duplicates of the original coordinates coordinates

[IndexDuplicate CoordDuplicate]=Find_Duplicates(X,Y,Xblank,Yblank);

%add the duplicates as not defined positions

if ~isempty(IndexDuplicate)
New_Coord=[New_Coord; CoordDuplicate];
IndexMouse_NoPosition=[IndexMouse_NoPosition';IndexDuplicate']; 
end

%% found RFID information
if ~isempty(IndexMouse_NoPosition)
    if length(unique(ArrayRFID(Index,IndexMouse_NoPosition)))==length(ArrayRFID(Index,IndexMouse_NoPosition)) %this means different antenna for each unknown position
 [ID ,Coord]=Find_ID_For_Position(New_Coord,IndexMouse_NoPosition,ArrayRFID(Index,:),AntennaCoord); %Found the Mouse Id with the repective coordinate
   ArrayX(Index,ID)=(Coord(:,1))';
   ArrayY(Index,ID)=(Coord(:,2))';
    Irepeat=FindRepeatedFrames(Index,RepeatedFrames,size(ArrayX,1));
    
    for o=[Irepeat(1):Irepeat(2)];
         ArrayX(o,ID)=(Coord(:,1))';
         ArrayY(o,ID)=(Coord(:,2))';
    end
    else
       hm=msgbox('There are positions with the same antenna number') 
        close(hm)
    end
   
   
end


%Add the repeats


end

%% Auxiliary function to find the repeated frames related to a given index

function Irepeat=FindRepeatedFrames(Index,RepeatedFrames,L)

if ~isempty(find(RepeatedFrames==Index))
    Ii=Index;
    
    if (find(RepeatedFrames==Index)+1)<=L %far from the file finish
    Ifinal=RepeatedFrames(find(RepeatedFrames==Index)+1);
    Irepeat=[Ii Ifinal];
    else
         Irepeat=[Ii Ii ];
    end
  else
    Ii=RepeatedFrames(find((RepeatedFrames-Index)<0,1,'last'));
    Ifinal=RepeatedFrames(find((RepeatedFrames-Index)>0,1,'first'));
     Irepeat=[Ii Ifinal];
end


end

%% ---------------Find duplicates----------

function [IndexDuplicate CoordDuplicate]=Find_Duplicates(X,Y,Xblank,Yblank)
IndexDuplicate=[];
CoordDuplicate=[];

[~,indX]=unique(X,'stable');
duplicate_indX=setdiff(1:size(X,2),indX);

[~,indY]=unique(Y,'stable');
duplicate_indY=setdiff(1:size(Y,2),indY);

if ~isempty(duplicate_indX)
%Find the duplicates in the list with white positions

IndexDuplicateReal=find((ismember(X(duplicate_indX),Xblank)& ismember(Y(duplicate_indY),Yblank))==1); %the duplicate must be in xblank this is for avoiding the non undefined positions

if ~isempty(IndexDuplicateReal)
    
IndexDuplicate=duplicate_indX(IndexDuplicateReal);
CoordDuplicate=[(X(IndexDuplicate))' (Y(IndexDuplicate))'];%to be included in the list
end
end


end

%% 
function [ID ,Coord]=Find_ID_For_Position(New_Coord,IndexMouse,RFID,AntennaCoord)

       for i=1:size(New_Coord,1)
           RFIDN=str2num(char(RFID(IndexMouse)));
          distancia=Calc_dist(New_Coord(i,:),AntennaCoord(RFIDN,:));
           
          %Find minimum distance for each antenna
         [M,I]=min(distancia); %should be a unique value
         ID(i)=IndexMouse(I);
         Coord(i,:)=New_Coord(i,:);
           
       end






end
%% 
function distancia=Calc_dist(coord,MatrixRFID)

  distancia=sqrt(sum((repmat(coord,size(MatrixRFID,1),1)-MatrixRFID).^2,2));



end


