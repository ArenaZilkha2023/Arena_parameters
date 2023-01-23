%This script is for tracking

%% ---------------------------Variables definition--------------------------------
%Insert parameters as antenna position ,sleeping box and hiding box
%Select the arena
[FileName,PathName] = uigetfile('*.avi','Select Avi file');

%% Variables to consider

rectBig=[ 265.5100  557.5100  176.9800   18.9800]; %to crop all the title

rectNumber=[362.5100   14.5100   32.9800   47.9800];

rectNumber1=[(362.5100+30)   14.5100   32.9800   47.9800];

rectBlank =[424.5100   14.5100   10.9800   49.9800];

rectNumber1=[(362.5100+30)   14.5100   32.9800   47.9800];
rectNumber2=[(362.5100+30+30+13)   14.5100   32.9800   47.9800];

rectNumber3=[(362.5100+30+30+30+13)   14.5100   32.9800   47.9800];

rectNumber4=[(362.5100+30+30+30+13+30+13)   14.5100   32.9800   47.9800];
rectNumber5=[(362.5100+30+30+30+13+30+13+30)   14.5100   32.9800   47.9800];

rectNumber6=[(362.5100+30+30+30+13+30+13+30+30+13)   14.5100   32.9800   47.9800];
rectNumber7=[(362.5100+30+30+30+13+30+13+30+30+13+30)   14.5100   32.9800   47.9800];

rectNumber8=[(362.5100+30+30+30+13+30+13+30+30+13+30+30)   14.5100   32.9800   47.9800];


%% --------------------------------Create an object of the video---------------------------------
v = VideoReader(fullfile(PathName,FileName));

k=36;
   
       s(k).cdata=read(v,k);
      
       I=s(k).cdata;
         figure
        imagesc(I)
        figure
    
       I2 = imcrop(I,rectBig);
       
       imagesc(I2)
      I2=(rgb2gray(I2));
      I2=imresize(I2,4);
%       imwrite(I2,'test.jpeg')
      figure
      imshow(I2)


      I3=imcrop
       
    % I3 = imcrop(I2,rectNumber8);
     figure
      imshow(I3)
    
Intensity.IoneF=I3;
save('Intensity.mat','Intensity')

%       %% 
% I4=imread('D:\MiceApplication\AuxiliaryScripts\ScriptsForTracking\NumbersOfTimeStamp\Two.tif');
% I4=rgb2gray(I4);
% imshow(I4)
% 
% I5=imread('D:\MiceApplication\AuxiliaryScripts\ScriptsForTracking\NumbersOfTimeStamp\Zero.tif');
% I5=rgb2gray(I5);
% imshow(I5)
% 
%   C1 = normxcorr2(I4,I5);
%    max(C1(:))