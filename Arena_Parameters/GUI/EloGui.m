function [ output_args ] = EloGui(~,~)

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

 uicontrol(h.Layout,'Style', 'pushbutton','units','pixels','position',[30,340,40,60],'callback',@LoadTxtData,'FontSize',9,'ForegroundColor','blue','cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','1- Select files with chasing events','position',[0,300,120,40],'FontSize',9,'ForegroundColor','blue')
 h.editElo1=uicontrol(h.Layout,'Style','popup','String',' ','position',[90,360,400,30]);                           

 uicontrol(h.Layout,'Style', 'text', 'String','Note: The results are saved in the same excel file','position',[530,360,200,30],'FontSize',10,'ForegroundColor','red')
 
% uicontrol(h.Layout,'Style', 'text','String','2- Select the mouse ID','position',[10,200,200,30])
% h.popmenuLoc1=uicontrol(h.Layout,'Style', 'popup','String',{' '} ,'position',[10,180,200,30])

%  uicontrol(h.Layout,'Style', 'pushbutton', 'String','2- Set the directory of your final file','position',[10,200,200,30],'callback',@LoadDirectory)
%  h.editElo2=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,200,400,30]); 
% 
% 
% uicontrol(h.Layout,'Style', 'pushbutton','String', '5- Compute Elo-rating','position',[500,140,200,40],'FontSize',9,'ForegroundColor','blue','callback',@ManagerEloratingAllFiles)
% uicontrol(h.Layout,'Style', 'pushbutton','String', '6- Apply randomization tests to your Elo rating results','position',[300,50,300,40],'FontSize',9,'ForegroundColor','blue','callback',@RunShuffling)


uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[570,40,40,60],'FontSize',9,'ForegroundColor','blue','callback',@ManagerAllFiles,'cdata',Image3)
uicontrol(h.Layout,'Style', 'text', 'String','6- Compute All hierarchical parameters','position',[500,4,200,40],'FontSize',9,'ForegroundColor','blue')

%Create checkbox
uicontrol(h.Layout,'Style', 'text','String', '2- Select the type of Elo-rating','position',[0,250,200,30],'FontSize',10)
h.Checkbox1 = uicontrol(h.Layout,'Style','checkbox',...
                'String','Elo/Glicko-rating per event',...
                'Value',1,'Position',[10,230,400,30],'FontSize',9);
h.Checkbox2 = uicontrol(h.Layout,'Style','checkbox',...
                'String','Elo/Glicko-rating per day',...
                'Value',1,'Position',[10,200,400,30],'FontSize',9);  

            
h.Checkbox3 = uicontrol(h.Layout,'Style','checkbox',...
                'String','Elo/Glicko-rating Significant with randomization test',...
                'Value',1,'Position',[10,170,400,30],'FontSize',9);  
uicontrol(h.Layout,'Style', 'text', 'String','Note: This test is valid if the Elo-rating per day is checked ','position',[0,140,200,30],'FontSize',10,'ForegroundColor','red')


uicontrol(h.Layout,'Style', 'text','String', '5- Select other parameters','position',[-7,80,200,30],'FontSize',10)

h.Checkbox4 = uicontrol(h.Layout,'Style','checkbox',...
                'String','Landau linearity index',...
                'Value',1,'Position',[10,60,400,30],'FontSize',9);
h.Checkbox5 = uicontrol(h.Layout,'Style','checkbox',...
                'String','Stability index',...
                'Value',1,'Position',[10,30,400,30],'FontSize',9);  

% h.Checkbox6 = uicontrol(h.Layout,'Style','checkbox',...
%                 'String','Entropy',...
%                 'Value',1,'Position',[10,0,400,30],'FontSize',9); 



            
%Select parameters for elorating and parameters.

hsp = uipanel(h.Layout,'Title','3-Select constants for Elo/landau index','FontSize',10,'ForegroundColor','blue',...
              'Position',[.47 .3 .30 .50]);

 uicontrol('Parent',hsp,'Style', 'text','String', 'Initial rate of Elo-rating','position',[15,55.1,320,120],'FontSize',8)                            
    h.editEloRate=uicontrol('Parent',hsp,'Style','edit','String','1000 ','position',[120,140,80,20]); 

    uicontrol('Parent',hsp,'Style', 'text','String', 'Constant k of Elo-rating','position',[15,55.1,100,130],'FontSize',8)                            
    h.editElok=uicontrol('Parent',hsp,'Style','edit','String','100','position',[20,140,80,20]); 
    
    uicontrol('Parent',hsp,'Style', 'text','String', 'Number of random iterations for Elo-rating','position',[15,60.1,100,70],'FontSize',8)                            
    h.editShuffling=uicontrol('Parent',hsp,'Style','edit','String','1000','position',[20,75,80,20]); 
    
    uicontrol('Parent',hsp,'Style', 'text','String', 'Number of random iterations for Glicko','position',[15,0.01,100,70],'FontSize',8)                            
    h.editShufflingGlicko=uicontrol('Parent',hsp,'Style','edit','String','1000','position',[20,15,80,20]); 
    
    uicontrol('Parent',hsp,'Style', 'text','String', 'Number of random iterations for Landau','position',[120,0.01,100,70],'FontSize',8)                            
    h.editShufflingLandau=uicontrol('Parent',hsp,'Style','edit','String','10000','position',[125,15,80,20]); 
    %% Select number of days
    % Create pop-up menu
     uicontrol(h.Layout,'Style', 'text', 'String','4-Select the number of days','position',[620,250,150,30],'FontSize',9,'ForegroundColor','blue')
    h.popupmenuDays = uicontrol(h.Layout,'Style', 'popup',...
           'String', ' ',...
           'Position', [670,210,50,30]); 
       %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[740,340,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

end
%% Auxiliary functions
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.editElo2,'string',directory_name);

end

%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information
winopen(strcat(root_folder,'HelpDocuments','\','Hierarchical Analysis.docx'));


end
%% 
