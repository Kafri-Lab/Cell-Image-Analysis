DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20160519_NC_TetOne_test1_Ab_plate2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);

