function [ output_args ] = RunParameters(~,~)

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


 

uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[570,40,40,60],'FontSize',9,'ForegroundColor','blue','callback',@RunAllGui,'cdata',Image3)
uicontrol(h.Layout,'Style', 'text', 'String','3- Compute All hierarchical parameters','position',[500,4,200,40],'FontSize',9,'ForegroundColor','blue')



  % Create list menu
    uicontrol(h.Layout,'Style', 'text', 'String','2-Select the experiments','position',[10,250,150,30],'FontSize',9,'ForegroundColor','blue')
    h.listRunParams = uicontrol(h.Layout,'Style', 'list',...
           'String', {'' '' '' '' '' '' '' '' '' '' ''},...
           'Position', [20,180,100,80],'min',1,'max',10); 
       
       
   %create to save the data
   
  uicontrol(h.Layout,'Style', 'pushbutton','units','pixels','position',[30,100,40,60],'callback',@SaveDirectory,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','1- Select the folder to save the excel file','position',[0,80,120,40],'FontSize',9,'ForegroundColor','blue')
 h.editSave=uicontrol(h.Layout,'Style','edit','String',' ','position',[90,120,400,30]);   
       
       
       %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[740,340,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      
 

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

for i=3:length(ListFiles([ListFiles.isdir]))
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