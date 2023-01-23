function  DoEthogramFour(param3,param4,param5,param6,colors,SaveFolder,MiceListOrder,Experiment)
p1=[];
p2=[];
p3=[];
p4=[];
p5=[];
p6=[];
colors=[];
%% For etogram position
colors1=cbrewer('seq','Greys',5);
colors2=cbrewer('div','Spectral',5);

colors3=cbrewer('div','RdYlGn',5);
colors4=cbrewer('div','RdYlBu',5);
colors5=cbrewer('div','BrBG',5);

colors(1,:)=colors1(2,:);%Sleeping gray
colors(2,:)=colors2(3,:);%Hiding yellow
colors(3,:)=colors5(1,:);%approaching black
colors(4,:)=colors4(5,:);%being avoiding blue
colors(5,:)=colors3(5,:);%chasing red
colors(6,:)=colors3(1,:);%being chasing green
%% 

figLoc4=figure('position',[300 300 1000 150])
 count=0;
for day=1:size(param3,2)%loop over day
 % for day=1%lo
%    p1=param1{1,day};
%    p2=param2{1,day};
   p3=param3{1,day};
   p4=param4{1,day};
   p5=param5{1,day};
   p6=param6{1,day};
   
    for rows=1:size(p3,1)% go over raw 
        % choose the respective row for each parameter
        
       % Allp=[p1(rows,:);p2(rows,:);p3(rows,:);p4(rows,:);p5(rows,:);p6(rows,:)];
%        Allp=[p1(rows,:);p2(rows,:);p3(rows,:);p4(rows,:);p5(rows,:);p6(rows,:)];
          Allp=[p3(rows,:);p4(rows,:);p5(rows,:);p6(rows,:)];
        rows
        im=1;
        for mouse=size(p3,2):-1:1 %loop over mice
            Index=find(Allp(:,mouse)==1);
            %if there are overlap between chasing and chased  consider only
            %togehter
            %--------------------------------------
%          if length(Index)>1 & (Allp(3,mouse)==Allp(4,mouse))
           if length(Index)>1 & (Allp(2,mouse)==Allp(3,mouse))
                  Index=2; % consider together
           end
              if length(Index)>1 (Allp(3,mouse)==Allp(4,mouse))
                  Index=3;
              end
           
            %-----------------------------------------
            
        if ~isempty(Index)   %sometimes at the begginign the mouse position is unknown 
            switch(Index)
                %case 1
%                    
%                  hh=line([count count],[(im*1) (im*1+1)],'Color',colors(1,:),'LineWidth',2) %sleeping
%                  %legend('-DynamicLegend','Location','northeastoutside');
%                  hold all;
                %case 2
%                      
%                    line([count count],[(im*1) (im*1+1)],'Color',colors(2,:),'LineWidth',2) %hiding
%                   % legend('-DynamicLegend','Location','northeastoutside');
%                     hold all;
                case 1
                    
                 %  line([count count],[(im*1) (im*1+1)],'Color',colors(3,:)) %approaching
                line([count count],[(im*1) (im*1+1)],'Color', 'k','LineWidth',2)
                   %  legend('-DynamicLegend','Location','northeastoutside');
                   %  
                    hold all;
                case 2
                %    line([count count],[(im*1) (im*1+1)],'Color',colors(4,:)) %being avoidance
                  line([count count],[(im*1) (im*1+1)],'Color',[0 0.5 1],'LineWidth',2)%blue
                    %legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
                case 3
                    
                %   line([count count],[(im*1) (im*1+1)],'Color',colors(5,:)) %chasing
                  line([count count],[(im*1) (im*1+1)],'Color','r','LineWidth',2)
                   % legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
                 
                   case 4
                    
                  % line([count count],[(im*1) (im*1+1)],'Color',colors(6,:)) %being chasing
                 line([count count],[(im*1) (im*1+1)],'Color',[0 0.6 0.3],'LineWidth',2) %red
                   % legend('-DynamicLegend','Location','northeastoutside');
                 hold all;
            end
            axis off
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
    hold on;
end

xlim([0 ref(length(ref))])

   set(gca,'XTick',[],...                         %# Change the axes tick marks
        'YTick',[], 'YTickLabel',{''},...
        'TickLength',[0 0],'YTickLabel',{''},'FontSize',8);
%     figure
%     x=[1 2 2 1];
%     y=[1 1 2 2];
%     fill(x,y,colors1(2,:));
%    figure 
%    fill(x,y,colors2(3,:));
%    figure 
%    fill(x,y,'k');
%     figure 
%    fill(x,y,[0 0.5 1]);
%      figure 
%    fill(x,y,'r');
%      figure 
%    fill(x,y,[0 0.6 0.3]);
%    
%    axis off
    
    %box(hh,'on');
    saveas(figLoc4,fullfile(SaveFolder,strcat(Experiment,'Behaviour.tiff')))  
    close(figLoc4)
end