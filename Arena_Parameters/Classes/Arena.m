
classdef Arena
%All related with the arena
    
    properties
        AntennaNumber;
        IsHiding;
        IsSleeping;
        AntennaCoord;
        TreshRun;
        TreshWalk;
        InOpenArena;
        InArenaVelocity;
        TreshVelocity;
    end
    
    methods
        %% -----------Determine according to sleeping and hiding when it is at the arena--
        function InArena=InArena(obj)
        InArena=zeros(length(obj.IsSleeping),1);  
        LogicalIndex=~(or(obj.IsHiding(:,1),obj.IsSleeping(:,1)));
        if any(LogicalIndex)
            InArena(LogicalIndex)=1;
        end 
        end
        %% ----------------Determine arena events interval----------------
        function InArenaInterval=InArenaInterval(obj,InArena)
            
            [EventsBeg EventsEnd]=getEventsIndexesGV(InArena,length(InArena));  
            InArenaInterval=[EventsBeg EventsEnd];   
            
        end
        
        
        
        %% -----------------Find the duplicates in the coordinates-----------------
        function InArenaDuplic=InArenaDuplic(obj,X,Y,NumberMouse,LengthMouse,InArena)
            InArenaDuplic=zeros(length(X(:,1)),1);
            clear IndexLogical1;
            clear IndexLogical2;
            clear IndexLogical3;
            clear IndexLogical4;
            clear InArena1
            
            if ~isempty(find(InArena)==1)
            ML=[1:LengthMouse];
            ML=ML(ML~=NumberMouse); %only the list for compare
         %Remove Non defined coord. as million and larger than 2000 in the arena
         IndexLogical4=(X(:,NumberMouse)<2000)& (Y(:,NumberMouse)<2000);
         InArena1=InArena & IndexLogical4; 
          
            
            XMouse=repmat(X(:,NumberMouse),1,length(ML));
            YMouse=repmat(Y(:,NumberMouse),1,length(ML));
            Xother=X(:,ML);
            Yother=Y(:,ML);
            
         
            
            IndexLogical1=(XMouse==Xother) & (YMouse==Yother);
            IndexLogical2=sum(IndexLogical1,2)>0;
            IndexLogical3=InArena1 & IndexLogical2;
            
            if ~isempty(IndexLogical3)
            InArenaDuplic(IndexLogical3,1)=1;
            end
           
            else
             InArenaDuplic=zeros(length(X(:,1)),1);  
        end
       end
    
   %------------------Find  Non defined in the arena---------------------
   function InArenaNonDefined=InArenaNonDefined(obj,X,Y,NumberMouse,InArena)
    InArenaNonDefined=zeros(length(InArena),1);
    clear IndexLogical1;
    clear IndexLogical2;
    
    IndexLogical1=(X(:,NumberMouse)>10000)| (Y(:,NumberMouse)>10000); %consider 20000 and million 
    IndexLogical2=InArena & IndexLogical1;
    
    if ~isempty(IndexLogical2)
    InArenaNonDefined(IndexLogical2,1)=1;
    end
   
   
    
   end

   %% ---------------------find intervals of all the duplicates------------------
   function InArenaDuplicatesInterval=InArenaDuplicatesInterval(obj,InArenaDuplic)
       
       [EventsBeg EventsEnd]=getEventsIndexesGV(InArenaDuplic,length(InArenaDuplic));
       
       InArenaDuplicatesInterval=[EventsBeg EventsEnd];
       
   end
