function [timescell AllMice]=getevents1;

% this file goes through all the chasing files and generates a collective
% chasing list for an experiment

% IMPORTANT - HOW TO READ THE FILES:
% THE COLUMNS ARE 'FILE NAME','TIME IN FILE','MOUSE CHASING', 'MOUSE CHASED'

% IMPORTANT - HOW TO ANNOTATE THE LIST TO BE READ:
% PLACE AN 'N' ONE SPACE TO THE RIGHT OF EACH EVENT TO BE REMOVED, AND AN
% 'R' ONE SPACE TO THE RIGHT OF EACH EVENT TO REVERSE THE MICE

% global datadirec
% global exper
global h
NumberDays=1; %the number of days in the experiment
%% 

exper=get(h.editAllRFID2,'string');
datadirec=get(h.edit3x,'string');

% global modify_mode  % [0]/1  [0]-old mode (from Michael)
% modify_mode=0;
% optional building of additionalCell array
% if(isempty(modify_mode))
    % modify_mode=0; % additionalCell{n,:}=>{ 'Y', chasedMouseN, chasingMouseN, bgnngFrameN, endngFrameN }
% end

total=cell(1,1);
named=cell(1,1);
timescell=cell(50,4);  % this size doesn't fit... - myAddition
% % timescell{n,:}=>example: {'02_12_2015_16_22_00.117-16...' '00:01:13.333' '00:01:19.900' '0007948811'    '0007949e11'}
% %         i.e.: {timing-name of corresponding mat.file, event-beginning, event-end, chasedMouseCode, chasingMouseCode}
%     
% 
% experi=sprintf('Exp%s',exper);
experi=exper;
dayhours=cell(1,1);
% 

% 
% allcontents=dir([sprintf('%s\\',datadirec) sprintf('%s\\Results\\chasing',experi)]);
  allcontents=dir([datadirec,'\','Results\',experi,'\','chasing\']);
% 
number=length(cellfun('isempty',{allcontents.name})); %Remove the 2 first points
firstdaydate=allcontents(3).name(1:10);
dates=str2num(firstdaydate(1:2)):(str2num(firstdaydate(1:2))+NumberDays); % problem with some dates as: 28.05.16... myAddition-02.06.16%NOTE!!!THIS ADDITION IS VALID IF THERE ARE 6 DAYS
times=cell(1,number);
alltime=cell(1,1);
% 
% % if(modify_mode==1) % myAddition - 07.06.16
% %     tnumber=50;
% %     timescell=cell(tnumber,5);
% %     additionalCell=cell(tnumber,2); % cell(number,5);
% % end
% 
% 
totalevents=0;
% 
 for i=3:number %GO THROUGH ALL THE MAT FILES

date=allcontents(i).name(1:10);
day=find(dates==str2num(date(1:2)));

% uncomment the below line to only go through days 1 through 6
% if day==7, continue;  end


% load([sprintf('%s\\',datadirec) sprintf('%s\\Results\\chasing\\',experi) allcontents(i).name])
load([datadirec,'\','Results\',experi,'\','chasing\' allcontents(i).name])

names=miceIDs;


for doing=1:5
    if ~isempty(chasing_all{1,doing})
    for being=1:5    

        for j=find(chasing_all{1,doing}(:,3)==being)'
 
 times{1,i}=vertcat(times{1,i},[chasing_all{1,doing}(j,:) doing]); %consider all the data
 
        end

    end
    end
end


if ~isempty(times{1,i})

times{1,i}=sortrows(times{1,i},2);


for q=(1+totalevents):(totalevents+size(times{1,i},1))
doing=times{1,i}(q-totalevents,4);
being=times{1,i}(q-totalevents,3);
subcell1=names{being};% names of mice
subcell2=names{doing};%names of mice
timescell{q,2}=datestr(times{1,i}(q-totalevents,1)/30/(3600*24), 'HH:MM:SS.FFF'); %convert number of frame into time
timescell{q,3}=datestr(times{1,i}(q-totalevents,2)/30/(3600*24), 'HH:MM:SS.FFF');
timescell{q,5}= strcat('''',num2str(subcell1,''''));%being chasing
timescell{q,4}=strcat('''',num2str(subcell2,'''')); %do chasing
timescell{q,1}=allcontents(i).name;
timescell{q,6}='Y';   % myAddition - 13.06.2016
timescell{q,7}=times{1,i}(q-totalevents,1); %frame from where begin
timescell{q,8}=times{1,i}(q-totalevents,2); %until which frame to arrive
timescell{q,9}=num2str(q); %to count the number of events

% if(modify_mode==1)   % additionalCell{q,:}=>{ 'Y', chasedMouseN, chasingMouseN, bgnngFrameN, endngFrameN }
%     additionalCell{q,1}='Y';  % by default - event isn't rejected ('0' - implies rejection)
%     additionalCell{q,2}=num2str(being);
%     additionalCell{q,3}=num2str(doing);
%     additionalCell{q,4}=num2str(times{1,i}(q-totalevents,1));
%     additionalCell{q,5}=num2str(times{1,i}(q-totalevents,2));
% end
end

totalevents=totalevents+size(times{1,i},1);


alltime{1,1}=vertcat(alltime{1,1},times{1,i});

% if(modify_mode==1)
%     timescell=cat(2,timescell,additionalCell);
% end


end


 end

 
% 
% if(modify_mode==1)
%     timescell=cat(2,timescell,additionalCell);
% end
end
%% Auxiliary functions



