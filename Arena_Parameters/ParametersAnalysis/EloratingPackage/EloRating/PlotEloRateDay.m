function PlotEloRateDay(EloeDayTotalOrder,EloMatrixOrder,MouseID,NumberDaysExp,Filename)
%% Variable
global h

%% 

tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);




%% Find in array contain the pvalues of the randomization -pvalue less than 0.05



%% Create the figure elo per day and all the elo
if get(h.Checkbox2,'Value') == 1
subplot(2,1,2) %plot Elo per day
colors={'k','blue','green','magenta','red','yellow'};
j=0;
for i=2:length(MouseID)+1
    j=j+1; 
    T=char(EloeDayTotalOrder(1,i));
p=plot(cell2mat(EloeDayTotalOrder(2:end,1)),cell2mat(EloeDayTotalOrder(2:end,i)),'-*','MarkerSize',13,'DisplayName',T(5:end),'color',colors{j});
lgd=legend('-DynamicLegend','Location','northeastoutside');
lgd.FontSize=14;
hold all;
title('Elo-rating per day','FontSize',12)
xlabel('Days','FontSize',12)
ylabel('Elo-rating','FontSize',12)
% l=size(EloeDayTotalOrder,1);
% x=cell2mat(EloeDayTotalOrder(l-1,1));
% y=cell2mat(EloeDayTotalOrder(l,i));
% text(x,y,EloeDayTotalOrder(1,i),'FontSize',12)
end  

hold on;
%%
%Add markers
% for i=2:NumberDaysExp+1 %loop during the day
%     row=[];
%     col=[];
%     i
%     A=[];
%     A=(SaveArrayAux(2:length(MouseID)+1,2:length(MouseID)+1,i))
%   isnumeric(A)
%     
% [row,col]=find(cell2mat(A)<0.05)    %find indexes less than 5percentage
%     
%  for j=1:length(row)
%    x=cell2mat(EloeDayTotalOrder(i,1));%represent the day
% y=cell2mat(EloeDayTotalOrder(i,row(j)+1));
% text(x,y,'*','FontSize',12)  
%      
%      
%      
%  end
% end





%% 



subplot(2,1,1)%plot per event
%find Events column
IndexEvents=find(strcmp(EloMatrixOrder(1,:),'Events')==1);
 IndexDay1=find(strcmp(EloMatrixOrder(1,:),'Day')==1);
IndexFirstDay=find(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexDay1))==1);

colors={'k','blue','green','magenta','red','yellow'};
j=0;
for i=4:length(MouseID)+3
    j=j+1; 
    T=char(EloMatrixOrder(1,i));
p=plot(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexEvents)),cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,i)),'DisplayName',T(5:end),'color',colors{j});
lgd1=legend('-DynamicLegend','Location','northeastoutside');
lgd1.FontSize=14;
hold all;
title('Elo-rating per event','FontSize',12)
xlabel('Events','FontSize',12)
ylabel('Elo-rating','FontSize',12)
% l=size(EloMatrixOrder,1);
% x=cell2mat(EloMatrixOrder(l-2,IndexEvents));
% y=cell2mat(EloMatrixOrder(l-2,i));
% text(x,y,EloMatrixOrder(1,i),'FontSize',12)
end 
plot(cell2mat(EloMatrixOrder(length(IndexFirstDay),IndexEvents))*ones(1,length([600 1200])),[600 1200],'--','LineWidth',2);
else
  IndexEvents=find(strcmp(EloMatrixOrder(1,:),'Events')==1);


for i=4:length(MouseID)+3
p=plot(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexEvents)),cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,i)));
hold all;
title('Elo-rating per event','FontSize',12)
xlabel('Events','FontSize',12)
ylabel('Elo-rating','FontSize',12)
l=size(EloMatrixOrder,1);
x=cell2mat(EloMatrixOrder(l-2,IndexEvents));
y=cell2mat(EloMatrixOrder(l-2,i));
text(x,y,EloMatrixOrder(1,i),'FontSize',13)
end 
  
    
    
    
end




%% 

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

