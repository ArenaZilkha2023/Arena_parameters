function ManagerZscoring(~,~)
%% --------Read the interface- select exp and parameters-per day or average-------

%% -------------Variables-----------------------
global h
NumberMouse=str2num(get(h.editMouseZscore,'String'));

FromDay=str2num(get(h.editDaysZscoref,'String'));
ToDay=str2num(get(h.editDaysZscoret,'String'));
Filename=get(h.editRunParamsZscore,'string');
%cc=jet(20);%for getting colors
clear ZscoreMatrix;
ZscoreMatrix1={};
%% -----------------------Read variables of the gui------------------------

%-------------------Select the experiments-------------------
index_selected = get(h.listRunParamsZscore,'Value');
list = get(h.listRunParamsZscore,'String');
item_selected = list(index_selected,1); % Convert from cell array

ExpList=item_selected'; %Input Data

%-----------------------Select the locomotion/social parameters------------------

index_selectedParams = get( h.listParamsZscore,'Value');
listParams = get( h.listParamsZscore,'String');
item_selectedParams = listParams(index_selectedParams,1); % Convert from cell array

ExpListParams=item_selectedParams'; %Input Data

%% ------------------------Clear variables-----------------------------

%% ----------------------------Begin the program---------------------------------
%% ---Create the temporal figures---------
tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,1,1]);
%---------------------Begin loop into each experiment-------------------
for i=1:length(ExpList)

%% ------------Create the matrix with the variables for each exp ---
[AuxExpTable,AuxMiceList,AuxRank,DayList]=ExtractParametersZscoring(ExpList(i),NumberMouse,FromDay,ToDay,ExpListParams);

%% ---------------------Score the matrix for each variable---
%--------------------------Do zscore of each variable column---------------------------
  ExpTableStandarize=StandarizeOutputZscoring(AuxExpTable);
clmin=min(min(ExpTableStandarize));
clmax=max(max(ExpTableStandarize));

%% ----------------------Create a matrix with all the data of z score------------
ZscoreMatrix(:,:,i)=[num2cell(ExpTableStandarize),repmat(ExpList(i),[size(AuxExpTable,1),1]),AuxMiceList];



%% ----------Separate the data for each mouse and plot---
  %% ---------------Insert working mode-------------
 set(0,'CurrentFigure',temp)
  switch get(h.Popup2Zscore,'Value')
      case 2 %for averaging the selected days
      subplot(ceil(length(ExpList)/3),3,i)
       imagesc((ExpTableStandarize)',[clmin,clmax])
        colormap(jet(NumberMouse))
         colorbar
         headers=char(AuxMiceList);
                  set(gca,'XTick',1:NumberMouse,...                         %# Change the axes tick marks
        'XTickLabel',headers(:,7:end),...  %#   and tick labels
        'YTick',1:length(ExpListParams),...
        'YTickLabel',ExpListParams,...
        'TickLength',[0 0],'FontSize',8);
       title(strcat(ExpList(i),'Days:',num2str(FromDay),'to',num2str(ToDay)))
       
       
    case 3 %separate per day and plot
          tt=1;
          for j=FromDay:ToDay
              AuxG=[];
           Id=find(DayList(:,1)==j);
           AuxG=(ExpTableStandarize(Id,:))'; %in which the columns are the mouse and the variable are the rows
        
           subplot(length(ExpList),ToDay-FromDay+1,tt+(i-1)*(ToDay-FromDay+1))
           %% ------------------------create a plot with imagesc---------
%% 
         imagesc(AuxG,[clmin,clmax])
         colorbar('southoutside')
          colormap(jet(256))
       
%          set(gca,'XTick',1:NumberMice,...                         %# Change the axes tick marks
%         'XTickLabel',headers(:,7:end),...  %#   and tick labels
%         'YTick',1:NumberMice,...
%         'YTickLabel',headers(:,7:end),...
%         'TickLength',[0 0],'FontSize',8);
          tt=tt+1;
         
          end
 
   
  end


end
%% ---------Create a z score matrix--------------------
for i=1:size(ZscoreMatrix,3)% Loop on the experiments
ZscoreMatrix1=[ZscoreMatrix1;ZscoreMatrix(:,:,i)];

end

%% %% To save into the excel files


print(temp,'-dpng',tempfigfile);

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
graphSheet.Name=strcat('Z-scoring',num2str(length(sheets)));
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% Insert the numerical information into the worksheet
%% ---------Insert the  parameters used into a matrix------
rawN{1,1}='List of experiments';
rawN(2:size(ExpList',1)+1,1)=ExpList';

rawN{1,2}='Parameters selected';
rawN(2:size(ExpListParams',1)+1,2)=ExpListParams';

rawN{1,3}='Z-Score of:';
rawN(1,4:length(ExpListParams)+3)=ExpListParams;
rawN(2:size(ZscoreMatrix1,1)+1,4:size(ZscoreMatrix1,2)+3)=ZscoreMatrix1;
% 
% 
% rawN{1,size(score,2)+4}='Exp name';
% rawN(2:size( ExpName,1)+1,size(score,2)+4)= ExpName;
% 
% rawN{1,size(score,2)+5}='Mice list';
% rawN(2:size( MiceList,1)+1,size(score,2)+5)= MiceList;
% 
% rawN{1,size(score,2)+7}='Variance of autovalue-latent';
% rawN(2:size(latent,1)+1,size(score,2)+7)=num2cell(latent);
% 
% rawN{1,size(score,2)+8}='Explained';
% rawN(2:size(explained,1)+1,size(score,2)+8)=num2cell(explained);
% 
% 
% rawN{1,size(score,2)+9}='David Bouldin values for 5 clusters';
% rawN(2:size(DBvalues',1)+1,size(score,2)+9)=num2cell(DBvalues');
% 
% rawN{1,size(score,2)+10}='David Bouldin best cluster number';
% rawN(2:size(OptimalCluster',1)+1,size(score,2)+10)=num2cell(OptimalCluster');
% 
% rawN{1,size(score,2)+11}='David Bouldin for dominant and submissibe cluster';
% rawN(2:size(DB',1)+1,size(score,2)+11)=num2cell(DB);
% %% ------------)--Insert into excel file the results of the z score--------------------
% 
xlswrite(get(h.editRunParamsZscore,'string'),rawN,strcat('Z-scoring',num2str(length(sheets))))







end
