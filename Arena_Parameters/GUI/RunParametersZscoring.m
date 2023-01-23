function [ output_args ] = RunParametersZscoring(~,~)

global h
global Image2
global Image3
global Image6
global root_folder
%% Creation of a figure
h.LayoutZscore= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Zscoring of all the parameters',...
                                    'Position',[320 320 800 400]);
                                

 

                                
 %% Create pushbutton

 uicontrol(h.LayoutZscore,'Style', 'pushbutton','units','pixels','position',[30,340,40,60],'callback',@LoadFile,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.LayoutZscore,'Style', 'text', 'String','1- Select the excel file with the parameters of all the experiments','position',[0,250,120,80],'FontSize',9,'ForegroundColor','blue')
 h.editRunParamsZscore=uicontrol(h.LayoutZscore,'Style','edit','String',' ','position',[90,360,400,30]);                           


 

uicontrol(h.LayoutZscore,'Style', 'pushbutton','String', '','position',[600,40,40,60],'FontSize',9,'ForegroundColor','blue','callback',@ManagerZscoring,'cdata',Image3)
uicontrol(h.LayoutZscore,'Style', 'text', 'String','5- Zscoring your data','position',[530,4,200,40],'FontSize',9,'ForegroundColor','blue')



  % Create list menu
    uicontrol(h.LayoutZscore,'Style', 'text', 'String','2-Select the experiments','position',[10,210,150,30],'FontSize',9,'ForegroundColor','blue')
    h.listRunParamsZscore = uicontrol(h.LayoutZscore,'Style', 'list',...
           'String', {'' '' '' '' '' '' '' '' '' '' ''},...
           'Position', [20,120,100,100],'min',1,'max',15); 
       
       
       %Create list menu for selecting the social and locomotion parameters

    uicontrol(h.LayoutZscore,'Style', 'text', 'String','3-Select the social and locomotion parameters','position',[220,220,300,20],'FontSize',9,'ForegroundColor','blue')
    h.listParamsZscore = uicontrol(h.LayoutZscore,'Style', 'list',...
           'String', {'' '' '' '' '' '' '' '' '' '' ''},...
           'Position', [300,120,200,100],'min',1,'max',15); 
       
        h.Popup2Zscore = uicontrol(h.LayoutZscore,'Style','popup',...
                'String',{'Select how to work','Average parameters of all selected days','All parameters of selected days'},...
                'Value',1,'Position',[550,220,250,20],'FontSize',9);
            
            
            
        h.Popup3Zscore = uicontrol(h.LayoutZscore,'Style','popup',...
                'String',{'Select score method','Average Elorating score','David score ranking','Last day elorating'},...
                'Value',1,'Position',[550,180,250,20],'FontSize',9);
       
%    %create to save the data
%    
%   uicontrol(h.LayoutZscore,'Style', 'pushbutton','units','pixels','position',[30,100,40,60],'callback',SaveDirectory,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
%   uicontrol(h.LayoutZscore,'Style', 'text', 'String','3- Select the folder to save the excel file','position',[0,80,120,40],'FontSize',9,'ForegroundColor','blue')
%  h.editSave=uicontrol(h.LayoutZscore,'Style','edit','String',' ','position',[90,120,400,30]);   
%        
%    %add check button for graphs
%  h.checkbox1=uicontrol(h.LayoutZscore,'Style','checkbox','Value',1,'position',[50,10,400,40],'string','Plot each one of the parameters without running for','FontSize',10,'ForegroundColor','blue');  
  h.editMouseZscore=uicontrol(h.LayoutZscore,'Style','edit','position',[460,37,30,40],'string','5','FontSize',10,'ForegroundColor','black');  
   uicontrol(h.LayoutZscore,'Style','text','position',[370,30,40,40],'string','Days','FontSize',10,'ForegroundColor','blue'); 
    h.editDaysZscoref=uicontrol(h.LayoutZscore,'Style','edit','position',[250,37,30,40],'string','1','FontSize',10,'ForegroundColor','black');
     h.editDaysZscoret=uicontrol(h.LayoutZscore,'Style','edit','position',[320,37,30,40],'string','6','FontSize',10,'ForegroundColor','black');  
   uicontrol(h.LayoutZscore,'Style','text','position',[500,30,40,40],'string','Mice','FontSize',10,'ForegroundColor','blue'); 
   uicontrol(h.LayoutZscore,'Style', 'text', 'String','4- Select the number Mice/Days from-to','position',[10,30,200,40],'FontSize',9,'ForegroundColor','blue')

%  %add to run only the parameters
%  h.checkbox2=uicontrol(h.LayoutZscore,'Style','checkbox','Value',1,'position',[50,40,400,40],'string','Run parameters without plot','FontSize',10,'ForegroundColor','blue');  
%      
%    
   
       %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.LayoutZscore,'Style', 'pushbutton','String', '','position',[740,340,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

end
%% Auxiliary functions
function LoadFile(~,~)
%load data
global h

[Filename,Pathname]=uigetfile('*.xlsx','Set the path of your excel file with the parameters of all the experiments');
set( h.editRunParamsZscore,'string',fullfile(Pathname,Filename));

%% ----------Open file and read the sheets----------------------
[status,sheets] = xlsfinfo(fullfile(Pathname,Filename));

% length(ListFiles([ListFiles.isdir]))
% 
% for i=3:length(ListFiles([ListFiles.isdir]))
% Flag=(ListFiles(i).isdir);
% if Flag==1
% subfolders{i-2}=ListFiles(i).name;
% end
% 
% end
% 
set(h.listRunParamsZscore,'string',sheets);

%% ----------------------Set the list of all the parameters-------------------


%Find at least one sheets with experiments
for i=1:length(sheets)
   if ~isempty(strfind(char(sheets(i)),'Exp')) 
    break
   end
    
end
 [num,txt,raw]=xlsread(fullfile(Pathname,Filename),char(sheets(i)));

A=strcmp(txt(:,1),''); 
ListParameters= (txt(~A,1));


set(h.listParamsZscore,'string',ListParameters);


end

%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information
winopen(strcat(root_folder,'HelpDocuments','\','Clustering Analysis.docx'));


end
%% 
function SaveDirectory(~,~)
global h

directory_name=uigetdir('','Set the path of your folder for the output excel file');
set( h.editSave,'string',directory_name);


end