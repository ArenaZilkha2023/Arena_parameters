function [ output_args ] = RunParametersNew(~,~)

global h
global Image2
global Image3
global Image6
global root_folder
%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Hierarchical Analysis',...
                                    'Position',[320 320 800 400]);
                                

 

                                
 %% Create pushbutton

 uicontrol(h.Layout,'Style', 'pushbutton','units','pixels','position',[30,340,40,60],'callback',@LoadDirectory,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','1- Select the folder with the experiments','position',[0,300,120,40],'FontSize',9,'ForegroundColor','blue')
 h.editRunParams=uicontrol(h.Layout,'Style','edit','String',' ','position',[90,360,400,30]);                           


 

uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[600,40,40,60],'FontSize',9,'ForegroundColor','blue','callback',@RunParametersCalc,'cdata',Image3)
uicontrol(h.Layout,'Style', 'text', 'String','4- Compute All hierarchical parameters','position',[530,4,200,40],'FontSize',9,'ForegroundColor','blue')



  % Create list menu
    uicontrol(h.Layout,'Style', 'text', 'String','2-Select the experiments','position',[10,250,150,30],'FontSize',9,'ForegroundColor','blue')
    h.listRunParams = uicontrol(h.Layout,'Style', 'list',...
           'String', {'' '' '' '' '' '' '' '' '' '' '' '' '' '' ''},...
           'Position', [20,170,100,90],'min',1,'max',15); 
       
  %add check button for deciding if to add manual chasing data
% h.ChangeManual=uicontrol(h.Layout,'Style','checkbox','Value',0,'position',[200,230,400,40],'string','To change manually the chasing data','FontSize',10,'ForegroundColor','black');       
       
   %create to save the data
   
  uicontrol(h.Layout,'Style', 'pushbutton','units','pixels','position',[30,100,40,60],'callback',@SaveDirectory,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','3- Select the folder to save the excel file','position',[0,80,120,40],'FontSize',9,'ForegroundColor','blue')
 h.editSave=uicontrol(h.Layout,'Style','edit','String',' ','position',[90,120,400,30]);   
       
   %add check button for graphs
 h.checkbox1=uicontrol(h.Layout,'Style','checkbox','Value',1,'position',[50,10,400,40],'string','Ethograms per Group','FontSize',10,'ForegroundColor','blue');  
  h.editMouse=uicontrol(h.Layout,'Style','edit','position',[380,10,30,40],'string','5','FontSize',10,'ForegroundColor','black');  
   uicontrol(h.Layout,'Style','text','position',[400,3,40,40],'string','mice','FontSize',10,'ForegroundColor','blue'); 
    h.editDays=uicontrol(h.Layout,'Style','edit','position',[460,10,30,40],'string','6','FontSize',10,'ForegroundColor','black');  
   uicontrol(h.Layout,'Style','text','position',[500,3,40,40],'string','Days','FontSize',10,'ForegroundColor','blue'); 
   
 %add to run only the parameters
 h.checkbox2=uicontrol(h.Layout,'Style','checkbox','Value',1,'position',[50,40,400,40],'string','Run parameters without plot','FontSize',10,'ForegroundColor','blue');  
 %add to plot etogram for each mouse
  h.checkbox3=uicontrol(h.Layout,'Style','checkbox','Value',1,'position',[300,40,300,40],'string','Plot ethogram','FontSize',10,'ForegroundColor','blue');  
   
   
       %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[740,340,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      
%% ------------------------------------------------- Choice the score to use------------------------------------
h.Panel=uipanel('Parent',h.Layout,'Title','Calculate score mouse','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[500,100,250,250]);
uicontrol(h.Panel,'Style','text','String',{'The parameters are ordered according to the choiced score method'},'Position',[30,160,180,60],'FontSize',10,'foreground','Red');
 h.Popup3PCA = uicontrol(h.Panel,'Style','popup',...
                'String',{'Select score method','Average Elorating score','David score ranking','Last day elorating','Last day Glicko'},...
                'Value',1,'Position',[20,120,200,20],'FontSize',9);
 uicontrol(h.Panel,'Style','text','String',{'Calculate scores from day:'},'Position',[20,20,180,60],'FontSize',10,'foreground','Red');
            h.Popup2PCA = uicontrol(h.Panel,'Style','popup',...
                'String',{'Select Day','1','2','3','4','5','6','7'},...
                'Value',1,'Position',[20,20,200,20],'FontSize',9);
end
%% Auxiliary functions
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your folder with the experiments');
set( h.editRunParams,'string',directory_name);

%% ----------Open directory and list the files----------------------
ListFiles=dir(directory_name);

length(ListFiles([ListFiles.isdir]))

%for i=3:length(ListFiles([ListFiles.isdir]))
for i=3:length(ListFiles)
Flag=(ListFiles(i).isdir);
if Flag==1
subfolders{i-2}=ListFiles(i).name;
end

end
% 
set(h.listRunParams,'string',subfolders);

end

%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information
winopen(strcat(root_folder,'HelpDocuments','\','Locomotion parameters.docx'));


end
%% 
function SaveDirectory(~,~)
global h

directory_name=uigetdir('','Set the path of your folder for the output excel file');
set( h.editSave,'string',directory_name);


end