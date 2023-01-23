function [ output_args ] = RunAllAddingRFID(~,~)

global h
global Image2
global Image3
global Image6
%% Creation of a figure
h.Layout= figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                   'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Get locomotion parameters',...
                                    'Position',[320 320 1000 700]);
                                

 

                                
 %% Create pushbutton
 uicontrol(h.Layout,'Style', 'pushbutton', 'String','','position',[150,640,40,60],'FontSize',9,'ForegroundColor','blue','callback',@LoadDataAllRFID,'cdata',Image2)
 uicontrol(h.Layout,'Style', 'text', 'String','2- Open the folder with RFID,Video,Avi data','position',[100,600,150,40],'FontSize',9,'ForegroundColor','blue')
 h.editAllRFID1=uicontrol(h.Layout,'Style','edit','String',' ','position',[210,660,400,30]);   
 
%Create edit for experiment name
 uicontrol(h.Layout,'Style','text','String','1- Experiment name ','position',[20,670,100,30],'FontSize',9,'ForegroundColor','blue'); 
h.editAllRFID2=uicontrol(h.Layout,'Style','edit','String','Exp53L','position',[20,650,100,30]); 

uicontrol(h.Layout,'Style', 'pushbutton','String', '3- Select the miceID sheet','position',[200,540,200,30],'FontSize',9,'ForegroundColor','blue','BackgroundColor','magenta','callback',@RetrieveData)

uicontrol(h.Layout,'Style','text','String','3- Select males or females to analyze ','FontSize',9,'ForegroundColor','blue','position',[20,520,200,80]); 
h.popupAll=uicontrol(h.Layout,'Style','popup','String',{'male','female'},'position',[70,540,60,30],'max',100,'min',1);


% uicontrol(h.Layout,'Style','text','String','5- Select the parameters to be saved in an excel file ','FontSize',9,'ForegroundColor','blue','position',[10,400,200,80]); 
% h.listAll=uicontrol(h.Layout,'Style','list','String',{'Chasing events'},'position',[10,420,200,30],'max',100,'min',1);


