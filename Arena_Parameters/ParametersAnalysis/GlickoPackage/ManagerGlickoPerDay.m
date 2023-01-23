function  RankingGlickoLastDay=ManagerGlickoPerDay(DataToUse,filename)
%% Calculate Glicko rating according to 
% http://www.glicko.net/glicko/glicko.pdf
% input data chasing table from csv/excel
%% Variables Reset
global h
clear Rglicko
clear RDglicko
clear GlickoMatrix
clear GlickoMatrixToDelta
%% Load parameters
SubsetData=DataToUse.SubsetData;
MouseID=DataToUse.MouseID;
IndexChasing=DataToUse.IndexChasing;
IndexBeingChasing=DataToUse.IndexBeingChasing;
IndexEvents=DataToUse.IndexEvents;
begin=DataToUse.begin;
Int=DataToUse.Int;%index for the end of each day


Params = GlickoRatingParams();
InitialRating=(Params.InitialRating)*ones(size(MouseID,1),1); %this is a column vector for each mouse
Cconstant=Params.Cconstant;
InitialRatingDesviation=(Params.InitialRatingDesviation)*ones(size(MouseID,1),1);%this is a column vector for each mouse
NumberDaysExp=Params.DaysExp;




%% Find the days 
for i=1:length(SubsetData(:,1))
    Ax=char(strrep(SubsetData(i,1),'''','')); %remove every comma
    k=strfind(Ax,'.');
    Days(i)=str2num(Ax(1:k(1)-1));
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(3)-1);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month 
end
    [~,Ids]=sort(unique(DateNum,'stable'))
    Days=Days';
 %remove repeats days and locations
 DaysWR=unique(Days,'stable'); %only intrested days
 DaysWR=DaysWR(Ids);
% From these days select the user choice days
 DaysWR=DaysWR(1:NumberDaysExp);
 
 
 %% Define which number of mouse is doing and being chasing
SubsetDataWithR=SubsetData(1:Int(length(DaysWR)),:); %without no wanted days
IR=find(strcmp(strrep( SubsetDataWithR(:,IndexEvents),'''',''),'R')==1); %find indexes is reverse
if ~isempty(IR)
%Reverse data when the user marked as R in chasing table
miceRBeingChasing=[];
miceRChasing=[];
miceRBeingChasing=SubsetDataWithR(IR,IndexBeingChasing);
miceRChasing=SubsetDataWithR(IR,IndexChasing);

SubsetDataWithR(IR,IndexChasing)=miceRBeingChasing;
SubsetDataWithR(IR,IndexBeingChasing)=miceRChasing;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
 hwait = waitbar(0,'Please wait Glicko calculation...');


%% CALCULATION OF the glicko rating system
 close(hwait)
hwait = waitbar(0.5,'Please wait...');
%go over each day
for day=1:size(DaysWR,1)
    
      % find index for each day

       % Create for each day a social matrix %this function is at landau
       % folder
       
        SocialMatrixN=SocialMatix(SubsetDataWithR(find(Days==DaysWR(day)),IndexChasing),SubsetDataWithR(find(Days==DaysWR(day)),IndexBeingChasing),MouseID); %Change  4 and 5 by general
       
        %Calculation of glicko for each mice
        [Rglicko, RDglicko]=GlickoCalculationPerDay(SocialMatrixN,MouseID,InitialRating,InitialRatingDesviation);
        
        % adjust the rating desviations for the next period
        for count=1:size(MouseID,1)
         InitialRatingDesviation(count,1)=min(sqrt(RDglicko(count,1)^2+Cconstant^2),350); %this is the input to the next day - a column vector for each mouse
        end
         
         InitialRating= Rglicko; %this is the input to next day- a column vector for each mouse
         
         
         %Summary the results
         Rmatrixglico(:,day)=Rglicko; %create a matrix where the rows are mice and the columns are days.
         RDmatrixglico(:,day)=RDglicko;  %create a matrix where the rows are mice and the columns are days.           
end                      
   %% Create a table with the glicko results
   
   % Add  the initial rates for day 0
   
Raux=[(Params.InitialRating)*ones(1,size(Rmatrixglico,1)); Rmatrixglico'];
RDaux=[(Params.InitialRatingDesviation)*ones(1,size(RDmatrixglico,1)); RDmatrixglico'];
Raux=[[0;[1:size(DaysWR,1)]'],Raux];
RDaux=[[0;[1:size(DaysWR,1)]'],RDaux];


%create elorating matrix
GlickoMatrixR(1,1)={'Days'};
GlickoMatrixRD(1,1)={'Days'};


for i=1:length(MouseID)
GlickoMatrix(1,i+1)=strcat('''',MouseID(i),'''');
GlickoMatrixRD(1,i+1)=strcat('''',MouseID(i),'''');
end

GlickoMatrix(2:size(Raux,1)+1,:)=num2cell(Raux);

GlickoMatrixRD(2:size(RDaux,1)+1,:)=num2cell(RDaux);

%Create a ranking according to last day of glicko per day
  [Ranking I]=sort(cell2mat(GlickoMatrix(size(GlickoMatrix,1),2:size(GlickoMatrix,2))),'descend');
  
  Tree(:,1)=strcat('''',MouseID(I),'''');
  Tree(:,2)=num2cell(Ranking');
  %save to the structure
 RankingGlickoLastDay=Tree(:,1);
%% Save in excel file and plot 

 sheet1=['Glicko-rating Per Day'];
 sheet1e=['Glicko-rating Error Per Day'];
 try
  xlswrite(filename,GlickoMatrix,sheet1)
  xlswrite(filename,GlickoMatrixRD,sheet1e)
 catch
    msgbox('CLOSE YOUR EXCEL FILE') 
 end

 PlotGlickoPerDay(GlickoMatrix,GlickoMatrixRD,MouseID,filename);
%% add ranking according to last day glicko
DataToUse.rawR = RankingGlickoLastDay
%% ----------------------------------------------------
 %% Add randomization 
  %% if checkbox is ok run shuffling methods
 if  (get(h.Checkbox3,'Value') == 1) & (get(h.Checkbox2,'Value') == 1) %only if for one day was calculated
  
  Params = GlickoRatingParams();
  InitialRating=(Params.InitialRating)*ones(size(MouseID,1),1); %this is a column vector for each mouse
  Cconstant=Params.Cconstant;
  InitialRatingDesviation=(Params.InitialRatingDesviation)*ones(size(MouseID,1),1);%this is a column vector for each mouse
  NumberDaysExp=Params.DaysExp;
  %% Add the glicko of the real experiment 
 GlickoMatrixToDelta = GlickoMatrix(3:end,2:end);
  
 SaveArray=RunShufflingGlicko(DataToUse,filename,...
      DaysWR,IndexChasing,IndexBeingChasing,MouseID,...
    InitialRating,InitialRatingDesviation,Cconstant,Days,GlickoMatrixToDelta);
  %Save the data
      DataToUse.PvalueGlicko=SaveArray;
      sheet=['P-value of Glicko randomization'];
      xlswrite(filename,SaveArray,sheet)
  
  %FINISH
%   %% Arrange SaveArray
%   for i=1:NumberDaysExp+1 %read each matrix -Remember the first is last event
%   SaveArrayAux(:,:,i)=SaveArray(i+(i-1)*(length(MouseID)+1):i+(i-1)*(length(MouseID)+1)+length(MouseID)+1,1:length(MouseID)+1);
%   end
 end
 %% ---------------------------------------------------------------
 %%
 
 
 
close(hwait)
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Auxiliary functions


%% 
    function I=DaysRemove(A,NumberDaysExp)
    Days=[];
    DaysWR=[];
   A=A(3:end);
    for i=1:length(A)
         
      Ax=char(strrep(A(i),'''','')); %remove every comma
    k=strfind(Ax,'.');
    
    Days(i)=str2num(Ax(1:k(1)-1));
  
    end
     Days=Days';
 %remove repeats days and locations
     DaysWR=unique(Days,'stable');
     
     %find not consider days
     if NumberDaysExp==length(DaysWR)
         I=0;
     else
     DaysNC=DaysWR(NumberDaysExp+1:length(DaysWR));
     for i=1:length(DaysNC)
         if i==1
        I=find(Days==DaysNC(i));
         else
             I1=find(Days==DaysNC(i));
             I=[I;I1];
         end
     end    
     end    
         
 end