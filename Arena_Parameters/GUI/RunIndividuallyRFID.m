function [ output_args ] = RunIndividuallyRFID(~,~)

global h

%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Get locomotion parameters for a given mouse',...
                                    'Position',[320 320 800 300]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Load your csv file after Mice Tracer','position',[10,260,200,30],'callback',@LoadFileCsv)
 h.editLoc2=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,260,400,30]);
 
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','2- Set the path of the folder with RFID txt files','position',[10,200,200,30],'callback',@LoadRFIDData)
 h.edittxtLoc2=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,200,400,30]); 

uicontrol(h.Layout,'Style', 'text','String','3a- Select the head mouse ID','position',[10,150,200,30])
h.popmenuLoc2=uicontrol(h.Layout,'Style', 'popup','String',{' '} ,'position',[10,130,200,30])

uicontrol(h.Layout,'Style', 'text','String','3b- Select the rib mouse ID','position',[250,150,200,30])
h.popmenuLocSec2=uicontrol(h.Layout,'Style', 'popup','String',{' '} ,'position',[250,130,200,30])

 uicontrol(h.Layout,'Style', 'pushbutton', 'String','4- Set the directory of your final file','position',[10,90,200,30],'callback',@LoadDirectory)
 h.editLoc3=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,90,400,30]); 

uicontrol(h.Layout,'Style', 'pushbutton','String', '5- Run for locomotion parameters','position',[10,20,200,40],'callback',@computeIndLocParametersRFID)

end

%% Auxiliary functions
function LoadFileCsv(~,~)
%load data
global h
[field_name Pathname]=uigetfile('*.csv','Load csv file');
set(h.editLoc2,'string',strcat(Pathname,field_name));

end

%% 
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.editLoc2,'string',directory_name);

end

%

%% 
