function  CorrMean=GetCorrelation(InArena)

% Idea is to get foraging correlation (Forkosh et. al 2017)
%Get correlation inside the arena betwen one mouse and the rest (mean). If
%the 2 mouse are in the arena at the same time correlation is 1.
mouse=[1:size(InArena,2)];
%%
for mouse1=1:size(InArena,2)
  ic=1;
   for mouse2=setdiff(mouse,mouse1)
      Rho(mouse1,ic)=corr(InArena(:,mouse1),InArena(:,mouse2));% must be a vector of dimension 4
      if isnan(Rho(mouse1,ic)) % When  one vector is zero the corr is NaN
        Rho(mouse1,ic)=0; % No correlation between mouse 1 and mouse2
    end
      
      ic=ic+1;
   end
    
    
end
CorrMean=mean(Rho,2); %mean in the columns




end