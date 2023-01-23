function [Rmatrixglico,RDmatrixglico] = PreprocessGlicko(SubsetDataWithR,DaysWR,IndexChasing,IndexBeingChasing,MouseID,...
    InitialRating,InitialRatingDesviation,Cconstant,Days)

for day=1:size(DaysWR,1)
    
      % find index for each day

       % Create for each day a social matrix %this function is at landau
       % folder
       
        SocialMatrixN=SocialMatix(SubsetDataWithR(find(Days==DaysWR(day)),IndexChasing),SubsetDataWithR(find(Days==DaysWR(day)),IndexBeingChasing),MouseID); %Change  4 and 5 by general
       
        %Calculation of glicko for each mice
        [Rglicko, RDglicko]=GlickoCalculationPerDay(SocialMatrixN,MouseID,InitialRating,InitialRatingDesviation);
        
        % adjust the rating desviations for the next period
        for count=1:size(MouseID,1)
         InitialRatingDesviation(count,1)=min(sqrt(RDglicko(count,1)^2+Cconstant^2),350); %this is the input to the next day - a column vector for each mouse
        end
         
         InitialRating= Rglicko; %this is the input to next day- a column vector for each mouse
         
         
         %Summary the results
         Rmatrixglico(:,day)=Rglicko; %create a matrix where the rows are mice and the columns are days.
         RDmatrixglico(:,day)=RDglicko;  %create a matrix where the rows are mice and the columns are days.           
end 

end