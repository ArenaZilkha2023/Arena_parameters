function LoadDataFile(~,~)
%load data
global h

[field_name Pathname]=uigetfile('*.csv','Load csv file with the RFID plus Video Data');
set(h.editLoc1,'string',strcat(Pathname,field_name));
%% function [ output_args ] = RetrieveMouseID(~,~)
cr_fname=get(h.editLoc1,'string') %load directory
%% 

%Open csv  files to get data
fid=fopen(cr_fname,'r'); 
header=fgets(fid);%GET FIRST HEADER
numOfMice=length(strfind(header,'000')); %THIS COULD BE A PROBLEM IF THE 000 DISSAPEAR!!!!
FORMAT1=[];
FORMAT2=[];

for i=1:numOfMice*3+2 %For each mouse x, y and velocity.The first 2 columns are the date and the time.
    FORMAT1 = [FORMAT1 ' %s'];
    if i>2
        FORMAT2 = [FORMAT2 ' %f'];
    else
        FORMAT2= [FORMAT2 ' %s'];
    end
end
header = textscan(header,FORMAT1,'delimiter', ',','EmptyValue', NaN);%GETS X
%%
j=1
for i=4:3:3*numOfMice+2
headers(j)=header{1,i}
j=j+1;
set(h.popmenuLoc1,'string',headers)

end


