DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20171005_CG_PS6_PH2AXRESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
%Data.O.Collecting_X_Data='Collecting_Lkb_Data';
[ResultTable]=O_SegmentCells_v6(Data);

