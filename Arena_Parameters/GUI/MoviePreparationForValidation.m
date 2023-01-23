function  MoviePreparationForValidation(~,~)

%This scripts prepare a movie for part of the experiment and show the
%locomation parameters.
global h

%% 
%% Creation of a figure
h.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Mark passive localization of the mouse',...
                                    'Position',[320 320 900 300]);
                                

                                 
 %% Create pushbutton
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','1- Set the path of your movie','position',[10,260,200,30],'callback',@LoadMovie)
 h.edit5=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,260,600,30]);

 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','2- Set the path of your excel file','position',[10,200,200,30],'callback',@LoadTable)
 h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
 %uicontrol(h.Layout1,'Style', 'popup', 'String',{'Mark Location inside the arena' 'Mark mouse passive parameters' 'Mark mouse active parameters' 'Mark chasing'} ,'position',[10,150,200,30],'callback',@LoadTable)
 %h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String' ,'Validation','position',[600,20,200,30],'callback',@AddLocationToVideoForAllMice)
 
uicontrol(h.Layout1,'Style','text','String','3- Select left or right arena ','position',[720,220,150,30]); 
h.editPoup7=uicontrol(h.Layout1,'Style','popupmenu','String',{'Left','Right'},'position',[750,200,60,30]); 

uicontrol(h.Layout1,'Style','text','String','4- Select the passive parameters ','position',[10,100,200,80]); 
h.listP=uicontrol(h.Layout1,'Style','list','String',{'InArena','IsSleeping','IsHiding','IsDrinking','IsEating'},'position',[10,80,200,80],'max',10,'min',1);
 
uicontrol(h.Layout1,'Style','pushbutton','String','6- Select the folder of the output movie ','position',[10,50,200,30],'callback',@LoadDirectory); 
h.edit8P=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,50,400,30]); 

uicontrol(h.Layout1,'Style','text','String','5- Select the number of frames ','position',[350,150,200,30]);
h.edit9P=uicontrol(h.Layout1,'Style','edit','String','Initial frame','position',[300,130,200,20]); 
h.edit10P=uicontrol(h.Layout1,'Style','edit','String','Final frame','position',[500,130,200,20]); 

end
%% Auxiliary functions
function LoadMovie(~,~)
%load data
global h

[FileName,PathName]=uigetfile('*.avi','Set the file of your movie');
set(h.edit5,'string',[PathName,FileName]);

end

function LoadTable(~,~)
%load data
global h
[FileName,PathName]=uigetfile('*.xlsx','Set the file of your excel table to add location');
set(h.edit6,'string',[PathName,FileName]);

end


%% 
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.edit8P,'string',directory_name);

end

