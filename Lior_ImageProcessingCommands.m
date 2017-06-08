DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170322_TG_Fibroblast_movie_2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_Histogram_Data='Collecting_Histogram_Data';
Data.O.Collecting_X_Data='Collecting_Morphological_Data';
Data.O.SegmentationParameters.OutputDir = '\\carbon.research.sickkids.ca\rkafri\Lior\ResultsTables\'
[ResultTable]=O_SegmentCells_v6(Data);

filename='\\carbon.research.sickkids.ca\rkafri\Lior\DONE';
if ~exist(filename, 'file' )
    fid = fopen(filename,'w');
    fclose(fid);
end



