 
 function SelectData(~,~)
 
 global h1
 global FileNames
 global PathNames
 
  [FileNames PathNames]=uigetfile('*', 'Choose the files to rename:','MultiSelect','on');
%     FileNames = cellstr(FileNames);
%     for i=1:length(FileNames)  
%     Path{i} = fullfile(PathNames, FileNames{i}); 

set(h1.Data,'string',FileNames);


 end