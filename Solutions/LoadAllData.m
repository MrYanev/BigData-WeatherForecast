WorkFile = 'C:\Program Files\MATLAB\R2021a\bin\o3_surface_20180701000000.nc';   %File location

Contents = ncinfo(WorkFile);    %Storingit into a variable

for idx = 1:8
    AllData(idx,:,:,:) = ncread(WorkFile, Contents.Variables(idx).Name);
    fprintf('Loading %s\n', Contents.Variables(idx).Name); % Display loading information
end

AllDataMem = whos('AllData').bytes/1000000;
fprintf('Memory used for all data: %.3f MB\n', AllDataMem)
