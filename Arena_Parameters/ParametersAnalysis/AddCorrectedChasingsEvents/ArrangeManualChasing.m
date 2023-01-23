function  Aux = ArrangeManualChasing(Locomotion,fileName,file_chasing_manual)

%%-------This function adds the manual chasing -----------------
%% Read excel file and select data with the same fileName
[num,txt,raw] = xlsread(char(file_chasing_manual),'Chasing');
%% select specific data
index = find(strcmp(fileName, raw(:,1)) == 1);
selected_data = raw(index,:);
%% find chasing and chased columns
index_chasing = find(strcmp('Chasing mouse',raw(1,:))==1);
index_chased = find(strcmp('Chased mouse',raw(1,:))==1);
index_time_begin = find(strcmp('Time begin event',raw(1,:))==1);
index_time_end = find(strcmp('Time end event',raw(1,:))==1);

%% Reset old chasing tables
Locomotion.AssigRFID.Behaviour.Chasing.chasing = {};
Mouse_list = Locomotion.AssigRFID.miceList;
Time_list = Locomotion.ExperimentTime;  
%%
Aux = {};
Aux = cell(1,5);
count1 = 1;
count2 = 1;
count3 = 1;
count4 = 1;
count5 = 1;

for row = 1: size(selected_data,1) %go through each row
    mouse_chasing = 0;
    mouse_chased = 0;
    if (strcmp(selected_data(row,6),'Y') == 1)
     mouse_chasing = find(strcmp(erase(selected_data(row,index_chasing),"'"),Mouse_list) == 1);   % number of chasing mice
     mouse_chased = find(strcmp(erase(selected_data(row,index_chased),"'"),Mouse_list) == 1);
     frame_begin = find(strcmp(selected_data(row,index_time_begin),Time_list) == 1);
     frame_end = find(strcmp(selected_data(row,index_time_end),Time_list) == 1);
    elseif (strcmp(selected_data(row,6),'R') == 1)
      mouse_chasing = find(strcmp(erase(selected_data(row,index_chased),"'"),Mouse_list) == 1);   % number of chasing mice
      mouse_chased = find(strcmp(erase(selected_data(row,index_chasing),"'"),Mouse_list) == 1); 
      frame_begin = find(strcmp(selected_data(row,index_time_begin),Time_list) == 1);
      frame_end = find(strcmp(selected_data(row,index_time_end),Time_list) == 1);
    end
 switch mouse_chasing   
    case 1
     Aux{1,mouse_chasing}(count1,1:3) = [frame_begin,frame_end,mouse_chased];  
     count1 = count1 +1;
    case 2
     Aux{1,mouse_chasing}(count2,1:3) = [frame_begin,frame_end,mouse_chased];  
     count2 = count2 +1;   
    case 3
    Aux{1,mouse_chasing}(count3,1:3) = [frame_begin,frame_end,mouse_chased];  
     count3 = count3 +1;
     case 4
      Aux{1,mouse_chasing}(count4,1:3) = [frame_begin,frame_end,mouse_chased];  
     count4 = count4 +1;   
    case 5
      Aux{1,mouse_chasing}(count5,1:3) = [frame_begin,frame_end,mouse_chased];  
     count5 = count5 +1;   
    otherwise
    end 
    
end


  
end   

