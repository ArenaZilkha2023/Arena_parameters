function ReadMovie(~,~)
%variables
global h
global Image2
global Image3
global Image4
global Image5
global Image7
%% 
 % Create new figure
       
           
               h.FigVideo = figure('numbertitle', 'off', ...
               'name', 'Social events', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'renderer','painters', ...
               'position',[100 80 1000 900]);

        % Create axes and titles
        h.axis1 = createPanelAxisTitle(h.FigVideo,[0.1 0.12 0.75 0.75],'Original Video');
                                

        Next_handles=create_push_directory(h.FigVideo); 
        
      %Create start and next button
      %% 
     h.StartButton=uicontrol(h.FigVideo,'Style', 'pushbutton','units','pixels',.....
    'tag','Directory',...
    'callback',@StartButton,'cdata',Image4,...
    'position',[300,20,40,60],'Visible','on');
     
   
      
      
      %% 
      
      h.NextButton=uicontrol(h.FigVideo,'Style', 'pushbutton','units','pixels',.....
    'tag','Directory',...
    'callback',@NextEvent,'cdata',Image3,...
    'position',[500,20,40,60],'Visible','on');
     
    uicontrol(h.FigVideo,'Style', 'text','units','pixels',.....
    'string','Next social Event',...
    'position',[450,-1.5,150,30],'FontSize',9,'ForegroundColor','blue');





%-------------------for editing the number  of event------------------------
     h.editNumberEvents=uicontrol(h.FigVideo,'Style', 'edit','units','pixels',.....
    'string','1',...
    'position',[800,830,60,40],'FontSize',9,'ForegroundColor','blue');

     uicontrol(h.FigVideo,'Style', 'text','units','pixels',.....
    'string','Number of social events',...
    'position',[770,870,150,20],'FontSize',9,'ForegroundColor','blue');



%-------------------------------------Add a slider to the-------
   h.slider=uicontrol(h.FigVideo,'Style', 'slider','units','pixels',.....
    'position',[100,90,750,20],'FontSize',9,'ForegroundColor','blue','callback',@MoveFramesP);
%    hLstn = handle.listener(h.slider,'ActionEvent',@MoveFrames);
  %---------------------------------Add experiment name---------------------- 
   h.editExpName=uicontrol(h.FigVideo,'Style', 'edit','units','pixels',.....
    'string','Exp51L',...
    'position',[660,810,80,30],'FontSize',9,'ForegroundColor','red');

    uicontrol(h.FigVideo,'Style', 'text','units','pixels',.....
    'string','Number of exp.',...
    'position',[630,840,150,30],'FontSize',9,'ForegroundColor','red');
%% --------Add button to correct your events-----------------
  uicontrol(h.FigVideo,'Style', 'text','units','pixels',.....
    'tag','Directory','string','Correct social events','ForegroundColor','red','FontSize',10,...
    'callback',@ButtonCorrections,'position',[850,700,150,50],'Visible','on');
    
    % Create pop-up menu
  h.PopupCorrectionsEvents = uicontrol('Style', 'popup',...
           'String', {'Change your event as','No','Reverse'},...
           'Position', [850,670,150,50]);
             
   h.okStartButton=uicontrol('Style', 'pushbutton','units','pixels',.....
    'tag','Directory',...
    'callback',@SaveCorrectChasingP,'cdata',Image5,...
    'position',[900,660,20,30]);
%%
%%------------Create button to create a movie with the events---------

   
end
%% Auxiliary functions
%--------------------Create panel for video------------------------
 function hAxis = createPanelAxisTitle(hFig, pos, axisTitle)

        % Create panel
        hPanel = uipanel('parent',hFig,'Position',pos,'Units','Normalized');

        % Create axis
        hAxis = axes('position',[0 0 1 1],'Parent',hPanel);
        hAxis.XTick = [];
        hAxis.YTick = [];
        hAxis.XColor = [1 1 1];
        hAxis.YColor = [1 1 1];
        % Set video title using uicontrol. uicontrol is used so that text
        % can be positioned in the context of the figure, not the axis.
        titlePos = [pos(1)+0.02 pos(2)+pos(3)+0.3 0.3 0.07];
        uicontrol('style','text',...
            'String', axisTitle,...
            'Units','Normalized',...
            'Parent',hFig,'Position', titlePos,...
            'BackgroundColor',hFig.Color);
 end
    
 %% 
 %-------------------------Create 2 push button for loading excel and video information-----------------------------
 function Dir_handles=create_push_directory(Figure_handles)
 global Image2
 global h
    Dir_handles=uicontrol(Figure_handles,'Style', 'pushbutton','units','pixels',.....
    'tag','Directory',...
    'callback',@LoadChasingFile,'cdata',Image2,...
    'position',[160,840,40,60]);
    
   uicontrol(Figure_handles,'Style', 'text','units','pixels',.....
    'string','1-Load the excel file with your social events',...
    'position',[10,850,150,30],'FontSize',9,'ForegroundColor','blue');

   h.editExcelChasing=uicontrol(h.FigVideo,'Style','edit','String',' ','position',[220,860,400,30]);
   %% 
     %% 
       Dir_handles=uicontrol(Figure_handles,'Style', 'pushbutton','units','pixels',.....
    'tag','Directory',...
    'callback',@LoadDataDirectory,'cdata',Image2,...
    'position',[160,780,40,60]);
    
   uicontrol(Figure_handles,'Style', 'text','units','pixels',.....
    'string','2-Open the folder with the movies',...
    'position',[10,800,150,30],'FontSize',9,'ForegroundColor','blue');

   h.editLoadDirectory=uicontrol(h.FigVideo,'Style','edit','String',' ','position',[220,800,400,30]);
 

 end

 
 %% 
  %-------------------------Load excel file-----------------------------
  function LoadChasingFile(~,~)
  global h
  
  [FileName,PathName]=uigetfile('*.xlsx','Load the excel file with a sheet called social');
  filename=strcat(PathName,FileName);
  set(h.editExcelChasing,'string',filename);

  
  
  
  end
  %% 
    function LoadDataDirectory(~,~)
  global h
  
  folder_name=uigetdir(' ','Open the folder with the video avi and excel files of all the experiment');

  set( h.editLoadDirectory,'string', folder_name);

  
  
  
  end
  
  
  
  %% 
    %-------------------------Change event and activate program-----------------------------
    
    function NextEvent(~,~)
    global h
    i=str2num(get(h.editNumberEvents,'string'));
    set(h.editNumberEvents,'string',num2str(i+1));
  
    MainValidationP()
    end
    
    %% 
        %-------------------------Start first event and activate program-----------------------------
    
    function StartButton(~,~)
    global h
    
    MainValidationP()
    end
    
  
 




