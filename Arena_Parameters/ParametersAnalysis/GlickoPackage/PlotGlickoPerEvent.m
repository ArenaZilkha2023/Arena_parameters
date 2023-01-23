function PlotGlickoPerEvent(GlickoMatrix,MouseID,filename)
tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);
%%  Additional calculations
IndexEvents=find(strcmp(GlickoMatrix(1,:),'Events')==1);
% Order according to final glicko.
[Gsorted,Isort]=sort(cell2mat(GlickoMatrix(size(GlickoMatrix,1),4:length(MouseID)+3)),'descend')
err=cell2mat(GlickoMatrix(size(GlickoMatrix,1),length(MouseID)+4:2*length(MouseID)+3));
err=err(Isort); %after sorted
%% 
%for i=4:length(MouseID)+3
colors={'k','blue','green','magenta','red','yellow'};
j=0;
for i=Isort+3
j=j+1;    
T=char(GlickoMatrix(1,i));    
p=plot(cell2mat(GlickoMatrix(2:size(GlickoMatrix,1)-1,IndexEvents)),cell2mat(GlickoMatrix(2:size(GlickoMatrix,1)-1,i)),'DisplayName',T(5:end),'color',colors{j});
lgd=legend('-DynamicLegend','Location','northeastoutside');
lgd.FontSize=14;
hold all;
title('Glicko-rating per event','FontSize',12)
xlabel('Events','FontSize',12)
ylabel('Glicko-rating','FontSize',12)
l=size(GlickoMatrix,1);
% x=cell2mat(GlickoMatrix(l-2,IndexEvents));
% y=cell2mat(GlickoMatrix(l-2,i));
% text(x,y,GlickoMatrix(1,i),'FontSize',12)

end 
% Add a line of the first day
% Find the last event of first day
%% 
Iaux1=strfind(char(GlickoMatrix(3,1)),'-');
Day=char(GlickoMatrix(3,1));
for i=3:size(GlickoMatrix,1)
DayAll=GlickoMatrix{i,1};

if strcmp(Day(1:Iaux1(1)-1),DayAll(1:Iaux1(1)-1))==0
    break;
end
end
Ifirstday=i-1;
%%
Aux=cell2mat(GlickoMatrix(2:end,4:length(MouseID)+3));
Imax=max(max(Aux));
Imin=min(min(Aux));
plot(cell2mat(GlickoMatrix(Ifirstday,IndexEvents))*ones(length([Imin:Imax]),1),[Imin:Imax],'--','LineWidth',2);

print(temp,'-dpng',tempfigfile);
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=filename;
ResultFile1=strcat('AddGraphs',filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile,0,1,50,18,300,235);

exl2.visible=1;
invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Add another figure -Plot final ranking with sd as from glicko
tempfigfileS=[tempname '.png'];
tempS=figure;
set (tempS, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);
x=[1:length(Gsorted)];
% p2=plot(Gsorted,'s','MarkerSize',10,...
%     'MarkerEdgeColor','K',...
%     'MarkerFaceColor','K')

e=errorbar(x,Gsorted,err,'s','MarkerSize',10,...
    'MarkerEdgeColor','K',...
    'MarkerFaceColor','K');
e.Color='K';
xlim([0 length(Gsorted)+1]);

Xtick=[1:length(Gsorted)];
M=[{''};MouseID(Isort)];
xticklabels(M)
xtickangle(45)
ylabel('Final Glicko Rating')
 hold all
plot([0 length(Gsorted)+1],2200*ones(length([0 length(Gsorted)+1]),1),'--','LineWidth',2,'color','red');

print(tempS,'-dpng',tempfigfileS);

%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=filename;
ResultFile1=strcat('AddGraphs',filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfileS,0,1,50,18,300,235);
exl2.visible=1;
invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

end



