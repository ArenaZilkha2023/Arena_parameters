function SocialMatrixN=SocialMatix(A,B,R)
%define a social matrix each place it is the number of events
%% 
%define Social Matrix
SocialMatrixN=zeros([length(R) length(R)]);
for i=1:length(R) %loop over all the ranking

%% 


Aux=B;
Aux=Aux(strcmp(strrep(R(i),'''',''),strrep(A,'''',''))); %scroll over the id from dominant of chasing
if ~isempty(Aux)
    for j=1:length(R) %loop on being chasing
        if j>i | j<i
       
      I= find(strcmp(strrep(R(j),'''',''),strrep(Aux,'''',''))); 
        if ~isempty(I)
          SocialMatrixN(i,j)=length(I);
        end
        end
    
 end

     
end
   
    
end


end