%    
%    %% -------------------------------------Calculate velocity without repeats---------------------------------
%    function InArenaVelocity=InArenaVelocity(obj,RepeatedFrames,XMouse,YMouse,ElapTime)
%       InArenaVelocity=zeros(length(XMouse),1);
%       
%       XMouseWithoutRepeats=XMouse(RepeatedFrames);
%       YMouseWithoutRepeats=YMouse(RepeatedFrames);
%       
%       TimeWithoutRepeats=ElapTime(RepeatedFrames);
%     
%       
%       DiffTime=diff(TimeWithoutRepeats);
%       AuxVelocity=(sqrt(sum([diff(XMouseWithoutRepeats) diff(YMouseWithoutRepeats)].^2,2))); %velocity in cm/sec
%       AuxVelocity=(AuxVelocity./DiffTime)*100;
%        InArenaVelocity(RepeatedFrames(2:length(RepeatedFrames),1))=AuxVelocity;
%        
%        
%    end
   %%    %% -------------------------------------Calculate velocity without repeats with constant time frames---------------------------------
   function InArenaVelocityR=InArenaVelocityR(obj,RepeatedFrames,XMouse,YMouse,ElapTime,InArena)
      InArenaVelocityR=zeros(length(XMouse),1);
      
      XMouseWithoutRepeats=XMouse(RepeatedFrames);
      YMouseWithoutRepeats=YMouse(RepeatedFrames);
      
      TimeWithoutRepeats=ElapTime;
    
      
      DiffTime=TimeWithoutRepeats;
      AuxVelocity=(sqrt(sum([diff(XMouseWithoutRepeats) diff(YMouseWithoutRepeats)].^2,2))); %velocity in cm/sec
      AuxVelocity=(AuxVelocity/DiffTime)*100;
       InArenaVelocityR(RepeatedFrames(2:length(RepeatedFrames),1))=AuxVelocity;
       
       %%-----------Final corrections of velocity
    
       InArenaVelocityR(~InArena,1)=0;%adjust velocity to zero when it is not in the arena
      
       InArenaVelocityR(InArenaVelocityR>1000,1)=0; %in general at the exit of the cages the velocity is  very big and not real
     
   end
   %% 
   
   %%-------------- Refill the repeated places with the velocity---
   function InArenaVelocityAllFrames=InArenaVelocityAllFrames(obj,RepeatedFrames,InArenaVelocityR)
       
       InArenaVelocityAllFrames=InArenaVelocityR;
       
       for i=1:length(RepeatedFrames)
           
           if i==length(RepeatedFrames)
           InArenaVelocityAllFrames(RepeatedFrames(i):end,1)=InArenaVelocityR(RepeatedFrames(i),1);
           else
            InArenaVelocityAllFrames(RepeatedFrames(i):RepeatedFrames(i+1)-1,1)=InArenaVelocityR(RepeatedFrames(i),1);   
           end 
           
       end
       
       
       
       
   end
   
%% -----------------------------Before determine the mouse activity interpolate the velocity inside the arena  since sometimes the velocity drops to zero and it is not good----------
function InArenaVelocityRInterp=InArenaVelocityRInterp(obj,RepeatedFrames,InArenaVelocityR,InArenaWithCorrections)
    
 %---Clear variables---------------
 clear VelocitySelect
 clear AuxVector
 clear IndexVelNull
 clear Velocityint
 clear InArenaVelocityRInterp
 clear I1
 
 %------------------
    
 
 InArenaVelocityRInterp=InArenaVelocityR;   
    
 VelocitySelect=InArenaVelocityR(RepeatedFrames,1);
 AuxVector=[1:length(VelocitySelect)]';
 
 
 IndexVelNull=find(VelocitySelect==0 & InArenaWithCorrections(RepeatedFrames,1)==1);%found inside the arena null velocities (which are due because repeated frames)-this values will be interpolated
 

 
 if ~isempty(IndexVelNull)

VelocitySelect(IndexVelNull,1)=NaN;

try
 Velocityint=interp1(AuxVector,VelocitySelect,AuxVector(IndexVelNull),'cubic');
 %-------Remove very negative values from the velocity-----------------
 I1=find(Velocityint<-100); %This happen at the beggining a file.
 if ~isempty(I1)
 Velocityint(I1)=0;    
 end
 
 
 VelocitySelect(IndexVelNull,1)=Velocityint;
catch
 %error interpolation
 end
 end
 InArenaVelocityRInterp(RepeatedFrames,1)=VelocitySelect;
    
