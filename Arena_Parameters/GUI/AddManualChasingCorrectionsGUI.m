function [ output_args ] = AddManualChasingCorrectionsGUI(~,~)

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
%  uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Set the path of your excel file with chasing events','position',[10,260,300,30],'callback',@LoadTxtData,'FontSize',9,'ForegroundColor','blue')

 uicontrol(h.Layout,'Style', 'pushbutton','units','pixels','position',[30,340,40,60],'callback',@LoadDirectory,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','1- Select the folder with all experiments','position',[0,300,120,40],'FontSize',9,'ForegroundColor','blue')
 h.editAdd1=uicontrol(h.Layout,'Style','popup','String',' ','position',[90,360,400,30]);                           

 uicontrol(h.Layout,'Style', 'text', 'String','Note: Prepare excel file called Chasing-manual.xlsx inside Results folder','position',[530,360,200,30],'FontSize',10,'ForegroundColor','red')
 
 % Create list menu
    uicontrol(h.Layout,'Style', 'text', 'String','2-Select the experiments','position',[10,250,150,30],'FontSize',9,'ForegroundColor','blue')
    h.listAdd = uicontrol(h.Layout,'Style', 'list',...
           'String', {'' '' '' '' '' '' '' '' '' '' '' '' '' '' ''},...
           'Position', [20,170,100,90],'min',1,'max',15); 


 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[570,150,40,60],'FontSize',9,'ForegroundColor','blue','callback',@ManagerAddCorrections,'cdata',Image3)
 uicontrol(h.Layout,'Style', 'text', 'String','Add corrections to chasing mat files and create new excel with chasing events','position',[500,100,200,60],'FontSize',9,'ForegroundColor','blue')
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[740,340,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

end
%% Auxiliary functions
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.editAdd1,'string',directory_name);
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
set(h.listAdd,'string',subfolders);

end

%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information
winopen(strcat(root_folder,'HelpDocuments','\','Hierarchical Analysis.docx'));


end
%% 
