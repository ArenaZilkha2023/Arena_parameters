function  ValidationGUI(~,~)
global h
global PathName
global FileName
%% 
%% Creation of a figure
h.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Add head tail event plus social events',...
                                    'Position',[320 320 900 300]);
                                

                                 
 %% Create pushbutton
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','1- Set the path of your movie','position',[10,260,200,30],'callback',@LoadMovie)
 h.edit5=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,260,600,30]);

 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','2- Set the path of your matlab file','position',[10,200,200,30],'callback',@LoadTable)
 h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
 %uicontrol(h.Layout1,'Style', 'popup', 'String',{'Mark Location inside the arena' 'Mark mouse passive parameters' 'Mark mouse active parameters' 'Mark chasing'} ,'position',[10,150,200,30],'callback',@LoadTable)
 %h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String' ,'Validation','position',[600,100,200,30],'callback',@AddLocationToVideo)
 
%   uicontrol(h.Layout1,'Style','text','String','3- Set the sheet ','position',[720,220,100,30]); 
% h.edit7=uicontrol(h.Layout1,'Style','edit','String','TailHead','position',[700,200,200,30]); 
 
   uicontrol(h.Layout1,'Style','pushbutton','String','4- Select the folder of output movie ','position',[220,120,200,30],'callback',@LoadFolderOutput); 
h.edit8=uicontrol(h.Layout1,'Style','edit','String','','position',[220,100,200,30]); 

h.checkbox1=uicontrol(h.Layout1,'Style','checkbox','Value',1,'String','5- Add head-head or head-tail events ','position',[220,80,300,30]); 

end
%% Auxiliary functions
function LoadMovie(~,~)
%load data
global h
global PathName
global FileName

[FileName,PathName]=uigetfile('*.avi','Set the file of your movie');
set(h.edit5,'string',[PathName,FileName]);

end

function LoadTable(~,~)
%load data
global h
[FileName,PathName]=uigetfile('*.mat','Set the file of your matlab file to add location');
set(h.edit6,'string',[PathName,FileName]);

end


%% 
function LoadFolderOutput(~,~)
%load data
global h
PathName=uigetdir('Set the folder of the output file');
set(h.edit8,'string',PathName);

end

