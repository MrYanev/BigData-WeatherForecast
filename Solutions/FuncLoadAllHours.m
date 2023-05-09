function [MaxMemory] = FuncLoadAllHours(WorkFile)
WorkFile = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';   %File location

Contents = ncinfo(WorkFile);    %Storingit into a variable

MaxMemory = 0; % storage variable for the maximum memory in use by our data variable
StartLat = 1; % starting latitude
LatPossitions = 400; % number of latitude positions
StartLon = 1; % starying longitude
LongPossitions = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load
% loop through the hours loading one at a time
for StartHour = 1:25
    Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
    idxModel = 0; % current model
    for idx = 1:7
        idxModel = idxModel + 1; % move to next model index
        LoadModel = Models2Load(idx);% which model to load
        HourlyData(idxModel,:,:,:) = ncread(WorkFile, Contents.Variables(LoadModel).Name,...
            [StartLon, StartLat, StartHour], [LongPossitions, LatPossitions, NumHour]);
        fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
    end
    
    % Record the maximum memory used by the data variable so far
    MaxMemory = max( [ MaxMemory, whos('HourlyData').bytes/1000000 ] );
    fprintf('Loaded Hour %i, memory used: %.3f MB\n', StartHour, MaxMemory); % display loading information
end

