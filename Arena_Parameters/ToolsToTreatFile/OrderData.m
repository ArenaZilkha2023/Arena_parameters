function [ output_args ] = OrderData( ~,~ )

global h

%% 
Folder_Data=get(h.editOrder,'string'); %load directory
Folder_Output=get(h.editOrder1,'string'); %load output directory with data folder
ExpName=get(h.editOrderName,'string');
ListFolders=dir([Folder_Data '\']);
ListFolders.name;
%% %% Clock for checking
hwait = waitbar(0,'Please wait...');


%% Order data
 


for i=3:length(ListFolders)
    
    
%     try
%     copyfile([Folder_Data,'\',ListFolders(i).name ,'\*.mat'],[Folder_Output, '\',ExpName,'ResultsMatlab','\']);%copy rfid files
%     catch
%          [Folder_Output, '\',ExpName,'ResultsMatlab','\']
%          msgbox(strcat('Error in file ',' ',[Folder_Data,'\',ListFolders(i).name ,'\*.mat']))
%      end
    ListAll=dir([Folder_Data,'\',ListFolders(i).name ,'\']); %subfolders of each day to get csv files
    dirFlags = [ListAll.isdir];
   
% Extract only those that are directories.
    subFolders = ListAll(dirFlags);
     subFolders.name;
   for j=3:length(subFolders )
      fff =[Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.csv'];
      fffVideo =[Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*WithRFID.avi'];
      fffMat =[Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.mat']; %mat files
      fffVideoSegmentation =[Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*WithSegmentation.avi'];
      fffVideoOnly =[Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.avi'];
     try
     movefile([Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.csv'],[Folder_Output,'\',ExpName,'Video','\'])%copy csv files  
     
     catch
         msgbox(strcat('Error in file ',' ',fff))
     end
     
     try
     
     movefile([Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*WithRFID.avi'],[Folder_Output,'\',ExpName,'VideoAvi','\'])%copy Avi films
     catch
         msgbox(strcat('Error in video ',' ',fffVideo))
     end
    
       
     try
     
     movefile([Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.mat'],[Folder_Output,'\',ExpName,'ResultsMatlab','\'])%copy mat files
     catch
         msgbox(strcat('Error in file  ',' ', fffMat))
     end
     
       try
     
     movefile([Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*WithSegmentation.avi'],[Folder_Output,'\',ExpName,'VideoAviSegmentation','\'])%copy Avi films
     catch
         msgbox(strcat('Error in video segmentation',' ',fffVideoSegmentation))
       end  
     
         try
     
    movefile([Folder_Data,'\',ListFolders(i).name ,'\',subFolders(j).name ,'\*.avi'],[Folder_Output,'\',ExpName,'VideoAviOnly','\'])%copy Avi films
     catch
         msgbox(strcat('Error in only video ',' ',fffVideoSegmentation))
     end 
   end
   waitbar(i/length(ListFolders)); 
%     

end

 close(hwait);
 h1=msgbox('Finished to order the files')

% 
%  

end
