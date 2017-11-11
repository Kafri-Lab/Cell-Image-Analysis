DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170518_Jane_RPE1_Rap2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);


DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170518_Jane_Hela_Rap2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);
  