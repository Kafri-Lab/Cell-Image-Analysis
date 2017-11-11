
% DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170606_HD_CycDE_Stain_Plate2RESULTS';
% FileName='SegPar_SegmentationParameters';
% load([DirName '\' FileName])
% [ResultTable]=O_SegmentCells_v6_Par_proc(Data);

% Test segmentation with one well
DirName0='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170606_HD_CycDE_Stain_Plate2RESULTS';
load([DirName0 '\ResultTable'])
load([ DirName0 '\SegPar_SegmentationParameters'])

for iter=1:1000
    Show_Selected_Cell(ResultTable,Data)
    pause
end
