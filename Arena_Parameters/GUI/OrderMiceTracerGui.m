function [ output_args ] = OrderMiceTracerGui( ~,~)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global h
global Image6
%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Reorder the data from the mice tracer program',...
                                    'Position',[320 320 900 300]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','1- Set the path of your folder with mice tracer data','position',[10,260,300,30],'callback',@LoadDataeditOrder)
 h.editOrder=uicontrol(h.Layout,'Style','edit','String',' ','position',[350,260,400,30]);    
 
%Create edit for experiment name
 uicontrol(h.Layout,'Style','text','String','2- Experiment name ','position',[20,230,100,30]); 
h.editOrderName=uicontrol(h.Layout,'Style','edit','String','Exp50L','position',[20,210,100,30]); 
 
%Create pushbutton to save
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','3- Set the path of your output folder called Data','position',[10,150,300,30],'callback',@LoadDataeditOrder1)
 h.editOrder1=uicontrol(h.Layout,'Style','edit','String',' ','position',[350,150,400,30]); 
 %create pushbutton
  uicontrol(h.Layout,'Style', 'pushbutton', 'String','4- Order the data from the mice trace','position',[10,100,300,30],'callback',@OrderData)
  
  
          %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[850,230,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

 

end
%% Auxiliary functions
function LoadDataeditOrder(~,~)
%load data
global h

folder_name=uigetdir('','Set the path of your folder with mice tracer folders');
set(h.editOrder,'string',folder_name);

end

function LoadDataeditOrder1(~,~)
%load data
global h

folder_name=uigetdir('','Set the path of your output folder called data');
set(h.editOrder1,'string',folder_name);

end
%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information

winopen(strcat(root_folder,'HelpDocuments','\','Module Treat Data.docx'));

end


