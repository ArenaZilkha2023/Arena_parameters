%This script is for tracking

%% ---------------------------Variables definition--------------------------------
%Insert parameters as antenna position ,sleeping box and hiding box
%Select the arena
[FileName,PathName] = uigetfile('*.avi','Select Avi file');
%% --------------------------------Create an object of the video---------------------------------
v = VideoReader(fullfile(PathName,FileName));

k=5;

   
       s(k).cdata=read(v,k);
      
       
      
%        pict=im2frame(s(k).cdata);
%        fileP=strcat('New5',FileName,'.avi');
%        FN=fullfile(PathName,fileP);
       I=s(k).cdata;
      figure
       imagesc(I)
       figure
    
       I2=imcrop(I);
       imagesc(I2)
      I2=(rgb2gray(I2));
      I2=imresize(I2,4);
      figure
      imshow(I2)
%    Icorrected = imtophat(I2, strel('disk', 6));  
%     % Perform morphological reconstruction and show binarized image.
%  marker = imerode(I2, strel('line',5,0));
% Iclean = imreconstruct(marker, I2);
% Icorrected = imerode(Icorrected, strel('line',5,0));
% Icorrected=I2;
% BW2 = imbinarize(Iclean);
Icorrected=imfill(I2);
figure
imshow(Icorrected)
BW1 = imbinarize(Icorrected);

figure;
imshow(BW1);
%   figure
%   imshow(BW2);
    
   % results = ocr(Icorrected,'CharacterSet', '0123456789', 'TextLayout', 'block'); 
     results = ocr(Icorrected,'Language','D:\MiceApplication\AuxiliaryScripts\ScriptsForTracking\myLang\tessdata\myLang.traineddata', 'TextLayout', 'Block');
   
    results.Text   






