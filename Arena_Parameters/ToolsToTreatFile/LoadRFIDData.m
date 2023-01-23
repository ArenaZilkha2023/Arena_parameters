function LoadRFIDData( ~,~ )
%UNTITLED2 Summary of this function goes here
%   Load RFID data
global h
clear Filename
clear Pathname
%Load Data
%% open file
Folder_Data=uigetdir('*.txt','Select the folder with the RFID files');
set(h.edittxtLoc2,'string',Folder_Data);
%% Load each file and read the head

ListFiles=dir([Folder_Data,'\*.txt'])
Num = length(ListFiles(not([ListFiles.isdir]))); %number of files

for i=1:Num %go over each file to take the header
fid=fopen([Folder_Data,'\',ListFiles(i).name]);
%header=fgets(fid);
header=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
header=header{1};

fclose(fid);
if i==1 %couplint all the headers
 headerAll=header;
else
headerAll=[headerAll; header];
end

end
index=find(strcmp(headerAll,'')==0);%different from''
headerAll=headerAll(index);
headerAll=unique(headerAll); %remove repeats and empties.

%% 
%Insert into the list menu
set(h.popmenuLoc2,'string',headerAll) %set identity for the head
set(h.popmenuLocSec2,'string',headerAll) %set identity for the ribs.

end

