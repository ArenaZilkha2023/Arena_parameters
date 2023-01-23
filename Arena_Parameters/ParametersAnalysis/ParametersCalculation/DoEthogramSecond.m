function  DoEthogramSecond(param1,param2,param3,param4,param5,colors,SaveFolder,MiceListOrder,Experiment)
p1=[];
p2=[];
p3=[];
p4=[];
p5=[];
colors=[];
%% For etogram position
colors1=cbrewer('div','RdBu',5);
colors2=cbrewer('div','Spectral',5);
colors3=cbrewer('div','PuOr',5);
colors4=cbrewer('div','RdGy',5);

colors(5,:)=colors3(1,:);%walking orange
colors(1,:)=colors1(3,:);%Sleeping
% colors(2,:)=colors2(3,:);%Hiding
colors(2,:)=colors1(3,:);%Hiding
colors(4,:)=colors3(5,:);%running violet
colors(3,:)=colors4(5,:);%static gray

%% 

figLoc=figure('position',[300 300 1000 150])
 count=0;
for day=1:size(param1,2)%loop over day
   p1=param1{1,day};
   p2=param2{1,day};
   p3=param3{1,day};
   p4=param4{1,day};
   p5=param5{1,day};
  
    for rows=1:size(p1,1)% over raw
        % choose the respective row for each parameter
        Allp=[p1(rows,:);p2(rows,:);p3(rows,:);p4(rows,:);p5(rows,:)];
        rows
        im=1;
        for mouse=size(p1,2):-1:1 %loop over mice
            Index=find(Allp(:,mouse)==1);
        if ~isempty(Index)   %sometimes at the begginign the mouse position is unknown 
            switch(Index)
                case 1
                   
                 hh=line([count count],[(im*1) (im*1+1)],'Color',colors(1,:)) 
                 %legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
                case 2
                     
                   line([count count],[(im*1) (im*1+1)],'Color',colors(2,:)) 
                  % legend('-DynamicLegend','Location','northeastoutside');
                    hold all;
                case 3
                    
                   line([count count],[(im*1) (im*1+1)],'Color',colors(3,:)) 
                   %  legend('-DynamicLegend','Location','northeastoutside');
                    hold all;
                case 4
                     
                    line([count count],[(im*1) (im*1+1)],'Color',colors(4,:)) 
                    %legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
                case 5
                    
                    line([count count],[(im*1) (im*1+1)],'Color',colors(5,:)) 
                   % legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
            end
        end 
           im=im+1; 
           text(-2000,im*1-0.5,MiceListOrder{mouse})
        end
           count=count+1; 
    end
          % draw line to separate the days
         % hax=axes;
         ref(day)=count;
         
end
%legend('sleeping','hiding','food','water','arena')
for i=1:length(ref)
  line([ref(i) ref(i)],[1 6],'Color','blue','LineStyle','--','LineWidth',2)
                   hold on
end

xlim([0 ref(length(ref))])

   set(gca,'XTick',[],...                         %# Change the axes tick marks
        'YTick',[], 'YTickLabel',{''},...
        'TickLength',[0 0],'YTickLabel',{''},'FontSize',8);
    %box(hh,'on');
    saveas(figLoc,fullfile(SaveFolder,strcat(Experiment,'Motion.tiff')))  
    close(figLoc)
end