DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20160518_Eden_LKB1_dualAb1000RESULTS';
FileName='SegPar_SegmentationParameters_CT';
load([DirName '\' FileName])
%Data.O.General_Thresholds.Intensity_thr(3)=12000;
Data.O.Collecting_X_Data='Collecting_Lkb_Data';
[ResultTable]=O_SegmentCells_v6(Data);

