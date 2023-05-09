StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

Num2Process = 1000; %Number of processes in paralell processing scrip
Steps = 100;    %Number of steps in the pararell processing scrip
NumberOfHours = 25; %Number of hours to process in the parallel analysis
Latitude = ncread(WorkFile, 'lat'); %reading the latitudes form the file
Longitude = ncread(WorkFile, 'lon'); %reading the longituted from the file   
RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;


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
fprintf('Memory used for 1 hour of data: %.3f MB\n', HourDataMem)
