function LoadData(~,~)
%load data
global h

folder_name=uigetdir('','Set the path of your folder which includes the folders Data, Parameters and Results');
set(h.edit1,'string',folder_name);

end

