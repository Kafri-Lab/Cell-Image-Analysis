cd('\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Image Processing\User Interface\lib\NewVersion')
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170322_TG_Fibroblast_movie_2RESULTS';
FileName='SegPar_SegmentationParameters2';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_Morphological_Data';
[ResultTable]=O_SegmentCells_v6(Data);

