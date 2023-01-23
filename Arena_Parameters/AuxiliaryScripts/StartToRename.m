function StartToRename(~,~)
global FileNames
global PathNames

     FileNames = cellstr(FileNames);
     for i=1:length(FileNames)  
      Index=[];   
     Path{i} = fullfile(PathNames, FileNames{i});
     
     Index=findstr(FileNames{i},'.');
    
     NewFileNames{i}=FileNames{i};
     
     NewFileNames{i}(Index(2)-length([1:Index(1)-1]):Index(2)-1)=FileNames{i}(1:Index(1)-1);
     
     NewFileNames{i}(Index(2)-length([1:Index(1)-1])-1)='.';
     
     NewFileNames{i}(1:Index(2)-length([1:Index(1)-1])-2)=FileNames{i}(Index(1)+1:Index(2)-1);
     
     
     
     
     mkdir(fullfile(PathNames,'RenameFiles'));
     
     Destination=fullfile(PathNames,'RenameFiles',NewFileNames{i})
     
     copyfile(char(Path{i}),Destination,'f');
     
     end
end

