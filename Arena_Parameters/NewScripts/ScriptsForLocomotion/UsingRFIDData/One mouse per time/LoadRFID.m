function RFIDData=LoadRFID(directory,ID1,ID2)
%UNTITLED4 Summary of this function goes here
%   Treat RFiD data
RFIDData={};
%% 

ListFiles=dir([directory,'\*.txt']);
Num = length(ListFiles(not([ListFiles.isdir])));%number of files
%ListFiles.datenum
%ListFiles.name
for i=1:Num %go over each file to take the header
%clear variables

 raw={}; %auxiliary 
 Data={};
 I=[];
 %% Open each text file
 
fid=fopen([directory,'\',ListFiles(i).name]);
Data=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);

fclose(fid);
%remember first column is mice id, second is the date, third is the time
%and last it is the antenna.

raw=[Data{1},Data{2},Data{3},Data{4}];
%% %find only indexes for the intrested mouse with 2 identities.

I=[find(strcmp(ID1,raw(:,1))==1);find(strcmp(ID2,raw(:,1))==1)];
%% Concatenate the files

if i==1
RFIDData=raw(I,:);
else
RFIDData=[RFIDData;raw(I,:)];

end
end
%sort according to ascending time
values=[];
Index=[];
[values,Index]=sort(datenum(RFIDData(:,3)));
RFIDData=RFIDData(Index,:);



%xlswrite('test1.xlsx',RFIDData)
end

