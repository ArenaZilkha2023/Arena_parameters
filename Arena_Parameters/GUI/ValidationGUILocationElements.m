function ValidationGUILocationElements(~,~)
global h

%% 
%% Creation of a figure
h.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Check the arena coordinates',...
                                    'Position',[320 320 900 300]);
                                

                                 
 %% Create pushbutton
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','1- Set the path of your movie','position',[10,260,200,30],'callback',@LoadMovie)
 h.editL5=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,260,600,30]);

 uicontrol(h.Layout1,'Style', 'text', 'String','2- Are your arena L (left) or R(right)','position',[10,200,200,30])
 h.editL6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,100,30]);
 
 %uicontrol(h.Layout1,'Style', 'popup', 'String',{'Mark Location inside the arena' 'Mark mouse passive parameters' 'Mark mouse active parameters' 'Mark chasing'} ,'position',[10,150,200,30],'callback',@LoadTable)
 %h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
 
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String' ,'Validation','position',[600,100,200,30],'callback',@AddLocationToVideoSpetialForCoordinates)
 
 
   uicontrol(h.Layout1,'Style','text','String','4- Select name of output movie ','position',[220,120,200,30]); 
h.editL8=uicontrol(h.Layout1,'Style','edit','String','Sleeping','position',[220,100,200,30]); 
end
%% Auxiliary functions
function LoadMovie(~,~)
%load data
global h

[FileName,PathName]=uigetfile('*.avi','Set the file of your movie');
set(h.editL5,'string',[PathName,FileName]);

end


%% 


