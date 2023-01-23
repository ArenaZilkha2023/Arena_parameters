function IsBeBehaviour=CreateIsBevs2(Behaviour,IsBeBehaviour)
%This function finds who was approached
for   mouse=1:size(IsBeBehaviour,2) %loop over mouse
    mouse
    Data=[];
    Data=cell2mat(Behaviour{1,mouse});

    for event=1:size(Data,1)  
        event %loop over events    
        IsBeBehaviour([Data(event,1):Data(event,2)],Data(event,3))=1; %mark the mice who were aproached
    
    end
    
end






end
