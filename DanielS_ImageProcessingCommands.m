DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170322_TG_Fibroblast_movie_2RESULTS';
FileName='SegPar_SegmentationParameters2';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_Morphological_Data';
[ResultTable]=O_SegmentCells_v6(Data);


% Eden STRADa (with prctile)
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170222_STRADa_SE_EdenRESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_prctile_data';
Data.O.Collecting_Y_Data='Collecting_PerimPixelIdxList';
Data.O.SegmentationParameters.DataSetName = '20170222_STRADa_SE_Eden_with_prctile_and_PxId';
[ResultTable]=O_SegmentCells_v6(Data);
