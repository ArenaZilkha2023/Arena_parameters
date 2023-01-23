function vl=check1Field(struct,fieldName,defltVal)
% vl=check1Field(struct,fieldName[,defaultValue]);
%
% if the field exists in structure,
%       check1Field(S,'F1',vl) == S.F1,
% if not, vl will be returned (instead of error)

if(0) % USAGE
   a.b.c=15;
   c=check1Field(a.b,'c',26); % c==15
   d=check1Field(a.b,'d',26); % d==26
end

if nargin<3 
    defltVal=[]; 
end
if isfield(struct,fieldName)
    vl=getfield(struct,fieldName);
else
    vl=defltVal; 
end

