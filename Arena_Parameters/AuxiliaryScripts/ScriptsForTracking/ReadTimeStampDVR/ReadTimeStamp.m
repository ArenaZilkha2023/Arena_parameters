function  ReadTimeStamp(Iimage,IcollectionFonts,NumberTime)
%Create a script which reads the time of the stamp time
%% 
%Variables rectangle to crop each time
%For hours

rectNumber(1,:)=[362.5100   14.5100    32.9800   47.9800];
rectNumber(2,:)=[(362.5100+30)   14.5100   32.9800   47.9800];

%For minutes

rectNumber(3,:)=[(362.5100+30+30+13)   14.5100   32.9800   47.9800];
rectNumber(4,:)=[(362.5100+30+30+30+13)   14.5100   32.9800   47.9800];

%For seconds

rectNumber(5,:)=[(362.5100+30+30+30+13+30+13)   14.5100   32.9800   47.9800];
rectNumber(6,:)=[(362.5100+30+30+30+13+30+13+30)   14.5100   32.9800   47.9800];

%For  milliseconds
rectNumber(7,:)=[(362.5100+30+30+30+13+30+13+30+30+13)   14.5100   32.9800   47.9800];
rectNumber(8,:)=[(362.5100+30+30+30+13+30+13+30+30+13+30)   14.5100   32.9800   47.9800];
rectNumber(9,:)=[(362.5100+30+30+30+13+30+13+30+30+13+30+30)   14.5100   32.9800   47.9800];


rectBlank =[424.5100   14.5100   10.9800   49.9800];

%% 
%Loop over each letter of the time  nine times.
%Inside the loop:do another loop and correlate with each letter.Create a
%vector with the maximum of correlation.
%then choice the letter
clear Time
for i=1:9 %loop over each letter
     Icrop= imcrop(Iimage,rectNumber(i,:));
        for  j=1:4                     %loop over the numbers of the library
            
             C1 = normxcorr2(Icrop,IcollectionFonts(:,:,j));
             Correl(j)=max(C1(:));
            
        end
        [M,Ind]=max(Correl);
    Time(1,i)=NumberTime(1,Ind);
    
    
    
end








end