end
   
   
   %% -------------------------------Determine Activity of the mouse in the arena with the velocity calculated in the arena-----------------------------------------------
   function InArenaActivity=InArenaActivity(obj,InArenaVelocity)
       
       RunInd=zeros(length(InArenaVelocity),1);
       WalkInd=zeros(length(InArenaVelocity),1);
       StopInd=zeros(length(InArenaVelocity),1);
        
     
          RunInd=(~isnan(InArenaVelocity))& (InArenaVelocity >= obj.TreshRun)& (InArenaVelocity < obj.TreshVelocity); %THE VELOCITY CANNOT BE MORE THAN 200CM/SEC
          WalkInd=(~isnan(InArenaVelocity))& (InArenaVelocity >= obj.TreshWalk)& (InArenaVelocity < obj.TreshRun);
          StopInd=(~isnan(InArenaVelocity))& (InArenaVelocity < obj.TreshWalk)& (InArenaVelocity >0);%eliminate the zero which not necessarily means zero movement
          
          %NonCorrectVelocity=(~isnan(InArenaVelocity))& (InArenaVelocity >= 200)& (InArenaVelocity < 1e6);
          
       
         InArenaActivity=[StopInd,WalkInd,RunInd];
     
     
       
   end
   
   
   
   %% -----------------------------------Calculate auxiliary parameters for chasing----------------------------------------
   function InArenaAuxiliary=InArenaAuxiliary(obj,XMouse,YMouse)
       
       
       Distance=(sqrt(sum([diff(XMouse) diff(YMouse)].^2,2)));
       %Calculation vector for chasing
       vectorx=diff( XMouse);
       vectory=diff( YMouse);
       vectorx1=vectorx;
       vectory1=vectory;
       Inozero=vectorx~=0 & vectory~=0;
       vector=[vectorx(Inozero) vectory(Inozero)]; 
       norm_vec=sqrt(sum(vector.^2,2));
       vectorx(Inozero)=vector(:,1)./norm_vec;
       vectory(Inozero)=vector(:,2)./norm_vec;
       
       InArenaAuxiliary=[Distance vectorx vectory vectorx1 vectory1];
   end
   %% --------------------------Calculate distance to antenna-----------------------
   function InArenaAntennaDistance=InArenaAntennaDistance(obj,XMouse,YMouse,InArenaDuplic,AntennaNumber)
       clear N;
       clear XAntennaSel;
       clear YAntennaSel;
    
       
       N=cellfun(@conversion,AntennaNumber);
      
       XAntenna=obj.AntennaCoord(N,1);
       YAntenna=obj.AntennaCoord(N,2);
       
       InArenaAntennaDistance=zeros(length(InArenaDuplic),1);
     
       if ~isempty((find(InArenaDuplic==1)))
       Index=find(InArenaDuplic==1);
       XSelected=XMouse(Index);
       YSelected=YMouse(Index);
       XAntennaSel=XAntenna(Index);
       YAntennaSel=YAntenna(Index);
       
       
       dist=(sqrt(sum([(XSelected-XAntennaSel) (YSelected-YAntennaSel)].^2,2)));
       InArenaAntennaDistance(Index,1)=dist;
       end
   end
   %% ---------------------Arrange repeated and non defined places----------------------
   function InArenaCorrectedCoord=InArenaCorrectedCoord(obj,X,Y,RepeatedFrames,DistanceToAntenna,IndexDuplicate,IndexNonDefine,TimeFrame,AntennaNumber)
       
           
   clear XR
   clear YR
   clear DistanceToAntennaR
   clear IndexDuplicateR
   clear IndexNonDefineR
   clear TimeFrameR
   clear I
   clear I1
   clear N
       
   XR=X(RepeatedFrames);
   YR=Y(RepeatedFrames);
   DistanceToAntennaR=DistanceToAntenna(RepeatedFrames);
   IndexDuplicateR=IndexDuplicate(RepeatedFrames);
   IndexNonDefineR=IndexNonDefine(RepeatedFrames);
   TimeFrameR=TimeFrame(RepeatedFrames);
   
   %------------------- antenna coord.--------------------
   
    N=cellfun(@conversion,AntennaNumber);
   AntennaPositionX=obj.AntennaCoord(N,1);
    AntennaPositionY=obj.AntennaCoord(N,2);
   
   AntennaPositionXR=AntennaPositionX(RepeatedFrames);
   AntennaPositionYR=AntennaPositionY(RepeatedFrames);
   
   %--------------------------find the duplicates------------
   
   ILogical1=(IndexDuplicateR==1)&(DistanceToAntennaR>120) & (TimeFrameR<80) ;
   ILogical2=(IndexDuplicateR==1)&(DistanceToAntennaR>120) & (TimeFrameR>80) ;
  %determine what to do with duplicates
  if ~isempty(find( ILogical1==1))
    I= find( ILogical1==1);
   XR(I)=AntennaPositionXR(I);   %in the case the information of antenna is almost sure we replaced the coordinates
   YR(I)=AntennaPositionYR(I);   
  end
  if  ~isempty(find( ILogical2==1))
      I2=find(ILogical2==1);
       XR(I2)=NaN;   %in the case the information of antenna is not sure
       YR(I2)=NaN;  
      
  end
   
   %-------------------------------------Correct non-defined positions------------------
      ILogical3=(IndexNonDefineR==1)&(TimeFrameR<80);
      ILogical4=(IndexNonDefineR==1)&(TimeFrameR>80);
  %determine what to do with duplicates
  if ~isempty(find(ILogical3==1))
      I3= find(ILogical3==1);
   XR(I3)=AntennaPositionXR(I3);   %in the case the information of antenna is almost sure we replaced the coordinates
   YR(I3)=AntennaPositionYR(I3);   
  end
  if  ~isempty(find(ILogical4==1))
       I4= find(ILogical4==1);
       XR(I4)=NaN;   %in the case the information of antenna is not sure
       YR(I4)=NaN;  
      
  end
   %----------------------------------Return the repeats coordinates----------------
   Xaux=zeros(length(X),1);
   Yaux=zeros(length(Y),1);
    
   
    Xaux(RepeatedFrames)=XR;
    Yaux(RepeatedFrames)=YR;
   
   InArenaCorrectedCoord=[Xaux,Yaux];
   
   
   %----------------------------------------------------
   
   
   end
   %% -Correct non defined position-------
   
   function InArenaCorrectedNonDefinedCoord=InArenaCorrectedNonDefinedCoord(obj,ArrayX,ArrayY,Mouse_Number,RepeatedFrames,InArenaNonDefined,ArrayRFID,ArrayXMissing,ArrayYMissing) 
       %% 
       
          %variables
          %loop through non defined coord.not repeated
          InArenaNonDefinedD=InArenaNonDefined(RepeatedFrames); %work only with not repeated
          IndexNonD=find(InArenaNonDefinedD==1);%find index non defined
          
          ArrayRFIDD=ArrayRFID(RepeatedFrames,:);
          ArrayXMissingD=ArrayXMissing(RepeatedFrames,:);
          ArrayYMissingD=ArrayYMissing(RepeatedFrames,:);
          ArrayXD=ArrayX(RepeatedFrames);
          ArrayYD=ArrayY(RepeatedFrames);
          
          %% 
          
          for i=1:length(IndexNonD)
             clear Xblank
             clear Yblank
             clear Dist
             clear I
             clear CoordBlank
             
             
             if length(unique(ArrayRFIDD(IndexNonD(i),:)))==length(ArrayRFIDD(IndexNonD(i),:))   %correct only cased that the antenna identification is different for all the mice 
                 %% Data of the target mouse
                  AntennaNumber=str2num(ArrayRFIDD{IndexNonD(i),Mouse_Number});
                  XAntenna=obj.AntennaCoord(AntennaNumber,1);
                  YAntenna=obj.AntennaCoord(AntennaNumber,2); 
                  
                  %% Positions
                  AntennaPos=[XAntenna,YAntenna];
                  %remove NAN
                  Xblank= ArrayXMissingD(IndexNonD(i),:);
                  Yblank= ArrayYMissingD(IndexNonD(i),:);
                  
                  if ~isempty(Xblank{1}) %if there are data
                      
                      Xblank= [ArrayXMissingD{IndexNonD(i),:}];
                      Yblank= [ArrayYMissingD{IndexNonD(i),:}];
                    if   ~isempty(find(isnan(Xblank)))
                      Xblank=Xblank(1:find(isnan(Xblank)==1,1,'first')-1);
                      Yblank=Yblank(1:find(isnan(Yblank)==1,1,'first')-1);
                      CoordBlank=[Xblank',Yblank'];
                    else
                        CoordBlank=[Xblank',Yblank'];
                    end
                  
                        %% Measure the distance to the position of the missing file
                        Dist=Calc_dist(CoordBlank,AntennaPos);
                        [M,I]=min(Dist); %look for the minimum distance to the respective antenna
                        if Dist(I)<200 %if the distance is less than 20cm -consider this value
                                ArrayXD(IndexNonD(i))=Xblank(I);
                                ArrayYD(IndexNonD(i))=Yblank(I);
                                InArenaNonDefinedD(IndexNonD(i))=0;             %Turn the nondefined to 0 
                 
                 
                            %% %Add the repeated frames
                            ArrayX(RepeatedFrames(IndexNonD(i)):RepeatedFrames(IndexNonD(i)+1)-1)=Xblank(I);
                            ArrayY(RepeatedFrames(IndexNonD(i)):RepeatedFrames(IndexNonD(i)+1)-1)=Yblank(I);
                            InArenaNonDefined(RepeatedFrames(IndexNonD(i)):RepeatedFrames(IndexNonD(i)+1)-1)=0;
                
               
                 
                 
                       end 
             
                  end
                
            
              
            
            end   
          end
             InArenaCorrectedNonDefinedCoord=[ArrayX,ArrayY,InArenaNonDefined]; 
             %% 
       
          end
       
        
       
   
   
   
   
   
   
   
   
   
   
   %% -------------------------------Interpolate -----------------------------------------------
   
   function InArenaInterpolation=InArenaInterpolation(obj,RepeatedFrames,TimeFrame,X,Y)
      clear XR;
      clear YR;
      clear TimeR;
      clear XR;
      clear YR;
      clear InArenaInterpolation;
      
      XR=X(RepeatedFrames);
      YR=Y(RepeatedFrames);
      TimeR=TimeFrame(RepeatedFrames);
      
      IndexNaN=find(isnan(XR)==1); %these are the indexes for interpolation
     
     if ~isempty(IndexNaN) & length(XR)>100 %for interpolation need enough data
        
     XRint=interp1(TimeR,XR,TimeR(IndexNaN),'cubic');
     YRint=interp1(TimeR,YR,TimeR(IndexNaN),'cubic');  
     
     XR(IndexNaN)=XRint;%add the correction
     YR(IndexNaN)=YRint;
     end
      %----------------------------------Return the repeats coordinates----------------
   Xaux=zeros(length(X),1);
   Yaux=zeros(length(Y),1);
    
   
    Xaux(RepeatedFrames)=XR;
    Yaux(RepeatedFrames)=YR;
   
   InArenaInterpolation=[Xaux,Yaux];
   
   
   %----------------------------------------------------
     
     
   end
   %% --------------------------Return repeated frames-----------------------
   function InArenaAddRepeats=InArenaAddRepeats(obj,RepeatedFrames,Xinterp,Yinterp)
       XinterpR=Xinterp;
       YinterpR=Yinterp;
       
    for i=1:length(RepeatedFrames)
        if i==length(RepeatedFrames)
       XinterpR(RepeatedFrames(i)+1:length(Xinterp))=repmat(Xinterp(RepeatedFrames(i)),(length(Xinterp)-RepeatedFrames(i)),1); 
       YinterpR(RepeatedFrames(i)+1:length(Xinterp))=repmat(Yinterp(RepeatedFrames(i)),(length(Xinterp)-RepeatedFrames(i)),1);  
        else
       XinterpR(RepeatedFrames(i):RepeatedFrames(i+1)-1)=repmat(Xinterp(RepeatedFrames(i)),(RepeatedFrames(i+1)-RepeatedFrames(i)),1); 
       YinterpR(RepeatedFrames(i):RepeatedFrames(i+1)-1)=repmat(Yinterp(RepeatedFrames(i)),(RepeatedFrames(i+1)-RepeatedFrames(i)),1);  
            
        end
    end
     
    
    InArenaAddRepeats=[XinterpR,YinterpR];
       
       
   end
   
   
    end
end
%% %% AUXILIARY FUNCTIONS
function [EventsBeg EventsEnd]=getEventsIndexesGV(IndLogical,n)

EventsBeg=find(diff(IndLogical)==1)+1;
EventsEnd=find(diff(IndLogical)==-1);

if isempty(EventsBeg)||isempty(EventsEnd)
    if(isempty(EventsBeg)&&~isempty(EventsEnd))
        EventsBeg=[1;EventsBeg];
    elseif(isempty(EventsEnd)&&~isempty(EventsBeg))
        EventsEnd=[EventsEnd;n];
    else
        if sum(IndLogical)==n
            EventsBeg=1;
            EventsEnd=n;
        end
    end
else
    if(EventsBeg(1)>EventsEnd(1))
        EventsBeg=[1;EventsBeg];
    end
    
    if(EventsBeg(end)>EventsEnd(end))
        EventsEnd=[EventsEnd;n];
    end
end

end

%% Convert to number

function a=conversion(x)

a=str2num(x);


end
%% calculate distance

function distancia=Calc_dist(CoordBlank,AntennaPos)

  distancia=sqrt(sum((repmat(AntennaPos,size(CoordBlank,1),1)-CoordBlank).^2,2));




end
