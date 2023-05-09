function [HourDataMem] = LoadHours(WorkFile)
WorkFile = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';   %File location

Contents = ncinfo(WorkFile);    %Storingit into a variable
StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
idxModel = 0; % current model
for idx = 1:7
    idxModel = idxModel + 1; % move to next model index
    LoadModel = Models2Load(idx); % which model to load
    ModelData(idxModel,:,:,:) = ncread(WorkFile, Contents.Variables(LoadModel).Name,...
        [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
    fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
end

HourDataMem = whos('ModelData').bytes/1000000;
fprintf('Memory used for 1 hour of data: %.3f MB\n', HourDataMem);
end

