function IsBehaviour=CreateIs(Behaviour,IsBehaviour)

for   mouse=1:size(IsBehaviour,2) %loop over mouse
    mouse
    Data=[];
    Data=Behaviour{mouse};
    for event=1:size(Data,1)  
        event %loop over events    
    IsBehaviour([Data(event,1):Data(event,2)],mouse)=1;
    
    end
    
end






end