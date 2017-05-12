DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170424_NC_transientSiHaRESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);

DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170424_NC_transientRPE1RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);