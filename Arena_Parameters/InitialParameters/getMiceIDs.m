function [miceType,malesList,femalesList,mice_3_chips]=getMiceIDs(DIR,sheet)
% Types:
% 'M'  -  male
% 'F'  -  female
% 'M*' -  knock-outs
% 'Mi' -  intruder
global Params

%% Read data

mice_3_chips=cell(0,3);
%DIR='D:\Test(U disk)';
%sheet='Exp50LVideo'

%% find male and female list- Root directory and sheet given by the user
[num,txt,raw]=xlsread([DIR,'\','Parameters','\','MiceID.xlsx'],sheet);
%[num,txt,raw]=xlsread('D:\Test(U disk)\Parameters\MiceID.xlsx','Exp50LVideo');

index1=find(strcmp(raw(1,:),'Sex')==1);
index2=find(strcmp(raw(1,:),'Chip1')==1); %identity on the head
index3=find(strcmp(raw(1,:),'Chip3')==1);
[NumMice,Conditions]=size(raw);

malesList=cellfun(@male,raw(2:end,index1),raw(2:end,index2),'UniformOutput', false);
malesList=malesList;
%remove empty spaces
Ind1=find(strcmp(malesList,'')==0);
malesList=malesList(Ind1);
malesList=malesList';

femalesList=cellfun(@female,raw(2:end,index1),raw(2:end,index2),'UniformOutput', false);
femalesList=femalesList';

mice_3_chips=raw(2:end,index2:index3);
mice_3_chips=cellfun(@RemoveIsnan,mice_3_chips,'UniformOutput', false)

%% do mice type structure
for i=2:NumMice
    if isnan(raw{i,index2})==0
    Aux=raw(i,index2);
   Aux=strrep( Aux,'''','') %eliminate double quotes
    %% 
    
     Aux=char(Aux);

Aux1=strcat('x',Aux(length(Aux)-3:length(Aux)))


if strcmp(raw(i,index1),'male')==1
 
    miceType.(Aux1)='M';
else
   
   miceType.(Aux1)='F';
end
end
end
end
%% Auxiliary functions
function result=male(a,b)
if strcmp(a,'male')==1
  result=b;
else
    result='';
end



end


function result=female(a,b)
if strcmp(a,'female')==1
  result=b; 
else
    result='';
end



end

function result=RemoveIsnan(a)
if isnan(a)==1
    result='';
else
    result=a;
end


end
%% 


