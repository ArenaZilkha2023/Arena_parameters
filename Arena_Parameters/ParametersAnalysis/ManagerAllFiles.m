function ManagerAllFiles(~,~)
%This function read all files

%clear var
clearvars
%% Load parameters
Params = EloRatingParams;
Filename=Params.Filename;

%%
%Distinguish between one file and several files
if iscell(Filename)==0
 filename=Filename;
 DataToUse=ArrangeInputFiles(filename); %NOTE THE ORDER OF THE MICE HERE IS DIFFERENT FROM THE ORIGINAL ORDER
 DataToUseLater=DataToUse;
  DataToUse=ManagerElorating(DataToUse,filename); 
  
  %   
%   % Glicko instead elorating
  ManagerGlickoPerEvent(DataToUseLater,filename);
  RankingGlickoLastDay=ManagerGlickoPerDay(DataToUseLater,filename);
% 
%for the following parameters use the data arranged according the last day of glicko
%per day
  ManagerLandau( DataToUse,filename,RankingGlickoLastDay);
  ManagerStabilityIndex(DataToUse,filename);

  
elseif iscell(Filename)==1    
for i=1:size(Filename,1)
    filename=char(Filename{i});
    hj=msgbox(strcat('Running',filename))
     DataToUse=ArrangeInputFiles(filename);
     DataToUseLater=DataToUse;
    DataToUse=ManagerElorating(DataToUse,filename);
     
     ManagerLandau( DataToUse,filename); 
     ManagerStabilityIndex(DataToUse,filename);
     
      % Glicko instead elorating
       ManagerGlickoPerEvent(DataToUseLater,filename);
        ManagerGlickoPerDay(DataToUseLater,filename);
   
close(hj)
end


end

