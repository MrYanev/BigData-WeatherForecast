function ParallelProcessing
%% Loading files
WorkFile = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';

Contents = ncinfo(WorkFile);

Latitude = ncread(WorkFile, 'lat');
Longitude = ncread(WorkFile, 'lon');
NumHours = 25;

%% Processing Parameters

RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;

StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;

%% Testing variables
DataOptions = [200, 1000, 10000]; %options for the number of data
WorkerOptions = [2, 3, 4, 5, 6, 7, 8];    %options for number of workers
Results = [];
%%
%    for idx = 1: size(DataOptions, 1) % Num2Process
%        DataParameter = DataOptions(idx1);
%        for idx2 = 1:size(WorkerOptions, 1)
%            WorkerParameter = WorkerOptions(idx2);
%            RunProcess
%            Results = [Results; WorkerParameter, DataParameter, RunTime];
%        end
%    end
%% Pre-alocate output array memory

NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory

%% Load hours and models relateed to each one 
Num2Process = 1000;
Steps = 100;
tic
for idxTime = 1:NumHours
    %% Load all hours
    
    DataLayer = 1;
    for idx = [1, 2, 4, 5, 6, 7, 8]
        HourlyData(DataLayer,:,:) = ncread(WorkFile, Contents.Variables(idx).Name,...
            [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1;
    end
    
    %% Preprocess the data 
    
    [Data2Process, LatLon] = PrepareData(HourlyData, Latitude, Longitude);
%% Parallel Analysis
    %% Creating the parallel pool and attaching the necessary files
    for idx1 = 1:size(DataOptions,1)
        DataParameters = DataOptions(idx1);
        for idx2 = 1:size(WorkerOptions,1)
            WorkerParameters = WorkerOptions(idx2);
            PoolSize = WorkerParameters;
            if isempty(gcp('nocreate'))
                parpool('local',PoolSize);
            end
            poolobj = gcp;

            addAttachedFiles(poolobj,{'EnsembleValue'});
            Results = [Results; WorkerParameters; DataParameters; RunTime]
        end
    end
        
    
    %% Parallel Processing
    
    T4 = toc;
    parfor idx = 1: DataParameters % Num2Process size(Data2Process,1)
        [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
    end
    
    T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
    fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))
end
T2 = toc;
delete(gcp);

%% Reshape ensemble values to Longitute, Latitute, Hour format
EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);
fprintf('Total processing time for %i workers = %.2f s\n', PoolSize, sum(T3));

end %ParallelProcessing function ends here
    
    
    
    
    
    