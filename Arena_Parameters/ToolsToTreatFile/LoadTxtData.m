function [ output_args ] = LoadTxtData( ~,~ )
%Load Data
%% open file

global h
clear Filename
clear Pathname
raw=[];

[FileName,PathName]=uigetfile('*.xlsx','Select the file with the chasing events','Multiselect', 'on'); %Remember: it is possible select only one file but the filename is character instead of cell
folder_name=strcat(PathName,FileName);
set(h.editElo1,'string',folder_name);

if iscell(folder_name)==0
[num raw]=xlsread(folder_name);
%%
if isempty(raw) %then look for the sheet called chasing
[num raw]=xlsread(folder_name,'Chasing');
end
%ckeck if there is a title on the top
FirstCell=raw(1,1);

if (strfind(char(FirstCell),'_20'))>1 %if it is the date non title
    begin=1;
else
    begin=2;
end
%% 
raw=raw(begin:end,:);
FindDays(raw);
elseif iscell(folder_name)==1
   %only takes the days from the first sheet 
      [num raw]=xlsread(folder_name{1}); 
      %% 
      
      %ckeck if there is a title on the top
FirstCell=raw(1,1);

if (strfind(char(FirstCell),'_20'))>1 %if it is the date non title
    begin=1;
else
    begin=2;
end
%% 
raw=raw(begin:end,:);
      FindDays(raw); 
 end


end
%% Auxiliary functions

function FindDays(raw)
global h
%read the days

for i=1:length(raw(:,1))
   Ax=char(strrep(raw(i,1),'''',''));
   k=strfind(Ax,'.');
   Days(i)=str2num(Ax(1:k(1)-1));
end

TotalDays=length(unique(Days));
List=[1:TotalDays]';
List=sort(List,'descend');
List=num2cell(List);

%put in the popmenumu

set( h.popupmenuDays,'String',List)

end

