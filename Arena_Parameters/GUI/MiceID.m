function MouseID(~,~)
%% Parameters
global ChipsID
global h
global Image6
global Image5
%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Set mice identity and arena coordinates',...
                                    'Position',[320 320 900 300]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Open the folder called Data','position',[10,260,200,30],'callback',@LoadData)
 h.edit1=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,260,400,30]);                           
%Create edit for experiment name
 uicontrol(h.Layout,'Style','text','String','2- Experiment name ','position',[20,230,100,30]); 
h.edit2=uicontrol(h.Layout,'Style','edit','String','Exp50L','position',[20,210,100,30]); 
 
 %Create pushbotton to load the table                               
                                
uicontrol(h.Layout,'Style', 'pushbutton', 'String','4- Load the table to select mice ID','position',[10,100,200,40],'callback',@TableFcn)

%% Add panel to corroborate coordinates
h.Coordinates=uipanel('Parent',h.Layout,'Title','3- Arena coordinates in pixels','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[150,200,650,60]);
uicontrol(h.Coordinates,'Style', 'pushbutton', 'String','Corroborate the arenas coordinates','position',[10,10,200,30],'foreground','red','callback',@CorroborateArenaCoord);
%% -----------Add popup menu--------------------
h.popup1=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Default','Change'},'position',[210,1,70,25],'foreground','blue');
uicontrol(h.Coordinates,'Style','text','String','Corners ','position',[210,30,50,15]); 

h.popup2=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Default','Change'},'position',[290,1,70,25],'foreground','blue');
uicontrol(h.Coordinates,'Style','text','String','Eating','position',[290,30,50,15]); 

h.popup3=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Default','Change'},'position',[370,1,70,25],'foreground','blue');
uicontrol(h.Coordinates,'Style','text','String','Drink loc.','position',[370,30,50,15]); 

uicontrol(h.Coordinates,'Style', 'pushbutton', 'String',' ','position',[600,5,40,30],'foreground','blue','callback',@ReadPopup,'cdata',Image5);

h.popup4=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Default','Change'},'position',[444,1,70,25],'foreground','blue');
uicontrol(h.Coordinates,'Style','text','String','Bridge L.','position',[444,30,50,15]); 

h.popup5=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Default','Change'},'position',[515,1,70,25],'foreground','blue');
uicontrol(h.Coordinates,'Style','text','String','Bridge N.','position',[515,30,50,15]); 


%% %% Save the data into excel file with experiment name and save
uicontrol(h.Layout,'Style', 'pushbutton', 'String','5- Save ID to excel','position',[700,10,200,30],'callback',@SaveTableInExcel)

          %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[850,230,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)   


end
%% auxiliary functions
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information

winopen(strcat(root_folder,'HelpDocuments','\','Module Set mice identity.docx'));

end
%% Read popup menu

function ReadPopup(~,~)
global h
conditions=zeros(1,5);
%% Consider if to use default or to change
list=get(h.popup1,'String');
idx=get(h.popup1,'Value');
option=list(idx);

if strcmp(option,'Change')==1
    conditions(1,1)=1;
end

list=get(h.popup2,'String');
idx=get(h.popup2,'Value');
option=list(idx);
if strcmp(option,'Change')==1
    conditions(1,2)=1;
end


list=get(h.popup3,'String');
idx=get(h.popup3,'Value');
option=list(idx);
if strcmp(option,'Change')==1
    conditions(1,3)=1;
end

list=get(h.popup4,'String');
idx=get(h.popup4,'Value');
option=list(idx);
if strcmp(option,'Change')==1
    conditions(1,4)=1;
end



list=get(h.popup5,'String');
idx=get(h.popup5,'Value');
option=list(idx);
if strcmp(option,'Change')==1
    conditions(1,5)=1;
end
RearrangeArenaCoord(conditions);

end
