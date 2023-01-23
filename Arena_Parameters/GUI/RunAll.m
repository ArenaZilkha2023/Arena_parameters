function [ output_args ] = RunAll(~,~)

global h

%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Get locomotion parameters',...
                                    'Position',[320 320 900 300]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Open the folder named Data which include Exp#Video,Exp#RFID, parameters ','position',[10,260,400,30],'FontSize',9,'ForegroundColor','blue','callback',@LoadData)
 h.edit1=uicontrol(h.Layout,'Style','edit','String',' ','position',[420,260,400,30]);                           
%Create edit for experiment name
 uicontrol(h.Layout,'Style','text','String','2- Experiment name ','position',[20,230,100,30],'FontSize',9,'ForegroundColor','black'); 
h.edit2=uicontrol(h.Layout,'Style','edit','String','Exp50L','position',[20,210,100,30]); 

uicontrol(h.Layout,'Style', 'pushbutton','String', '3- Select the miceID sheet','position',[250,210,200,30],'FontSize',9,'ForegroundColor','blue','callback',@RetrieveData)

uicontrol(h.Layout,'Style','text','String','4- Select the parameters to be saved in an excel file ','FontSize',9,'ForegroundColor','blue','position',[10,100,200,80]); 
h.listAll=uicontrol(h.Layout,'Style','list','String',{'Chasing events'},'position',[10,120,200,30],'max',10,'min',1);

 uicontrol(h.Layout,'Style', 'pushbutton', 'String','5-Select folder of the excel file','position',[250,120,200,30],'FontSize',9,'ForegroundColor','blue','callback',@LoadDataExcel)
 h.edit3x=uicontrol(h.Layout,'Style','edit','String',' ','position',[450,120,400,30]);  

uicontrol(h.Layout,'Style', 'pushbutton','String', '6- Run for locomotion parameters','position',[10,50,200,40],'FontSize',9,'ForegroundColor','black','callback',@computeAllGV)

end

%% Auxiliary data
function [ output_args ] = RetrieveData(~,~)
global h
DIR=get(h.edit1,'string') %load directory
[status,sheets] = xlsfinfo([DIR,'\','Parameters','\','MiceID.xlsx'])
%create list of sheets with the names
 % Create pop-up menu
    h.popupmenu1 = uicontrol(h.Layout,'Style', 'popup',...
           'String', sheets,...
           'Position', [450,210,200,30]); 
end
%% 
function LoadDataExcel(~,~)

global h

folder_name=uigetdir('','Select the folder for your excel file');
set(h.edit3x,'string',folder_name);

end
