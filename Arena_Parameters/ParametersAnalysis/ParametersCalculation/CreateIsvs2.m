function IsBehaviour=CreateIsvs2(Behaviour,IsBehaviour)

for   mouse=1:size(IsBehaviour,2) %loop over mouse
    mouse
    Data=[];
    Data=cell2mat(Behaviour{1,mouse});
    for event=1:size(Data,1)  
        event %loop over events    
    IsBehaviour([Data(event,1):Data(event,2)],mouse)=1;
    
    end
    
end






end
