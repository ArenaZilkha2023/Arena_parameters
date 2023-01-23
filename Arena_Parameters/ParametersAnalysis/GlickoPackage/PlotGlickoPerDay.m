function PlotGlickoPerDay(GlickoMatrix,GlickoMatrixRD,MouseID,filename)
tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);
%%
% Order according to final glicko.
Aux=GlickoMatrix(size(GlickoMatrix,1),2:size(GlickoMatrix,2)); %final row of the last day
[Gsorted,Isort]=sort(cell2mat(Aux),'descend');
AuxR=GlickoMatrix(2:size(GlickoMatrix,1),2:size(GlickoMatrix,2));
AuxE=GlickoMatrixRD(2:size(GlickoMatrixRD,1),2:size(GlickoMatrixRD,2));

GlickoMatrix(2:size(GlickoMatrix,1),2:size(GlickoMatrix,2))=AuxR(:,Isort);
GlickoMatrixRD(2:size(GlickoMatrixRD,1),2:size(GlickoMatrixRD,2))=AuxE(:,Isort);

%% 
%for i=4:length(MouseID)+3
colors={'k','blue','green','magenta','red','yellow'};
j=1;
for column=2:size(GlickoMatrix,2)
T=char(GlickoMatrix(1,Isort(j)+1));    
p=plot(cell2mat(GlickoMatrix(2:size(GlickoMatrix,1),1)),cell2mat(GlickoMatrix(2:size(GlickoMatrix,1),column)),'-*','MarkerSize',15,'DisplayName',T(5:end),'color',colors{j});
%e=errorbar(cell2mat(GlickoMatrix(2:size(GlickoMatrix,1),1)),cell2mat(GlickoMatrix(2:size(GlickoMatrix,1),column)),cell2mat(GlickoMatrixRD(2:size(GlickoMatrixRD,1),column)),'s','MarkerSize',10,...
 %   'MarkerEdgeColor','K',...
  %  'MarkerFaceColor','K');
%e.Color=colors{j};
j=j+1;
lgd=legend('-DynamicLegend','Location','northeastoutside');
lgd.FontSize=14;
hold all;
title('Glicko-rating per day','FontSize',12)
xlabel('Days','FontSize',12)
ylabel('Glicko-rating','FontSize',12)

% x=cell2mat(GlickoMatrix(l-2,IndexEvents));
% y=cell2mat(GlickoMatrix(l-2,i));
% text(x,y,GlickoMatrix(1,i),'FontSize',12)

end 

%% 


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
%% Add another figure -Plot final ranking with sd as from glicko use final values
tempfigfileS=[tempname '.png'];
tempS=figure;
set (tempS, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);

Gsorted=GlickoMatrix(size(GlickoMatrix,1),2:size(GlickoMatrix,2));
err=GlickoMatrixRD(size(GlickoMatrixRD,1),2:size(GlickoMatrixRD,2));
x=[1:length(Gsorted)];
% p2=plot(Gsorted,'s','MarkerSize',10,...
%     'MarkerEdgeColor','K',...
%     'MarkerFaceColor','K')

e=errorbar(x,cell2mat(Gsorted),cell2mat(err),'s','MarkerSize',10,...
    'MarkerEdgeColor','K',...
    'MarkerFaceColor','K');
e.Color='K';
xlim([0 length(Gsorted)+1]);

Xtick=[1:length(Gsorted)];
M=[{''};MouseID(Isort)];
xticklabels(M)
xtickangle(45)
ylabel('Final Glicko Rating Last Day')
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

% Sheets = Excel.ActiveWorkBook.Sheets;
% graphSheet = get(Sheets, 'Item', 'FinalGlickoRatingPerDay');
% graphSheet.Activate;

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfileS,0,1,50,18,300,235);
exl2.visible=1;
invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')


end



