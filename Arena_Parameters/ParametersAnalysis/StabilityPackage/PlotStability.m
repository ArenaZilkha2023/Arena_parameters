function  PlotStability(daysStab,S,filename,mouseiden,Stab);
%% Variable


%% 

tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,0.5,0.5]);


%% pl0t
subplot(2,1,1)
for i=1:size(Stab,2)
  T=char(mouseiden(1,i+1));  
  %% --
  S1=1-Stab(:,i);
  S1x=[1:length(S1)];
    
  %% %--Separate points for plotting
  
p=plot(S1x,S1,'-','DisplayName',T);
 a=get(p,'color')
legend('-DynamicLegend','Location','northeastoutside');
 hold on;
h=plot(S1x(find(S1~=0)),S1(find(S1~=0)),'-');
 set(h,'color',a)
hold all;
title('Stability index of all event','FontSize',12)
xlabel('Events','FontSize',12)
ylabel('1-Stability index','FontSize',12)
ylim([0 1.1])
end



subplot(2,1,2)
for i=1:size(S,2)
  T=char(mouseiden(1,i+1));  
p=plot(daysStab',1-S(:,i),'-*','MarkerSize',12,'DisplayName',T);
legend('-DynamicLegend','Location','northeastoutside');
hold all;
title('Stability index per day','FontSize',12)
xlabel('Days','FontSize',12)
ylabel('1-Stability index','FontSize',12)
ylim([0 1.1])
end

% subplot(2,1,3)
% 
% for i=1:size(Stab,2)
%   T=char(mouseiden(1,i+1));  
%   %% --
% 
%     
%   %% %--Separate points for plotting
%   
% p=plot(S1x,S1,'-','DisplayName',T);
% legend('-DynamicLegend','Location','northeastoutside');
% hold all;
% end
%  hold on;
%    S1=1-Stab(:,i);
%   S1x=[1:length(S1)];
%   h=plot(S1x(find(S1~=0)),S1(find(S1~=0)),'-');
% 
% 
% title('Stability index of all event','FontSize',12)
% xlabel('Events','FontSize',12)
% ylabel('1-Stability index','FontSize',12)
% ylim([0 1.1])


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
end



