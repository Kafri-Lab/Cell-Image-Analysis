DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170322_TG_Fibroblast_movie_2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_Morphological_Data';
Data.O.Saving_Boundries='Saving_Boundries';
Data.O.SegmentationParameters.OutputDir = '\\carbon.research.sickkids.ca\rkafri\Heather\ResultsTables\'
[ResultTable]=O_SegmentCells_v6(Data);

