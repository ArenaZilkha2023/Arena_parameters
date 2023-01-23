function Params = GlickoRatingParams(~,~)
global h
Params.InitialRating=2200;
Params.InitialRatingDesviation=350;
Params.Cconstant=3;

% days to use
value=(get(h.popupmenuDays,'value'));
stringvalue=(get(h.popupmenuDays,'String'));
Params.DaysExp=str2double(stringvalue(value));




end 