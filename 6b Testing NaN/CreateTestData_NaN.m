%% Replaces one hours worth of data with NaN
clear all
close all

OriginalFileName = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';
NewFileName = 'C:\Program Files\MATLAB\5011CEM\Model\Model\TestFileNaN.nc';
copyfile(OriginalFileName, NewFileName);

C = ncinfo(NewFileName);
ModelNames = {C.Variables(1:8).Name};


%% Change data to NaN
BadData = NaN(700,400,1);

%% Write to *.nc file
Hour2Replace = 12;
for idx = 1:8
    ncwrite(NewFileName, ModelNames{idx}, BadData, [1, 1, Hour2Replace]);
end
