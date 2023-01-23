%This script is for tracking

%% ---------------------------Variables definition--------------------------------
%Insert parameters as antenna position ,sleeping box and hiding box
%Select the arena
[FileName,PathName] = uigetfile('*.avi','Select Avi file');
%% --------------------------------Create an object of the video---------------------------------
v = VideoReader(fullfile(PathName,FileName));

k=1;
while v.CurrentTime<1*60
   
       s(k).cdata=readFrame(v);
       mov(k)=im2frame(s(k).cdata);
       
       if k==5
       pict=im2frame(s(k).cdata);
       fileP=strcat('New5',FileName,'.avi');
       FN=fullfile(PathName,fileP);
       I=s(k).cdata;
      figure
       imagesc(I)
       figure
    
       I2=imcrop(I);
       I2=(I2);
       
       imagesc(I2)
      lvl = graythresh(I2);
BWOrig = im2bw(I2, lvl);
figure, imshow(BWOrig)
BWComplement = ~BWOrig;
CC = bwconncomp(BWComplement);
numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BWComplement(CC.PixelIdxList{idx}) = 0;
figure, imshow(BWComplement)
% Next, because the text does not have a layout typical to a document, you
% need to provide ROIs around the text for OCR. Use regionprops for this.
BW = imdilate(BWComplement, strel('disk',3)); % grow the text a bit to get a bigger ROI around them.
CC = bwconncomp(BW);

s = regionprops(CC,'BoundingBox');
roi = vertcat(s(:).BoundingBox);
% Apply OCR
% Thin the letters a bit, to help OCR deal with the blocky letters
BW1 = imerode(BWComplement, strel('square',1));
% Set text layout to 'Word' because the layout is nothing like a document.
% Set character set to be A to Z, to limit mistakes.
results = ocr(BWOrig, roi, 'TextLayout', 'Word','CharacterSet','1':'9');
       
%       results=ocr(BWOrig)
     
%        e(s(k).cdata,FN);
       
       end
       
       
       a=v.CurrentTime
       k=k+1;
 
%    else
%      s(k).cdata=readFrame(v);
%        mov(k)=im2frame(s(k).cdata);
%        
% %       X=s(k-1).cdata;
% %       Y=s(k).cdata;
% %       B=abs(rgb2gray(X)-rgb2gray(Y));
% %        
% %       Result(k-1)=(sum(sum(B)))';
%        
%        k=k+1
% 
%    end

end
file=strcat('New5',FileName,'.avi');

v1 = VideoWriter(fullfile(PathName,file));
v1.FrameRate=12.8;
open(v1)
writeVideo(v1,mov)

% k=1;
% for k=1:5300
% X=read(v,k);
% Y=read(v,k+1);
% X=rgb2gray(X);
% Y=rgb2gray(Y);
% B=imabsdiff(X,Y);
% Result(k)=sum(sum(B));
% k
% end
%% -----------------------------------Remove the repeated frames and create a new video---------------------------

%% ---------------Find for each frame the position of the mice in the open arena-----------------------------

%% ---------------------------------Insert a time line ---------------------------------------

%% --------------------------Create multidimensional array for each mouse-----------------------

%% -------------------Find for each mouse the number of antenna detected each time----------------------------------

%% -----------------------According the antenna number create the vectors: is sleeping, sleeping box,is hiding,hiding box, in arena, and add the sleeping/hiding position to the x,y vector------
%% 
%%------------------------ For each mouse find the arena region and follow
%%it Iknow the first position then I can follow it. The first time point
%%could be the problem if it in the arena or in the sleeping box.
%%it-------------------------





