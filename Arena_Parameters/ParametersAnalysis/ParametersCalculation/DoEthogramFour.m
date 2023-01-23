function  DoEthogramFour(param3,param4,param5,param6,param7,param8,colors,SaveFolder,MiceListOrder,Experiment)
p1=[];
p2=[];
p3=[];
p4=[];
p5=[];
p6=[];
p7=[];
p8=[];
colors=[];
%% For etogram position
% colors3=cbrewer('seq','PuRd',4);% chasing -being chased
% colors2=cbrewer('seq','Greys',4);% avoided -being avoiding
% colors1=cbrewer('seq','BuGn',4);% approaching -be approaching

colors=cbrewer('div','RdYlBu',6);

%% 

figLoc4=figure('position',[300 300 1000 150])
 count=0;
for day=1:size(param3,2)%loop over day
 % for day=1%lo
%    p1=param1{1,day};
%    p2=param2{1,day};

   p3=[];
   p4=[];
   p5=[];
   p6=[];
   p7=[];
   p8=[];

   p3=param3{1,day}; %Is approaching
   p4=param4{1,day}; %Is be avoiding
   p5=param5{1,day}; % Chasing -red
   p6=param6{1,day};  %Chased-rose
   p7=param7{1,day}; %Is be approaching
   p8=param8{1,day}; % Is escape or avoided
   
  
        im=1;
        for mouse=size(p3,2):-1:1 %loop over mice
            IndexAp=[];
            IndexBeAp=[];
            IndexAv=[];
            IndexEscAv=[];
            IndexChasing=[];
            IndexChased=[];
            
            IndexAp=find(p3(:,mouse)==1);
            IndexBeAp=find(p7(:,mouse)==1);
            IndexAv=find(p4(:,mouse)==1);
            IndexChasing=find(p5(:,mouse)==1);
            IndexChased=find(p6(:,mouse)==1);
            IndexEscAv=find(p8(:,mouse)==1);
            
        if ~isempty(IndexAp)   %approaching 
            for i=1:size(IndexAp)
                if isempty(find(IndexAp(i)==IndexChasing)) & isempty(find(IndexAp(i)==IndexChased)) %avoid approaching to be chasing/chasing
                  pl1=line([IndexAp(i)+count IndexAp(i)+count],[(im*1) (im*1+1)],'Color', colors(2,:),'LineWidth',2);
                  hold all;
                end  
            end     
        end
        
          if ~isempty(IndexBeAp)   % beapproaching 
            for i=1:size(IndexBeAp)
                if isempty(find(IndexBeAp(i)==IndexChasing)) & isempty(find(IndexBeAp(i)==IndexChased)) %avoid approaching to be chasing
                  pl2=line([IndexBeAp(i)+count IndexBeAp(i)+count],[(im*1) (im*1+1)],'Color', colors(5,:),'LineWidth',2);
                  hold all;
                end  
            end     
        end
        
        
        
        
               if ~isempty(IndexAv) %being avoidance
                   for i=1:size(IndexAv)
                     if isempty(find(IndexAv(i)==IndexChasing)) & isempty(find(IndexAv(i)==IndexChased))  %avoid approaching to be chasing
                         
                         pl3=line([IndexAv(i)+count IndexAv(i)+count],[(im*1) (im*1+1)],'Color',colors(3,:),'LineWidth',2);%blue
                          hold all;
                     end
                   end
               end
               
               if ~isempty(IndexEscAv) %being avoidance
                   for i=1:size(IndexEscAv)
                      if isempty(find(IndexEscAv(i)==IndexChasing)) & isempty(find(IndexEscAv(i)==IndexChased))  %avoid approaching to be chasing
                         
                         pl4=line([IndexEscAv(i)+count IndexEscAv(i)+count],[(im*1) (im*1+1)],'Color',colors(4,:),'LineWidth',2);%blue
                          hold all;
                     end
                   end
               end  %escape avoidance
               
               
               
               
                 if ~isempty(IndexChased)  %being chasing
                     for i=1:size(IndexChased)
                        if isempty(find(IndexChased(i)==IndexChasing))% in the case of redundant
                                  pl5=line([IndexChased(i)+count IndexChased(i)+count],[(im*1) (im*1+1)],'Color',colors(6,:),'LineWidth',2); %rose
                                  hold all; 
                        end        
                     end  
                 end
                if ~isempty(IndexChasing) %chasing
                    for i=1:size(IndexChasing)
                        if isempty(find(IndexChasing(i)==IndexChased))% in the case of redundant
                             pl6=line([IndexChasing(i)+count IndexChasing(i)+count],[(im*1) (im*1+1)],'Color',colors(1,:),'LineWidth',2);
                               hold all;
                        end       
                    end
                end
            axis off
            im=im+1; 
             text(-100000,im*1-0.5,MiceListOrder{mouse},'FontSize',9)
        end 
           
          
           count=count+size(p3,1);
            ref(day)=count;
        end


for i=1:length(ref)
  line([ref(i) ref(i)],[1 6],'Color','blue','LineStyle','--','LineWidth',2)
    hold on;
end

xlim([0 ref(length(ref))])

   set(gca,'XTick',[],...                         %# Change the axes tick marks
        'YTick',[], 'YTickLabel',{''},...
        'TickLength',[0 0],'YTickLabel',{''},'FontSize',8);
legend([pl1 pl2 pl3 pl4 pl5 pl6],{'approaching','approached','avoiding','avoided','chased','chasing'},'Location','bestoutside','Orientation','horizontal');
 %legend('boxoff');
    saveas(figLoc4,fullfile(SaveFolder,strcat(Experiment,'Behaviourl.tiff')))  
    saveas(figLoc4,fullfile(SaveFolder,strcat(Experiment,'Behaviourl.fig')))
    close(figLoc4)
end