h.ChasingParams=uipanel('Parent',h.Layout,'Title','Chasing Parameters','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[20,5,450,350]);
%%
%%-------------------------------- All the chasing parameters--------------------------
  uicontrol(h.ChasingParams,'Style','text','String','Angle(degree) between line joining mice 1-2 and movement vector of mice 1','position',[10,280,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editChasingAng1=uicontrol(h.ChasingParams,'Style','edit','String','20','position',[250,300,60,20]);                                

   uicontrol(h.ChasingParams,'Style','text','String','Angle(degree) between movement vector of mice 1 and movement vector of mice 2','position',[10,230,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editChasingAng2=uicontrol(h.ChasingParams,'Style','edit','String','20','position',[250,250,60,20]); 

   uicontrol(h.ChasingParams,'Style','text','String','Minimum path in (mm) to be considered as chasing','position',[10,180,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editpar1=uicontrol(h.ChasingParams,'Style','edit','String','200','position',[250,200,60,20]); 

   uicontrol(h.ChasingParams,'Style','text','String','Maximum distance between trajectory of the mice 1-2 to be considered chasing (mm)','position',[10,140,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editpar2=uicontrol(h.ChasingParams,'Style','edit','String','400','position',[250,160,60,20]); 
  
   uicontrol(h.ChasingParams,'Style','text','String','Velocity Threshold of mice 1-2 (cm/sec)','position',[10,90,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editpar3=uicontrol(h.ChasingParams,'Style','edit','String','10','position',[250,120,60,20]);
  
     uicontrol(h.ChasingParams,'Style','text','String','Maximum number of frames allowed to join events','position',[10,50,200,50],'FontSize',8.7,'ForegroundColor','blue');  
  h.editpar4=uicontrol(h.ChasingParams,'Style','edit','String','100','position',[250,70,60,20]);
  
       uicontrol(h.ChasingParams,'Style','text','String','Maximum trajectory allowed to join events between frames (mm)','position',[10,0,200,50],'FontSize',8.7,'ForegroundColor','blue');  
 h.editpar5=uicontrol(h.ChasingParams,'Style','edit','String','400','position',[250,19,60,20]);



%      uicontrol(h.ChasingParams,'Style','text','String','Maximum number of frames allowed to join  SMALL events','position',[310,50,200,50],'FontSize',8.7,'ForegroundColor','blue');  
%   h.editpar6=uicontrol(h.ChasingParams,'Style','edit','String','50','position',[550,70,60,20]);
%   
%        uicontrol(h.ChasingParams,'Style','text','String','Maximum trajectory allowed to join SMALL events between frames (mm)','position',[310,0,200,50],'FontSize',8.7,'ForegroundColor','blue');  
%  h.editpar7=uicontrol(h.ChasingParams,'Style','edit','String','400','position',[550,19,60,20]);
 %% -------------------------Avoidance parameters---------------------------
% h.AvoidanceParams=uipanel('Parent',h.Layout,'Title','Avoidance Parameters','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[680,5,150,300]);
% 
%  uicontrol(h.AvoidanceParams,'Style','text','String','Max. distance between mice to be considered avoiding event(mm)','position',[0,230,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Avoidance1=uicontrol(h.AvoidanceParams,'Style','edit','String','400','position',[25,210,60,20]); 
%  
%  uicontrol(h.AvoidanceParams,'Style','text','String','Velocity of avoiding (cm/sec)','position',[0,70,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Avoidance2=uicontrol(h.AvoidanceParams,'Style','edit','String','35','position',[25,70,60,20]);  
%  
%   uicontrol(h.AvoidanceParams,'Style','text','String','Radius for avoiding (mm)','position',[0,20,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Avoidance3=uicontrol(h.AvoidanceParams,'Style','edit','String','300','position',[25,20,60,20]); 
%  
%    uicontrol(h.AvoidanceParams,'Style','text','String','Fine tuning of the distance for avoiding event (mm)','position',[0,130,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Avoidance4=uicontrol(h.AvoidanceParams,'Style','edit','String','100','position',[25,120,60,20]); 
%% %% -------------------------Approaching/Avoiding parameters---------------------------
h.ApproachingParams=uipanel('Parent',h.Layout,'Title','Approaching/Avoiding Parameters','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[500,10,200,300]);
 
 uicontrol(h.ApproachingParams,'Style','text','String','Max. distance between mice to be considered approaching event(mm)','position',[0,230,150,50],'FontSize',8,'ForegroundColor','blue');  
 h.Approaching1=uicontrol(h.ApproachingParams,'Style','edit','String','50','position',[25,210,60,20]); 
 
%  uicontrol(h.ApproachingParams,'Style','text','String','Correlation factor between mice','position',[0,70,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Approaching2=uicontrol(h.ApproachingParams,'Style','edit','String','0.3','position',[25,70,60,20]);  

  uicontrol(h.ApproachingParams,'Style','text','String','Velocity of the approached mouse (cm/sec)','position',[0,70,150,50],'FontSize',8,'ForegroundColor','blue');  
  h.Approaching2=uicontrol(h.ApproachingParams,'Style','edit','String','0.5','position',[25,70,60,20]);  

 
  uicontrol(h.ApproachingParams,'Style','text','String','Velocity of the mouse approaching (cm/sec)','position',[0,20,150,50],'FontSize',8,'ForegroundColor','blue');  
 h.Approaching3=uicontrol(h.ApproachingParams,'Style','edit','String','25','position',[25,20,60,20]); 
 
%    uicontrol(h.ApproachingParams,'Style','text','String','Fine tuning of the distance for approaching event (mm)','position',[0,130,150,50],'FontSize',8,'ForegroundColor','blue');  
%  h.Approaching4=uicontrol(h.ApproachingParams,'Style','edit','String','100','position',[25,120,60,20]); 
   uicontrol(h.ApproachingParams,'Style','text','String','Approaching angle (degree)','position',[0,130,150,50],'FontSize',8,'ForegroundColor','blue');  
 h.Approaching4=uicontrol(h.ApproachingParams,'Style','edit','String','5','position',[25,120,60,20]); 
 %% ----------------------------Head head /tail parameters----------------------------------------
h.BodyPosParams=uipanel('Parent',h.Layout,'Title','Head-Head/ Head-Tail Parameters','FontSize',9,'ForegroundColor','magenta','Units','pixels','Position',[750,10,200,300]);
 h.CheckboxBodyParams = uicontrol(h.BodyPosParams,'Style','checkbox',...
                'String','Add mouse body position',...
                'Value',0,'Position',[10,250,200,30],'FontSize',9);
 uicontrol(h.BodyPosParams,'Style','text','String','Distance between mice (mm)','position',[10,180,150,50],'FontSize',9,'ForegroundColor','blue');  
 h.bodyDist=uicontrol(h.BodyPosParams,'Style','edit','String','20','position',[55,170,60,20]);           
%% 

 uicontrol(h.Layout,'Style', 'pushbutton', 'String','','position',[80,420,40,60],'FontSize',9,'ForegroundColor','blue','callback',@LoadDataExcel,'cdata',Image2)
  uicontrol(h.Layout,'Style', 'text', 'String','5- Select the folder for saving Chasing/Avoiding/Approaching events','position',[20,380,200,40],'FontSize',8,'ForegroundColor','blue')
 h.edit3x=uicontrol(h.Layout,'Style','edit','String',' ','position',[150,420,400,30]);  
uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[700,350,40,60],'FontSize',9,'ForegroundColor','black','callback',@ManagerComputeAll,'cdata',Image3)

 uicontrol(h.Layout,'Style', 'text', 'String','6- Run all the parameters','position',[650,310,150,40],'FontSize',9,'ForegroundColor','blue')
 %% 
 %% 
        %% ----------------------Create pushbutton to open a word document which explains the gui---
 uicontrol(h.Layout,'Style', 'pushbutton','String', '','position',[740,640,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)      

 
 %% ----------------to accept validation
 h.Checkbox2 = uicontrol(h.Layout,'Style','checkbox',...
                'String','',...
                'Value',0,'Position',[480,630,40,30],'FontSize',9);
 
 uicontrol(h.Layout,'Style','text','String','4- For validation select experiments','FontSize',9,'ForegroundColor','blue','position',[500,570,200,80]); 
h.listAllRFID=uicontrol(h.Layout,'Style','list','String',{'All'},'position',[500,500,200,100],'max',100,'min',1);
 
 %In the case we want to add missing white
%  h.Checkbox3 = uicontrol(h.Layout,'Style','checkbox',...
%                 'String','',...
%                 'Value',0,'Position',[505,600,40,30],'FontSize',9);
%             
%              uicontrol(h.Layout,'Style','text','String','Add information of missing position','FontSize',8,'ForegroundColor','blue','position',[520,600,200,20]);
end

%% Auxiliary data
function [ output_args ] = RetrieveData(~,~)
global h
DIR=get(h.editAllRFID1,'string') %load directory
[status,sheets] = xlsfinfo([DIR,'\','Parameters','\','MiceID.xlsx'])
%create list of sheets with the names
 % Create pop-up menu
    h.popupmenuRFID1 = uicontrol(h.Layout,'Style', 'popup',...
           'String', sheets,...
           'Position', [250,510,200,30]); 
end
%% 
function LoadDataExcel(~,~)

global h

folder_name=uigetdir('','Select the folder for your excel file');
set(h.edit3x,'string',folder_name);

end
%% 
function OpenWordDocument(~,~)
global root_folder
%This function open the word document with all the information

winopen(strcat(root_folder,'HelpDocuments','\','Run all the parameters with RFID.docx'));

end
%% 
function LoadDataAllRFID(~,~)
%load data
global h

folder_name=uigetdir('','Open folder with all your data');
set(h.editAllRFID1,'string',folder_name);
%% Add list of the csv files
strcat(folder_name,'\',get(h.editAllRFID2,'string'),'Video','\*.csv')
List_Files=dir(strcat(folder_name,'\',get(h.editAllRFID2,'string'),'Video','\*.csv'));
A=cell(1,70);
for i=1:length(List_Files)
  
   A(i,:)=cellstr(List_Files(i).name);
end


set(h.listAllRFID,'string',A)

end
