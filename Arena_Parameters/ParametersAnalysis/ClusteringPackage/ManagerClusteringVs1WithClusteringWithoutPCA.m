function  ManagerClustering(~,~)
%Open parameters and do clustering
%% 
%%--- Variables-----------------
global h
NumberMouse=get(h.editMousePCA,'String');
NumberDays=get(h.editDaysPCA,'String');
LessDays=1; %not consider first 2 days

cc=jet(str2num(NumberMouse));%for getting colors

%-------------------Select the experiments-------------------
index_selected = get(h.listRunParamsPCA,'Value');
list = get(h.listRunParamsPCA,'String');
item_selected = list(index_selected,1); % Convert from cell array

ExpList=item_selected'; %Input Data

%% -----------Clear variables--------------
Z=[,];
Aux1=[];
Exp=[];
FinalMatrix=cell(length(item_selected)*str2num(NumberDays)*str2num(NumberMouse),5)

%% -------------Prepare auxiliary vector ------------------
%-REMBER THE FIRST MOUSE OF THE LIST IS THE DOMINANT----------------
for t=1:str2num(NumberMouse)
    if t==1
  Aux1=t*ones(1,str2num(NumberDays)-LessDays);  
    else
       Aux1=[Aux1;t*ones(1,str2num(NumberDays)-LessDays)];  
    end
end
Aux1=reshape(Aux1,[size(Aux1,1)*size(Aux1,2),1]);

%% ---------------Read variables and join variables-----------------
for i=1:length(item_selected)
    
    X=[];
    Y=[];
    V=[];
    W=[];
    %% 
    
   sheet=char(ExpList(i));
  [num,txt,raw]=xlsread(get(h.editRunParamsPCA,'string'),sheet); 
   IndexBeingChasing=find(strcmp('InsideZoneTime(% of active time)',raw(:,1))==1); %X
  IndexChasingAll=find(strcmp('OutsideZoneTime(% of active time)',raw(:,1))==1); %Y 
 
  %% ---Plot Chasing all versus being chasing---------------
  X=cell2mat(raw(IndexBeingChasing:IndexBeingChasing+str2num(NumberMouse)-1,3+LessDays:2+str2num(NumberDays)));
  Y=cell2mat(raw(IndexChasingAll:IndexChasingAll+str2num(NumberMouse)-1,3+LessDays:2+str2num(NumberDays)));
  Exp=[Exp;repmat(ExpList(i),size(Y,1)*size(Y,2),1)];
  Z=[Z;[reshape(X,[size(X,1)*size(X,2),1]),reshape(Y,[size(Y,1)*size(Y,2),1]),Aux1]];
  
  
  
   
end

%% 





%% ------Cluster the data by k means algoritm---------------------
 opts = statset('Display','final');
  [idx,C] = kmeans(Z,2,'Distance','cityblock',...
    'Replicates',5,'Options',opts,'Start','plus');

%% --------------------For Final Matrix-------------------------------
FinalMatrix(1,1)={'InZone(% active time)'};%X
FinalMatrix(1,2)={'OutZone(% active time)'};%Y
FinalMatrix(1,3)={'Number of mouse'};
FinalMatrix(1,4)={'Number of Experiment'};
FinalMatrix(1,5)={'Number of Cluster'};

FinalMatrix(2:size(Z,1)+1,1:3)=num2cell(Z);
FinalMatrix(2:size(Exp,1)+1,4)=Exp;
FinalMatrix(2:size(idx,1)+1,5)=num2cell(idx);


%% 

 figure
 
 %% -----Plot each mouse with a different color in which the first is the alpha, beta etc,,'
%  Z=Z(str2num(NumberMouse)+1:end,:);
%  idx=idx(str2num(NumberMouse)+1:end,:);

  for j=2:str2num(NumberMouse)
 %for j=1
     I=find(Z(:,3)==j);
  plot(Z(I,1),Z(I,2),'s','MarkerSize',15,'Color',cc(j,:),'LineWidth', 3);
  legend('-DynamicLegend','Location','northeastoutside');
  hold all;
 end
 ylabel('OutsideZoneTime(% of active time)');
 xlabel('InsideZoneTime(% of active time)');
  %% 

hold on
plot(Z(idx==1,1),Z(idx==1,2),'r.','MarkerSize',30)
hold on
plot(Z(idx==2,1),Z(idx==2,2),'b.','MarkerSize',30)
 hold on
%  plot(Z(idx==3,1),Z(idx==3,2),'g.','MarkerSize',30)
% plot(C(:,1),C(:,2),'x',...
%      'MarkerSize',15,'LineWidth',3)
% legend('Cluster 1','Cluster 2','Centroids',...
%        'Location','NW')
% title 'Cluster Assignments and Centroids'
% hold on;
% 
%  for j=1:str2num(NumberMouse)
%      I=find(Z(:,3)==j);
%   plot(Z(I,1),Z(I,2),'s','MarkerSize',20,'Color',cc(j,:));
%   legend('-DynamicLegend','Location','northeastoutside');
%   hold all;
%  end
%  ylabel('OutsideZoneTime(% of active time)');
%  xlabel('InsideZoneTime(% of active time)');

hold off

end


