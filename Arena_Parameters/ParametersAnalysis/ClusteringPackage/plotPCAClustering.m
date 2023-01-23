function PCAsheet=plotPCAClustering(score,MiceList,ExpRank,Cdominant,Csubmisse)

%% Variables
global h
NumberMouse=str2num(get(h.editMousePCA,'String'));
Filename=get(h.editRunParamsPCA,'string');
cc=jet(NumberMouse);%for getting colors
%Plot PCA into excel file
%% ---Create the temporal figures---------
tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,1,1]);




%% Plot pca by 
 set(0,'CurrentFigure',temp)
 subplot(2,1,1)
plot(score(ExpRank==1,1),score(ExpRank==1,2),'d','MarkerSize',12,'color','r','Display','Alpha');
 legend('-DynamicLegend','Location','northeastoutside');
hold on;
plot(score(ExpRank~=1,1),score(ExpRank~=1,2),'s','MarkerSize',12,'color','k','MarkerFaceColor','k','Display','Rest Mice');
 legend('-DynamicLegend','Location','northeastoutside');
xlabel('Principal component 1')
ylabel('Principal component 2')

hold on;
plot(Cdominant(1),Cdominant(2),'x','MarkerSize',13,'color','g','LineWidth',2)
hold on;
plot(Csubmisse(1),Csubmisse(2),'x','MarkerSize',13,'color','g','LineWidth',2)

subplot(2,1,2)
for s=1:NumberMouse
    %%---Determine the legend
    if s==1
        T='alpha';
    elseif s==2
        T='beta';
    elseif s==3
        T='gamma';
        
    elseif s==4
        T='delta';
    elseif s==5
        T='lambda';
    end
    
    
    %% 
    
plot(score(ExpRank==s,1),score(ExpRank==s,2),'s','MarkerSize',12,'Color',cc(s,:),'MarkerFaceColor',cc(s,:),'DisplayName',T);
 legend('-DynamicLegend','Location','northeastoutside');
hold on;
end

xlabel('Principal component 1')
ylabel('Principal component 2')

%% %% To save into the excel files


print(temp,'-djpeg',tempfigfile);

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;

[status,sheets] = xlsfinfo(Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;


Shapes.AddPicture(tempfigfile,0,1,50,18,1000,500);
graphSheet.Name=strcat('PCA analysis',num2str(length(sheets)));
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

PCAsheet=strcat('PCA analysis',num2str(length(sheets)));
end

