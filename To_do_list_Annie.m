clear
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20171031_AH_plate3RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);
