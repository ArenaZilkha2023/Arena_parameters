function  PlotLandauDistribution(LandauCoefAllEventsRandom,LandauCoefPerDayRandom,Filename)
%% Variable
global h

%% 

tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);


%% pl0t
subplot(4,2,1)
histogram(LandauCoefAllEventsRandom)
xlabel('Landau distribution of all events')
ylabel('Counts')
for i=2:size(LandauCoefPerDayRandom,1)
subplot(4,2,i)
histogram(LandauCoefPerDayRandom(i,:))
xlabel(strcat('Landau distribution per day',num2str(i)))
ylabel('Counts')
end
%% 

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

Shapes.AddPicture(tempfigfile,0,1,50,18,300,235);
exl2.visible=1;
invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
end

