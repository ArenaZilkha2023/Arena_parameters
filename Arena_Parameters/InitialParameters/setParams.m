function Params = setParams(FLAGS,Params)

if isempty(Params)
    error('missing parameters!');
end

% ========================== DO NOT EDIT ==================================
% datenum units are days (1 = 1 day), change to sec: datenum*days2sec
Params.datenum_1Sec = 1/(24*60*60); % datestr(datenume_1Sec,'dd-mmm-yyyy HH:MM:SS:FFF')
Params.days2sec = 24*60*60;
Params.max_velocity = 4*100; % 4 [meter/sec] = 400 [cm/sec]
Params.max_velocity = inf;

% numbers of mice to be displayed:
Params.mices = 'all';

[miceType,malesList,femalesList, mice_3_chips] = getMiceIDs(Params);

Params.miceType = miceType;
Params.malesList = malesList;
Params.femalesList = femalesList;
Params.mice_3_chips = mice_3_chips;

%==========================================================================
