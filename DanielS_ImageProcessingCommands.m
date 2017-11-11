% Code blocks are ordered newest to oldest

% Data.O.SegmentationParameters.DataSetName = '20170222_STRADa_SE_Eden_with_prctile_and_PxId';
% Data.O.General_Thresholds.Intensity_thr(1)=160;

% Ron LFS (With Cell Tracker)
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20171103_RB_LFS__2017_11_03T17_30_39RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_prctile_data';
Data.O.Collecting_Y_Data='Collecting_EdgeDef';
Data.O.Collecting_Histogram_Data='Collecting_Histogram_Data';
Data.O.Collecting_MoreRegionProps='Collecting_MoreRegionProps';
Data.O.Saving_Boundries='Saving_Boundries';
Data.O.Collecting_Morphological_Data='Collecting_Morphological_Data';
% Misc
Data.O.General_Thresholds.Intensity_thr(1)=160; % Looser threshold
Data.O.General_Thresholds.Label{1} = 'CellNucleus'; % Use DPC for both Cell and Nuclear channels, cause a nuclear channel is required by Ran's segmentation
[ResultTable]=O_SegmentCells_v6(Data);



% Eden STRADa (with prctile)
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170222_STRADa_SE_EdenRESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_prctile_data';
Data.O.Collecting_Y_Data='Collecting_PerimPixelIdxList'; % now saving boundries
[ResultTable]=O_SegmentCells_v6(Data);




% Heather
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170322_TG_Fibroblast_movie_2RESULTS';
FileName='SegPar_SegmentationParameters2';
load([DirName '\' FileName])
Data.O.Collecting_X_Data='Collecting_Morphological_Data';
[ResultTable]=O_SegmentCells_v6(Data);