function [ output_args ] = RunIndividually(~,~)

global h

%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Get locomotion parameters for a given mouse',...
                                    'Position',[320 320 800 300]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Set the path of your folder','position',[10,260,200,30],'callback',@LoadDataFile)
 h.editLoc1=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,260,400,30]);                           

uicontrol(h.Layout,'Style', 'text','String','2- Select the mouse ID','position',[10,200,200,30])
h.popmenuLoc1=uicontrol(h.Layout,'Style', 'popup','String',{' '} ,'position',[10,180,200,30])

 uicontrol(h.Layout,'Style', 'pushbutton', 'String','3- Set the directory of your final file','position',[10,120,200,30],'callback',@LoadDirectory)
 h.editLoc2=uicontrol(h.Layout,'Style','edit','String',' ','position',[220,120,400,30]); 

uicontrol(h.Layout,'Style', 'pushbutton','String', '4- Run for locomotion parameters','position',[10,50,200,40],'callback',@computeIndLocParameters)

end

%% Auxiliary functions
function LoadDirectory(~,~)
%load data
global h

directory_name=uigetdir('','Set the path of your directory to save the final file');
set(h.editLoc2,'string',directory_name);

end

%% 

%

%% 
