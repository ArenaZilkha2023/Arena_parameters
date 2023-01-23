function  ValidationGUIChasing(~,~)
global h

%% 
%% Creation of a figure
h.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Chasing all',...
                                    'Position',[320 320 900 300]);
                                

                                 
 %% Create pushbutton
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','1- Set the path of your movie','position',[10,260,200,30],'callback',@LoadMovie)
 h.edit5=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,260,600,30]);

 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','2- Set the path of your excel file','position',[10,200,200,30],'callback',@LoadTable)
 h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
          uicontrol(h.Layout1,'Style', 'text', 'String',{'4-Choice the mouse is chasing'} ,'position',[10,170,200,30])
 h.popup1=uicontrol(h.Layout1,'Style', 'popup', 'String',{'' '' '' '' ''} ,'position',[10,150,200,30])

 
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String' ,'Validation','position',[600,50,200,30],'callback',@AddLocationToVideoChasing)
 
  uicontrol(h.Layout1,'Style','text','String','3- Set the sheet ','position',[720,220,100,30]); 
h.edit7=uicontrol(h.Layout1,'Style','edit','String','Sleeping','position',[700,200,200,30]); 
 
   uicontrol(h.Layout1,'Style','text','String','6- Select name of output movie ','position',[220,120,200,30]); 
h.edit8=uicontrol(h.Layout1,'Style','edit','String','Sleeping','position',[220,100,200,30]); 

   uicontrol(h.Layout1,'Style','text','String','5- Select the number of frames ','position',[350,170,200,30]); 
h.edit9=uicontrol(h.Layout1,'Style','edit','String','Initial frame','position',[300,160,200,20]); 
h.edit10=uicontrol(h.Layout1,'Style','edit','String','Final frame','position',[500,160,200,20]); 

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


[FileName,PathName]=uigetfile('*.xlsx','Set the file of your excel table to add location')
set(h.edit6,'string',[PathName,FileName]);
%Read the identity from a worksheet with identity

[num,txt,raw]=xlsread([PathName FileName],'Mice Identity');
MiceIdentity=raw(2:end,strcmp(raw(1,:),'Mice Identity')) %get the identity to load into a popup menu
set( h.popup1,'string',cellstr(MiceIdentity))

end


%% 


