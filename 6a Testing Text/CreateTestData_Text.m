%% Replaces one hours worth of data with empty strings
clear all
close all

WorkFile = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';
C = ncinfo(WorkFile);
VarNames = {C.Variables.Name};


%% Move to new *.nc file
FileOut = 'C:\Program Files\MATLAB\5011CEM\Model\Model\TestyTest.nc';
nccreate(FileOut, 'lat', 'Dimensions', {'lat', 400}, 'DataType', 'single');
ncwrite(FileOut, 'lat', ncread(WorkFile, 'lat'));
nccreate(FileOut, 'lon', 'Dimensions', {'lon', 700}, 'DataType', 'single');
ncwrite(FileOut, 'lon', ncread(WorkFile, 'lon'));
nccreate(FileOut, 'hour', 'Dimensions', {'hour', 25}, 'DataType', 'single');
ncwrite(FileOut, 'hour', ncread(WorkFile, 'hour'));

Model2Change = 6; % Select the model that will be overwritten with errors

for idx = 1:7
    if idx ~= Model2Change 
        Var = ncread(WorkFile, VarNames{idx});
        nccreate('TestyTest.nc', VarNames{idx},...
            'Dimensions', { 'lon', 700, 'lat', 400, 'hour', 25},...
            'DataType', 'single');
        ncwrite('TestyTest.nc', VarNames{idx}, Var);
    else
        Var = ncread(WorkFile, VarNames{idx});
        nccreate('TestyTest.nc', VarNames{idx},...
            'Dimensions', { 'lon', 700, 'lat', 400, 'hour', 25},...
            'DataType', 'char');
        var = char(Var);
        ncwrite('TestyTest.nc', VarNames{idx}, var);
    end
    
    
end

