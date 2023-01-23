%GUI to reorder names-By changing the date with the month or viceversa
%Variables
clear all
global h1


[x,map]=imread('open folder.jpg');
Image2=imresize(x, [60 40]);

[x1,map]=imread('start-icon.jpg');
Image3=imresize(x1, [60 40]);
%% Creation of a figure
h1.Layout1= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Select the data to rename',...
                                    'Position',[320 320 800 500]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h1.Layout1,'Style', 'pushbutton', 'String','','position',[40,400,40,60],'FontSize',9,'ForegroundColor','blue','callback',@SelectData,'cdata',Image2)
 uicontrol(h1.Layout1,'Style', 'text', 'String','Select the data to rename','position',[20,350,100,40],'FontSize',9,'ForegroundColor','blue')
 h1.Data=uicontrol(h1.Layout1,'Style','list','String',' ','position',[150,100,300,300]);  
 
 %% 
uicontrol(h1.Layout1,'Style', 'pushbutton','String', '','position',[530,60,40,60],'FontSize',9,'ForegroundColor','blue','callback',@StartToRename,'cdata',Image3)
uicontrol(h1.Layout1,'Style', 'text', 'String','Start to rename','position',[450,10,200,40],'FontSize',9,'ForegroundColor','blue')

 
 