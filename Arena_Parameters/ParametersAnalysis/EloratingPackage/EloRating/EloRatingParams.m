function Params = EloRatingParams(~,~)
%variables
global h

%default
Params.k=100; %k is a constant and determines the number of points a mouse gains in a 
% %single encounter. It is set between 16 and 200.
Params.initial_rating=1000;
Params.ShufflingNumberTimes=1000;

Params.initial_rating=str2num(get(h.editEloRate,'string'));
Params.k=str2num(get(h.editElok,'string'));
Params.ShufflingNumberTimes=str2num(get(h.editShuffling,'string'));
Params.Filename=get(h.editElo1,'string');
value=(get(h.popupmenuDays,'value'));
stringvalue=(get(h.popupmenuDays,'String'));
Params.ShufflingNumberTimesLandau=str2num(get(h.editShufflingLandau,'string'));
Params.ShufflingNumberTimesGlicko=str2num(get(h.editShufflingGlicko,'string'));

Params.DaysExp=str2double(stringvalue(value));

% %% 

%Parameters of Elo rating
% %% Parameters settings
% Params.k=100; %k is a constant and determines the number of points a mouse gains in a 
% %single encounter. It is set between 16 and 200.
% Params.initial_rating=1000;
% Params.ShufflingNumberTimes=1000;
end

