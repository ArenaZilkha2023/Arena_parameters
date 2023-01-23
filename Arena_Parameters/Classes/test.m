RFIDObj=FilesTreat;
RFIDObj.extension='.txt';
RFIDObj.directory='D:\ForWorking\FromYefim\Left Arena_Exp53L\Data\Exp53LRFID';
RFIDObj.ListFiles

RFIDObj.NumFiles(RFIDObj.ListFiles)

RFIDObj.NumFiles(RFIDObj.ListFiles);
A= RFIDObj.ReadALLFiles(RFIDObj.ListFiles);%all the RFDID data
%% ------------------------------------------------------------------

CSVObj=FilesTreat;
CSVObj.directory='D:\ForWorking\FromYefim\Left Arena_Exp53L\Data\Exp53LVideo';

% for i=1:CSVObj.NumFiles(CSVObj.LoadList)
CSVObj.ReadFilesAllCSV(CSVObj.LoadList,3)   
CSVObj.miceIDs     
% end