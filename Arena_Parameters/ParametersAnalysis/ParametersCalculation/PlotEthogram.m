function PlotEthogram(SaveFolder,SelectedExperiments)
% Plot ethogram for each mouse.Each row of the ethogram corresponds to a
% locomotion feature while column represents 1hour of testing.Color
% represents the percentage of time the mouse enganged in a given behaviour

%% 

global h

%% --Variables--
NumberMice=str2num(get(h.editMouse,'string'));%number of mice to plot
Days=str2num(get(h.editDays,'string'))%number of days to plot

%Plot parameters-Add to excel file
%--for saving into excel file create temp file for each exp---------------
Filename=strcat(SaveFolder,'AllTheParameters.xlsx')

tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,1,1]);
hbar = waitbar(0,'Please wait...');
%% ------Load data as matrix---------
load(strcat(SaveFolder,SelectedExperiments,'AllTheParameters.mat'),'Allparameters')

%% ---------Current Figure---------------------
 set(0,'CurrentFigure',temp)
%% -------------Loop over every mouse------------------
   % Divide by the total time
    %TotalTimeAux=cumsum(Allparameters.HourDetection);
    %TotalTime= TotalTimeAux(length(TotalTimeAux)); % it is in minutes
    %MatrixTime=(Allparameters.ParamsPerHour/TotalTime)*100
    MatrixTime=Allparameters.ParamsPerHour;
    IndexOrder=Allparameters.IndexDominance;
    MatrixTime=MatrixTime(IndexOrder,:,:); %order rows data according to dominant mouse 
    MiceList=Allparameters.MiceList;
    MiceList=MiceList(IndexOrder);
    TimeT=repmat(Allparameters.HourDetection,size(Allparameters.ParametersUsed,1),1);
    headersTime=cumsum(TimeT(1,:))/60;
    rangeParameters=[1:size(Allparameters.ParametersUsed,1)];%depends the parameters to draw
for countMouse=1:NumberMice
     % reset arrays
     DataMouse=[];
     subplot(NumberMice,1,countMouse)
     % Select given locomotion parameters 1 to twelve
      % DataMouse=reshape(MatrixTime(countMouse,1:size(Allparameters.ParametersUsed,1),:),size(MatrixTime(countMouse,1:size(Allparameters.ParametersUsed,1),:),2),size(MatrixTime(countMouse,1:size(Allparameters.ParametersUsed,1),:),3));
      DataMouse=reshape(MatrixTime(countMouse,rangeParameters,:),size(MatrixTime(countMouse,rangeParameters,:),2),size(MatrixTime(countMouse,rangeParameters,:),3));
       % Normalization per hour 
       DataMouse=(DataMouse./TimeT)*100;
        % Select given locomotion parameters 1 to twelve
   clmin=0;
   clmax=100;
    % arrange images with rows parameters and columns hours.
       imagesc(DataMouse,[clmin,clmax]);
         colormap(jet(100))
         c=colorbar;
       set(gca,'XTick',headersTime,...                         %# Change the axes tick marks
        'YTick',1:size(Allparameters.ParametersUsed,1), 'YTickLabel',Allparameters.ParametersUsed(:,1),...
        'TickLength',[0 0],'FontSize',8);
    title(char(MiceList(countMouse)))
    c.Label.String = '% 1hour detection';
end

xlabel('time (hours)')
%%
close(hbar)

%% To save into the excel files
print(temp,'-dpng',tempfigfile);

%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile,0,1,50,18,1000,500);

graphSheet.Name=strcat(char(SelectedExperiments),'Ethogram');
exl2.visible=1;


invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

end