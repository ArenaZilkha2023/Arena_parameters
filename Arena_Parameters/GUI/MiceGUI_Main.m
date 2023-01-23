


clear all
%%Remember the root folder could be anything
global Image2
global Image3
global Image4
global Image5
global Image6
global Image7

global version
global root_folder
%% This GUI enter Parameters as:
current_folder=cd;
%recover the root
root_folder=current_folder(1:length(current_folder)-3)
%% 
[x,map]=imread('open folder.jpg');
Image2=imresize(x, [60 40]);

[x1,map]=imread('start-icon.jpg');
Image3=imresize(x1, [60 40]);

[x2,map]=imread('starting-icon.jpg');
Image4=imresize(x2, [60 40]);

[x2,map]=imread('Button-Ok-icon.png');
Image5=imresize(x2, [60 40]);

[x2,map]=imread('Microsoft-Word-2013-icon.png');
Image6=imresize(x2, [60 40]);

[x2,map]=imread('movie-icon.jpg');
Image7=imresize(x2, [60 40]);

%% Add path
addpath(genpath([root_folder,'ToolsToTreatFile\']))
addpath(genpath([root_folder,'ComputationOfParameters\']))
addpath(genpath([root_folder,'InitialParameters\']))
addpath(genpath([root_folder,'ScriptsForValidation\']))
addpath(genpath([root_folder,'NewScripts\']))
addpath(genpath([root_folder,'ParametersAnalysis\']))
addpath(genpath([root_folder,'Classes\']))
addpath(genpath([root_folder,'ComputationParametersNew\']))
addpath(genpath([root_folder,'AuxiliaryFiles\']))
addpath(genpath([root_folder,'ParametersAnalysis\ParametersCalculation\cbrewer\']))
%% Create  a menu bar for choosing either settings of parameter or------
version='vs. 4 2017-08-30'; %add version as global parameter


h=figure('Name',strcat('Mice GUI --',version),'NumberTitle','off','MenuBar','none','Position',[300 ,600,800,50]);
e= uimenu(h,'Label','Treat data','Separator','on'); %create set mice
    uimenu(e,'Label','Order Mice Tracer data','Callback',@OrderMiceTracerGui);

% f = uimenu(h,'Label','Set Initial Parameters','Separator','on'); %create set mice
%     uimenu(f,'Label','Set Mice identity','Callback',@MiceID);
    
 g = uimenu(h,'Label','Get locomotion parameters','Separator','on'); %create run
   % uimenu(g,'Label','Run to get locomotion data from GV Script','Callback',@RunAll); 
    %uimenu(g,'Label','Run to get parameters from locomotion data of GV scripts','Callback',@RunParameters); 
    %uimenu(g,'Label','Get locomotion parameters for a given mouse/period of time','Callback',@RunIndividually); 
    %uimenu(g,'Label','Get locomotion parameters for a given mouse/period of time with RFID information','Callback',@RunIndividuallyRFID); 
    uimenu(g,'Label','Get locomotion parameters','Callback',@RunAllAddingRFID); 
        
        
 i= uimenu(h,'Label','Validation','Separator','on'); %for validation
    uimenu(i,'Label','Indicate location of arena elements in the video','Callback',@ValidationGUILocationElements); 
    uimenu(i,'Label','Prepare movie which shows the validation of individual parameters- For individual mice','Callback',@MainGUI_MarkActivity_EachMouse);
    uimenu(i,'Label','Indicate head and tail of active mouse','Callback',@ValidationGUI);
    uimenu(i,'Label','Indicate chasing  of a given mouse in the video','Callback',@ValidationGUIChasing);
    uimenu(i,'Label','Indicate the social events in a video according to a list','Callback',@MainGUI_ValidationSocialEvents);
    uimenu(i,'Label','Prepare movie which shows the validation of individual parameters -All mice together','Callback',@MoviePreparationForValidation);
    
    
    
 j = uimenu(h,'Label','Hierarchical Analysis','Separator','on'); %for hierarchal analysis
    uimenu(j,'Label','Elo-rating calculation','Callback',@EloGui);
    uimenu(j,'Label','Calculate all the parameters','Callback',@RunParametersNew);
    uimenu(j,'Label','Clustering and PCA of the parameters','Callback',@RunParametersClustering);
    uimenu(j,'Label','Z-scoring of all the parameters','Callback',@RunParametersZscoring);
    uimenu(j,'Label','Add chasing corrections both in matlab and excel file','Callback',@AddManualChasingCorrectionsGUI); 
     
    %% 
