%Script to read the time stamp of each frame

%% -------------Variables definition--------------------

[FileName,PathName] = uigetfile('*.avi','Select Avi file');

rectBig=[ 265.5100  557.5100  176.9800   18.9800]; %to crop all the title


%Directory with the fonts
folder_name=uigetdir('.tif','Load the directory with the fonts of the numbers');



%% Create a collection of intensities Array for each letter
for i=1:4
    switch(i)
        case 1
           Iaux=imread(fullfile(folder_name,'Zero.tif'));
           I(:,:,1)=rgb2gray(Iaux);
           NumberTime(1,1)=0;
        case 2
           Iaux=imread(fullfile(folder_name,'Two.tif'));
            I(:,:,2)=rgb2gray(Iaux);
           NumberTime(1,2)=2;
        case 3
            Iaux=imread(fullfile(folder_name,'Three.tif'));
           I(:,:,3)=rgb2gray(Iaux);
           NumberTime(1,3)=3;
         case 4
            Iaux=imread(fullfile(folder_name,'Four.tif'));
            I(:,:,4)=rgb2gray(Iaux);
           NumberTime(1,4)=4;
           
    
    end
end



%% %% --------------------------------Create an object of the video---------------------------------
v = VideoReader(fullfile(PathName,FileName));

 k=6;
       s(k).cdata=read(v,k);
       Iaux=s(k).cdata;
       figure
       imagesc(Iaux)
       
        figure
        I2 = imcrop(Iaux,rectBig); %crop the timestamp
       
        I2=(rgb2gray(I2)); 
        I2=imresize(I2,4); %%conversion to gray scale and resize
         imshow(I2)
        
        
        
     
        %% ---------------Compare each letter with the library-------------------
       ReadTimeStamp(I2,I,NumberTime);
      
       

