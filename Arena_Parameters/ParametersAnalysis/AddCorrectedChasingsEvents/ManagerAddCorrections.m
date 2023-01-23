function ManagerAddCorrections(~,~)
%% ------------Correct each matlab files ------------------

%% 
global h

%-------------------Select the experiments-------------------
index_selected = get(h.listAdd,'Value');
list = get(h.listAdd,'String');
item_selected = list(index_selected,1); % Convert from cell array

Exp_arrA=item_selected'; %Input Data


%% -----------------------Select the experiments -----------------------
hbar = waitbar(0,'Please wait...');
for t=1:length(item_selected) %LOOP FOR EACH EXPERIMENT
    
      g= msgbox(strcat('Now is running',item_selected(t)));
      Folder_Data=strcat(get(h.editAdd1,'string'),'\',item_selected(t),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlab','\'));
  %%  Folder_Data=strcat(get(h.editAdd1,'string'),'\',item_selected(t),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlabCorr0.7_200','\')); %spetial case 2021
      Folder_Data=char(Folder_Data);
      ListFiles=dir([Folder_Data,'*.mat']);
      item_selected(t)
    for countFile=1:1:length(ListFiles(not([ListFiles.isdir]))) %GO OVER EACH FILE
 
             load(strcat(Folder_Data,ListFiles(countFile).name));    
             ListFiles(countFile).name  
%% -------------- Add chasing corrected manually ---
      
              file_chasing_manual = strcat(get(h.editAdd1,'string'),'\',item_selected(t),'\',item_selected(t),'\','Results\','Chasing-manual.xlsx');
              Aux_chasing = ArrangeManualChasing(Locomotion,ListFiles(countFile).name,file_chasing_manual); 
              Locomotion.AssigRFID.Behaviour.Chasing.chasing = Aux_chasing;
              Aux_chased = ArrangeManualChased(Locomotion,ListFiles(countFile).name,file_chasing_manual);
              Locomotion.AssigRFID.Behaviour.Chasing.chased = Aux_chased;
                 %save  the structure
              %   strcat(Folder_Data,ListFiles(countFile).name)
              save(strcat(Folder_Data,ListFiles(countFile).name),'Locomotion');
             % save(strcat(Folder_Data,ListFiles(countFile).name),'Locomotion.AssigRFID.Behaviour.Chasing.chased');
    end
     g= msgbox(strcat('Saving into excel file',item_selected(t)));
%% -Create new excel file with chasing events --
        Filename = strcat(get(h.editAdd1,'string'),'\',item_selected(t),'\',item_selected(t),'\','Results\','Chasing-after_corrections.xlsx');
        CreateCsvData(Filename,Folder_Data);
%%

     g= msgbox(strcat('Finished',item_selected(t)));
     
end