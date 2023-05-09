function SequentialProcessingV4
t1 = toc;
t2 = t1;
for idx = 1: size(Data2Process,1) % step through each data location to process the data

    [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);

    % Monitoring after every 50 data processed 
    if idx/50 == ceil( idx/50)
        tt = toc-t2;
        fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
            idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
        t2 = toc;
    end
end
T2(NumHour) = toc - t1; % record the total processing time for this hour
fprintf('Processing hour %i - %.2f s\n\n', NumHour, sum(T2));
    
tSeq = toc;

fprintf('Total time for sequential processing = %.2f s\n\n', tSeq)

end