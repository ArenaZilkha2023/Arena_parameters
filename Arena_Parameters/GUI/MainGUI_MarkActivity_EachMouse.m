%THIS GUI MARK THE ACTIVITY OF THE SELECTED MOUSE OF A SELECTED PERIOD AND
%THEN MAKE A VIDEO.INPUT IS AN EXCEL FILE DESIGN ONLY FOR THE GIVEN PERIOD.
%EACH SHEET IS RELATED WITH A DIFFERENT MICE.
function  MainGUI_MarkActivity_EachMouse(~,~)
global h
global Image2
global Image3
global Image6
%% 
%% Creation of a figure
h.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Mark activity each mouse',...
                                    'Position',[320 320 1100 300]);
                                

                                 
 %% Create pushbutton
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','','position',[30,240,40,60],'callback',@LoadMovie,'cdata',Image2)
 uicontrol(h.Layout1,'Style', 'text', 'String','1- Set the path of your movie','position',[0,220,130,30],'FontSize',8,'ForegroundColor','blue')
 h.edit5=uicontrol(h.Layout1,'Style','edit','String',' ','position',[100,260,400,30]);

 uicontrol(h.Layout1,'Style', 'pushbutton', 'String','','position',[30,160,40,60],'callback',@LoadTable,'cdata',Image2)
 uicontrol(h.Layout1,'Style', 'text', 'String','2- Set the path of your excel file','position',[0,130,130,30],'FontSize',8,'ForegroundColor','blue')
 h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[100,180,400,30]);
 
uicontrol(h.Layout1,'Style','text','String','3- Select the mice to be considered','FontSize',8,'ForegroundColor','blue','position',[600,220,200,80]); 
h.listMice=uicontrol(h.Layout1,'Style','list','String',{'','','','',''},'position',[600,180,200,100],'max',100,'min',1);
 
 
%  uicontrol(h.Layout1,'Style', 'popup', 'String',{'Mark Location inside the arena' 'Mark mouse passive parameters' 'Mark mouse active parameters' 'Mark chasing'} ,'position',[10,150,200,30],'callback',@LoadTable)
%  h.edit6=uicontrol(h.Layout1,'Style','edit','String',' ','position',[220,200,400,30]);
%  
 uicontrol(h.Layout1,'Style', 'pushbutton', 'String' ,'','position',[1000,30,40,60],'callback',@ValidationParameterToVideoForEachMice,'cdata',Image3)
 uicontrol(h.Layout1,'Style', 'text', 'String','8- Run','position',[950,2,150,40],'FontSize',9,'ForegroundColor','blue')

%   uicontrol(h.Layout1,'Style','text','String','3- Set the sheet ','position',[720,220,100,30]); 
% h.edit7=uicontrol(h.Layout1,'Style','edit','String','Sleeping','position',[700,200,200,30]); 
% 
uicontrol(h.Layout1,'Style','text','String','4- Select the Locomotion Parameters ','position',[10,40,200,80],'FontSize',8,'ForegroundColor','blue'); 
h.listP=uicontrol(h.Layout1,'Style','list','String',{'Is Sleeping','In Arena','Is Hiding','Is drinking','Is eating','Is running','Is walking','Is stop','Is in zone inside','Is in zone outside'},'position',[10,20,200,80],'max',20,'min',1);
%  
   uicontrol(h.Layout1,'Style','pushbutton','String',' ','position',[250,50,40,60],'callback',@LoadDirectory,'cdata',Image2); 
   uicontrol(h.Layout1,'Style', 'text', 'String','6- Select the folder of the output movie','position',[220,20,130,30],'FontSize',8,'ForegroundColor','blue')
   h.edit8P=uicontrol(h.Layout1,'Style','edit','String',' ','position',[300,70,300,25]); 
%
   uicontrol(h.Layout1,'Style','pushbutton','String',' ','position',[650,50,40,60],'callback',@LoadFile,'cdata',Image2); 
   uicontrol(h.Layout1,'Style', 'text', 'String','7- Load the arena parameters .xlsx','position',[620,20,130,30],'FontSize',8,'ForegroundColor','blue')
   h.edit11P=uicontrol(h.Layout1,'Style','edit','String',' ','position',[700,70,300,25]); 

%
uicontrol(h.Layout1,'Style','text','String','5- Select the number of frames ','position',[250,140,200,30],'FontSize',8,'ForegroundColor','blue');
h.edit9P=uicontrol(h.Layout1,'Style','edit','String','Initial frame','position',[240,130,100,20]); 
h.edit10P=uicontrol(h.Layout1,'Style','edit','String','Final frame','position',[350,130,100,20]); 

      %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout1,'Style', 'pushbutton','String', '','position',[1000,220,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

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
%---Read the  file and insert into the edit box
[FileName,PathName]=uigetfile('*.xlsx','Set the file of your excel table to add location');
set(h.edit6,'string',[PathName,FileName]);

%------Get the names of the sheet of the  excel file and put (mice
%name)into the list panel
[status,sheets]=xlsfinfo(fullfile(PathName,FileName));
set(h.listMice,'String',sheets)


end


%% 
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.edit8P,'string',directory_name);

end
%% 
function LoadFile(~,~)
global h
%---Read the  file and insert into the edit box
[FileName,PathName]=uigetfile('*.xlsx','Load the excel file with the parameters of the arena');
set(h.edit11P,'string',[PathName,FileName]);


end
%% %% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information

winopen(strcat(root_folder,'HelpDocuments','\','MarkActivity_EachMouse.docx'));

end

