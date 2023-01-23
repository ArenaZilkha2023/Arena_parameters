%This script is for tracking

%% ---------------------------Variables definition--------------------------------
%Insert parameters as antenna position ,sleeping box and hiding box
%Select the arena
[FileName,PathName] = uigetfile('*.avi','Select Avi file');
%% --------------------------------Create an object of the video---------------------------------
v = VideoReader(fullfile(PathName,FileName));

k=5;

   
       s(k).cdata=read(v,k);
      
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
      %% 
g=medfilt2(I2,[3 3])
conc=strel('disk',1);
gi=imdilate(g,conc);
ge=imerode(g,conc);
gdiff=imsubtract(gi,ge);
gdiff=mat2gray(gdiff);
gdiff=conv2(gdiff,[1 1;1 1]);
gdiff=imadjust(gdiff,[0.5 0.7],[0 1],.1);
B=logical(gdiff);
[a1 b1]=size(B);
figure(2)
imshow(B)