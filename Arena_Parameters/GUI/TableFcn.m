function MiceID=TableFcn(~,~)
%% Parameters
global ChipsID
global h
%% Load each file and read the head

Folder_root=get(h.edit1,'string') %load directory
Experiment=get(h.edit2,'string') %load experiment
Folder_Data=[Folder_root,'\',Experiment,'RFID']; %dir of the data

ListFiles=dir([Folder_Data,'\*.txt'])
Num = length(ListFiles(not([ListFiles.isdir]))) %number of files

for i=1:Num %go over each file to take the header
fid=fopen([Folder_Data,'\',ListFiles(i).name]);
header=fgets(fid);
% header=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
header=textscan(header,'%10s %s %s %s %s','delimiter',';','EmptyValue',NaN);

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
headerAll=unique(headerAll);

%remove repeats and empties.

%% Create uiTable to enter mouse id
% Create the column and row names in cell arrays 

cnames = {'Chip 1','Chip 2','Chip3','Sex','Genotype','Idah' };
rnames = {'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7'};
ChipsID=headerAll';
handles.data=cell(7,6); 
handles.data={[] [] [] [] [] [];[] [] [] [] [] []; [] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] []}

t= uitable(h.Layout, 'ColumnName',cnames,'RowName',rnames,'ColumnWidth',{100},'Data',handles.data,'ColumnFormat',{ChipsID ChipsID ChipsID  {'male' 'female' ' '} {'Wild type' 'knock-out' 'intruder' 'others' ' '} {'Wild mouse' 'Lab. mouse' ' '}},'ColumnEditable', [true true true true true true],'HandleVisibility','callback','Position',[0 0 700 200],'FontSize',9)
 
h.table=t;
%% in addition consider the date of one files for saving later
Aux=char(ListFiles(1).name);
index=strfind(Aux,'-');
date=Aux(1:index-1);
h.date=date;

   