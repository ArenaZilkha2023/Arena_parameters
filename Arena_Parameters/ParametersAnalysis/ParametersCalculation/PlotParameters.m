function [ output_args ] =PlotParameters(Filename,SelectedExperiments,FilenameChasingData1)
global h

%% --Variables--
NumberMice=str2num(get(h.editMouse,'string'));%number of mice to plot
Days=str2num(get(h.editDays,'string'))%number of days to plot



cc=jet(NumberMice);%for getting colors


%% 

%Plot parameters-Add to excel file
%--for saving into excel file create temp file for each exp---------------
tempfigfile=[tempname '.png'];
temp=figure;
set (temp, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile1=[tempname '.png'];
temp1=figure;
set (temp1, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile2=[tempname '.png'];
temp2=figure;
set (temp2, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile3=[tempname '.png'];
temp3=figure;
set (temp3, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile4=[tempname '.png'];
temp4=figure;
set (temp4, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile5=[tempname '.png'];
temp5=figure;
set (temp5, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile6=[tempname '.png'];
temp6=figure;
set (temp6, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile7=[tempname '.png'];
temp7=figure;
set (temp7, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile8=[tempname '.png'];
temp8=figure;
set (temp8, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile9=[tempname '.png'];
temp9=figure;
set (temp9, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile10=[tempname '.png'];
temp10=figure;
set (temp10, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile11=[tempname '.png'];
temp11=figure;
set (temp11, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile12=[tempname '.png'];
temp12=figure;
set (temp12, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile13=[tempname '.png'];
temp13=figure;
set (temp13, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile14=[tempname '.png'];
temp14=figure;
set (temp14, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile15=[tempname '.png'];
temp15=figure;
set (temp15, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile27=[tempname '.png'];
temp27=figure;
set (temp27, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile28=[tempname '.png'];
temp28=figure;
set (temp28, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile16=[tempname '.png'];
temp16=figure;
set (temp16, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile17=[tempname '.png'];
temp17=figure;
set (temp17, 'Units', 'normalized', 'Position', [0,0,1,1]);
% 
tempfigfile18=[tempname '.png'];
temp18=figure;
set (temp18, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile19=[tempname '.png'];
temp19=figure;
set (temp19, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile20=[tempname '.png'];
temp20=figure;
set (temp20, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile21=[tempname '.png'];
temp21=figure;
set (temp21, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile22=[tempname '.png'];
temp22=figure;
set (temp22, 'Units', 'normalized', 'Position', [0,0,1,1]);

tempfigfile23=[tempname '.png'];
temp23=figure;
set (temp23, 'Units', 'normalized', 'Position', [0,0,1,1]);


tempfigfile24=[tempname '.png'];
temp24=figure;
set (temp24, 'Units', 'normalized', 'Position', [0,0,1,1]);



tempfigfile25=[tempname '.png'];
temp25=figure;
set (temp25, 'Units', 'normalized', 'Position', [0,0,1,1]);



tempfigfile26=[tempname '.png'];
temp26=figure;
set (temp26, 'Units', 'normalized', 'Position', [0,0,1,1]);

%% -------------Read each sheet and create a figure for each parameter--------------
clear raw;

hbar = waitbar(0,'Please wait...');
for i=1:length(SelectedExperiments)
    sheet=char(SelectedExperiments(i))
 [num,txt,raw]=xlsread(Filename,sheet);   
 %% Find limits of each parameter
 %% ----Running parameter
 
 IndexRunning=find(strcmp('RunningTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp)
 if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
 end
hfig=bar(cell2mat(raw(IndexRunning:IndexRunning+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;

xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexRunning:IndexRunning+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('RunningTime(% of time)')
 
 %% ----Running parameter Active------------------------
 
 IndexRunningA=find(strcmp('RunningTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp18)
 if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
 end
hfig=bar(cell2mat(raw(IndexRunningA:IndexRunningA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;

xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexRunningA:IndexRunningA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('RunningTime(% of Active time)')

   %% ----Walking parameter
 
 IndexWalking=find(strcmp('WalkingTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp1)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end


hfig=bar(cell2mat(raw(IndexWalking:IndexWalking+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)));
l=strcat('''',raw(IndexWalking:IndexWalking+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('WalkingTime(% of time)')

%%    %% ----Walking parameter of active time
 
 IndexWalkingA=find(strcmp('WalkingTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp19)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end


hfig=bar(cell2mat(raw(IndexWalkingA:IndexWalkingA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)));
l=strcat('''',raw(IndexWalkingA:IndexWalkingA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('WalkingTime(% of active time)')

   %% ----Static parameter of exp time-------------
 
 IndexStatic=find(strcmp('StaticTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp2)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexStatic:IndexStatic+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexStatic:IndexStatic+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('StaticTime(% of time))')

   %% ----Static parameter of active time-------------
 
 IndexStaticA=find(strcmp('StaticTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp20)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexStaticA:IndexStaticA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexStaticA:IndexStaticA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('StaticTime(% of active time)')

%%  %% ----movement parameter of active time---------
 
 IndexMovementA=find(strcmp('movementTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp21)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexMovementA:IndexMovementA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexMovementA:IndexMovementA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('movementTime(% of active time)')
    
%%  %% ----movement parameter of active time---------
 
 IndexMovement=find(strcmp('movementTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp3)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexMovement:IndexMovement+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexMovement:IndexMovement+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('movementTime(% of time)')
    

%% %%  %% ----Sleeping parameter
 
 IndexSleeping=find(strcmp('sleepingSumTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp4)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end


hfig=bar(cell2mat(raw(IndexSleeping:IndexSleeping+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexSleeping:IndexSleeping+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('sleepingSumTime(% of time)')



%% %%  %% ----Eating parameter
 
 IndexEating=find(strcmp('eatingSumTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp5)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexEating:IndexEating+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexEating:IndexEating+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('eatingSumTime(% of time)')

%% %%  %% ----Eating parameter in Active Time
 
 IndexEatingA=find(strcmp('eatingSumTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp22)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexEatingA:IndexEatingA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexEatingA:IndexEatingA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('eatingSumTime(% of time)')

%% %%  %% ----Drinking parameter
 
 IndexDrinking=find(strcmp('drinkingSumTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp6)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexDrinking:IndexDrinking+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexDrinking:IndexDrinking+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('drinkingSumTime(% of time)')

%% %%  %% ----Drinking parameter ACTIVE TIME
 
 IndexDrinkingA=find(strcmp('drinkingSumTimeActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp23)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexDrinkingA:IndexDrinkingA+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexDrinkingA:IndexDrinkingA+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('drinkingSumTime(% of Active time)')
%% %%  %% ----Hiding parameter -------------------------
 
 IndexHiding=find(strcmp('hidingSumTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp7)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end


hfig=bar(cell2mat(raw(IndexHiding:IndexHiding+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexHiding:IndexHiding+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('hidingSumTime(% of time)')

%% %%  %% ----Arena parameter
 
 IndexArena=find(strcmp('ArenaSumTime(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp8)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexArena:IndexArena+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexArena:IndexArena+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('ArenaSumTime(% of time)')


%% %%  %% ----alone parameter
 
 IndexAlone=find(strcmp('CenterTimeAlone(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp9)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexAlone:IndexAlone+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexAlone:IndexAlone+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('CenterTimeAlone(% of time)')

%% %%  %% ----alone parameter in active time
 
 IndexAlone=find(strcmp('CenterTimeAloneActive(% of Active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp24)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexAlone:IndexAlone+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexAlone:IndexAlone+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('CenterTimeAloneActive(% of Active time)')

%% %%  %% ----chasing parameter
 
 IndexChasing=find(strcmp('chasing all (N events)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp10)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexChasing:IndexChasing+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexChasing:IndexChasing+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('chasing all (N events)')

   %% %%  %% ---- being chasing parameter
 
 IndexBeingChasing=find(strcmp('being chased all(N events)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp11)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw(IndexBeingChasing:IndexBeingChasing+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw(IndexBeingChasing:IndexBeingChasing+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('being chased all(N events)')

%% ----------------Chasing + being chasing

 
 IndexBeingPlusChasing=find(strcmp('Chasing plus being chasing all(N events)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp12)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw( IndexBeingPlusChasing: IndexBeingPlusChasing+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexBeingPlusChasing: IndexBeingPlusChasing+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('Chasing plus being chasing all(N events)')


%% %% ----------------Dist pairs

 
 IndexDistance=find(strcmp('DistPairs all(average (cm))',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp13)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end
  
hfig=bar(cell2mat(raw( IndexDistance: IndexDistance+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexDistance: IndexDistance+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('DistPairs all(average (cm))')

%% %% %% ----------------Velocity

 
 IndexVelocity=find(strcmp('Average velocity (average (cm/sec))',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp14)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw( IndexVelocity: IndexVelocity+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexVelocity: IndexVelocity+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('Average velocity (average (cm/sec))')


%% %% %% ----------------together all----

 
 IndexTogether=find(strcmp('togetherAll(% of time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp15)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw( IndexTogether: IndexTogether+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexTogether: IndexTogether+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('togetherAll(% of time)')

%% -----------------Inside active zone----------------

 IndexTogether=find(strcmp('InsideZoneTime(% of active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp25)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw( IndexTogether: IndexTogether+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexTogether: IndexTogether+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('InsideZoneTime(% of active time)')


%% -----------------Outside active zone----------------

 IndexTogether=find(strcmp('OutsideZoneTime(% of active time)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp26)
 
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

hfig=bar(cell2mat(raw( IndexTogether: IndexTogether+NumberMice-1,3:3+Days-1))');
hfig(1).Parent.Parent.Colormap=cc;
xlabel(char(SelectedExperiments(i)))
l=strcat('''',raw( IndexTogether: IndexTogether+NumberMice-1,2),'''');
legend(hfig,l,'Location','northwestoutside')

title('OutsideZoneTime(% of active time)')



%% ------------Insert Elo rating graphs per each experiment------------------
%% ----------------Load the data-----------------------

FilenameChasingData=strcat(FilenameChasingData1,SelectedExperiments(i),'\','Data','\','Results','\',strcat(SelectedExperiments(i),'_ChasingResults.xlsx'));

sheet='Elo-rating All Events';
[num txt EloMatrixOrder]=xlsread(char(FilenameChasingData),sheet);

sheet1='Elo-rating per day order';
[num txt EloeDayTotalOrder]=xlsread(char(FilenameChasingData),sheet1);

sheet2='Ranking';
[num txt Ranking]=xlsread(char(FilenameChasingData),sheet2);

 IndEAD=find(strcmp('Mean Elorating per day',raw(:,1))==1);
set(0,'CurrentFigure',temp16)

  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end %plot Elo per day
  
for j=2:length(Ranking(:,1))+1
    T=char(EloeDayTotalOrder(1,j));
plot(cell2mat(EloeDayTotalOrder(2:end,1)),cell2mat(EloeDayTotalOrder(2:end,j)),'-*','MarkerSize',12,'DisplayName',T,'Color',cc(j-1,:));
 legend('-DynamicLegend','Location','northeastoutside');
hold all;
title(strcat(char(SelectedExperiments(i)),'Last Event of Elo-rating per  day'),'FontSize',12)
xlabel('Days','FontSize',12)
ylabel('Elo-rating','FontSize',12)

end  


% hold on;
set(0,'CurrentFigure',temp27)
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

raw1=[];
%add initial point 0 is 1000
raw1(1:length(Ranking(:,1)),1)=1000;
raw1(:,2:2+Days-1)=cell2mat(raw(IndEAD:IndEAD+length(Ranking(:,1))-1,3:3+Days-1));

% subplot(length(SelectedExperiments),3,i+2) %plot Elo per day by assuming the average
for j=2:length(Ranking(:,1))+1
    T=char(EloeDayTotalOrder(1,j));



plot(cell2mat(EloeDayTotalOrder(2:end,1)),raw1(j-1,1:Days+1),'-*','MarkerSize',12,'DisplayName',T,'Color',cc(j-1,:));
legend('-DynamicLegend','Location','northeastoutside');
hold all;
title(strcat(char(SelectedExperiments(i)),'Average Elo-rating per day'),'FontSize',12)
xlabel('Days','FontSize',12)
ylabel('Elo-rating','FontSize',12)

end  

set(0,'CurrentFigure',temp28)
  if length(SelectedExperiments)==1
     subplot(1,1,1)
 else
subplot(ceil(length(SelectedExperiments)/3),3,i)
  end

% hold on;



% subplot(length(SelectedExperiments),3,i)%plot per event
%find Events column
IndexEvents=find(strcmp(EloMatrixOrder(1,:),'Events')==1);
IndexDay=find(strcmp(EloMatrixOrder(1,:),'Day')==1);
IndexFirstDay=find(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexDay))==1);
%find where the first day finished

for j=4:length(Ranking(:,1))+3
    
    T=char(EloMatrixOrder(1,j));
plot(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexEvents)),cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,j)),'DisplayName',T,'Color',cc(j-3,:));
legend('-DynamicLegend','Location','northeastoutside');
hold all;
title(strcat(char(SelectedExperiments(i)),'Elo-rating per event'),'FontSize',12)
xlabel('Events','FontSize',12)
ylabel('Elo-rating','FontSize',12)
% l=size(EloMatrixOrder,1);
% x=cell2mat(EloMatrixOrder(l-2,IndexEvents));
% y=cell2mat(EloMatrixOrder(l-2,i));
% text(x,y,EloMatrixOrder(1,i),'FontSize',12)
end 

plot(cell2mat(EloMatrixOrder(length(IndexFirstDay),IndexEvents))*ones(1,length([600 1400])),[600 1400],'--','LineWidth',2);
% 
%  else
%   IndexEvents=find(strcmp(EloMatrixOrder(1,:),'Events')==1);

% 
% for i=4:length(Ranking(:,1))+3
% p=plot(cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,IndexEvents)),cell2mat(EloMatrixOrder(2:size(EloMatrixOrder,1)-1,i)));
% hold all;
% title('Elo-rating per event','FontSize',12)
% xlabel('Events','FontSize',12)
% ylabel('Elo-rating','FontSize',12)
% l=size(EloMatrixOrder,1);
% x=cell2mat(EloMatrixOrder(l-2,IndexEvents));
% y=cell2mat(EloMatrixOrder(l-2,i));
% text(x,y,EloMatrixOrder(1,i),'FontSize',12)
% end 
%   
%% -----------------Plot interaction matrix-first mouse dominant------------
 
 IndexMatrix=find(strcmp('Interaction Matrix for each day (Chasing/being Chasing)',raw(:,1))==1);
 

 set(0,'CurrentFigure',temp17)
for t=1:Days  %Loop on the days
   
  
 subplot(length(SelectedExperiments),Days,t+(i-1)*Days)
mat=raw(IndexMatrix:NumberMice+IndexMatrix-1,3+(t-1)*(NumberMice+1):NumberMice+2+(t-1)*(NumberMice+1));
imagesc(cell2mat(mat));            %# Create a colored plot of the matrix values
colormap(flipud(gray));
headers=(raw(IndexMatrix:NumberMice+IndexMatrix-1,2))';
headers=char(headers);
% textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
% textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:NumberMice);   %# Create x and y coordinates for the stringsi
% hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
%                 'HorizontalAlignment','center');

hStrings = text(x(:),y(:),mat(:),...      %# Plot the strings
                'HorizontalAlignment','center');

% midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
%                                              %#   text color of the strings so
%                                              %#   they can be easily seen over
%                                              %#   the background color
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% 
set(gca,'XTick',1:NumberMice,...                         %# Change the axes tick marks
        'XTickLabel',headers(:,7:end),...  %#   and tick labels
        'YTick',1:NumberMice,...
        'YTickLabel',headers(:,7:end),...
        'TickLength',[0 0],'FontSize',8);
title(strcat(char(SelectedExperiments(i)),'Day ',num2str(t)))
xlabel('Being chasing');
ylabel('Chasing');
end

%% 
waitbar(i/length(SelectedExperiments))
end
close(hbar)

%% 




%% To save into the excel files

% print(temp,'-dpng',tempfigfile);
print(temp,'-dpng',tempfigfile);
print(temp1,'-dpng',tempfigfile1);
print(temp2,'-dpng',tempfigfile2);
print(temp3,'-dpng',tempfigfile3);
print(temp4,'-dpng',tempfigfile4);
print(temp5,'-dpng',tempfigfile5);
print(temp6,'-dpng',tempfigfile6);
print(temp7,'-dpng',tempfigfile7);
print(temp8,'-dpng',tempfigfile8);
print(temp9,'-dpng',tempfigfile9);
print(temp10,'-dpng',tempfigfile10);
print(temp11,'-dpng',tempfigfile11);
print(temp12,'-dpng',tempfigfile12);
print(temp13,'-dpng',tempfigfile13);
print(temp14,'-dpng',tempfigfile14);
print(temp15,'-dpng',tempfigfile15);
print(temp16,'-dpng',tempfigfile16);
print(temp17,'-dpng',tempfigfile17);
print(temp18,'-dpng',tempfigfile18);
print(temp19,'-dpng',tempfigfile19);
print(temp20,'-dpng',tempfigfile20);
print(temp21,'-dpng',tempfigfile21);
print(temp22,'-dpng',tempfigfile22);
print(temp23,'-dpng',tempfigfile23);
print(temp24,'-dpng',tempfigfile24);
print(temp25,'-dpng',tempfigfile25);
print(temp26,'-dpng',tempfigfile26);
print(temp27,'-dpng',tempfigfile27);
print(temp28,'-dpng',tempfigfile28);
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

% Shapes.AddPicture(tempfigfile,0,1,50,18,300,235);
Shapes.AddPicture(tempfigfile,0,1,50,18,1000,500);

graphSheet.Name='RunningTime(% of time)';
exl2.visible=1;


invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile1,0,1,50,18,1000,500);
graphSheet.Name='WalkingTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile2,0,1,50,18,1000,500);
graphSheet.Name='StaticTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile3,0,1,50,18,1000,500);
graphSheet.Name='movementTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile4,0,1,50,18,1000,500);
graphSheet.Name='sleepingSumTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile5,0,1,50,18,1000,500);
graphSheet.Name='eatingSumTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile6,0,1,50,18,1000,500);
graphSheet.Name='drinkingSumTime(% of time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile7,0,1,50,18,1000,500);
graphSheet.Name='hidingSumTime';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');

Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile8,0,1,50,18,1000,500);
graphSheet.Name='ArenaSumTime';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile9,0,1,50,18,1000,500);
graphSheet.Name='CenterTimeAlone';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile10,0,1,50,18,1000,500);
graphSheet.Name='chasing all';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile11,0,1,50,18,1000,500);
graphSheet.Name='being chased all';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile12,0,1,50,18,1000,500);
graphSheet.Name='Chasing-beingChasing';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile13,0,1,50,18,1000,500);
graphSheet.Name='DistPairs all(average (cm))';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile14,0,1,50,18,1000,500);
graphSheet.Name='Average velocity';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile15,0,1,50,18,1000,500);
graphSheet.Name='togetherAll';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile16,0,1,50,18,1000,500);
graphSheet.Name='EloratingPerDayLast';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')


%% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile27,0,1,50,18,1000,500);
graphSheet.Name='EloratingPerDay';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')




%% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile28,0,1,50,18,1000,500);
graphSheet.Name='EloratingAllEvent';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')


%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile17,0,1,50,18,1000,500);
graphSheet.Name='Interaction Matrix';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% 
%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile18,0,1,50,18,1000,500);
graphSheet.Name='Running(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile19,0,1,50,18,1000,500);
graphSheet.Name='Walking(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
%% %% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile20,0,1,50,18,1000,500);
graphSheet.Name='Static(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile21,0,1,50,18,1000,500);
graphSheet.Name='Movement(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile22,0,1,50,18,1000,500);
graphSheet.Name='Eating(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile23,0,1,50,18,1000,500);
graphSheet.Name='Drinking(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile24,0,1,50,18,1000,500);
graphSheet.Name='Alone(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile25,0,1,50,18,1000,500);
graphSheet.Name='InZone(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')

%% %% %% Activate excel file
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
ResultFile=Filename;
ResultFile1=strcat('AddGraphs',Filename);

Workbook=invoke(Excel.Workbooks,'Open',ResultFile);
set(Excel,'Visible',1);
graphSheet=invoke(Workbook.Sheets,'Add');
Shapes=graphSheet.Shapes;

Shapes.AddPicture(tempfigfile26,0,1,50,18,1000,500);
graphSheet.Name='OutZone(% active time)';
exl2.visible=1;

invoke(Workbook,'SaveAs',ResultFile);
invoke(Excel,'Quit');
close('gcf')
end

