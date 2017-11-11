
DirName='R:\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170711_HD_CycE_Plate7_Stain_R6C2RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
%Just this time to segment only row 6 column2
Data.O.NumColumns=1;
Data.O.NumRows=1;
Data.O.ImageIDs=Data.O.ImageIDs(Data.O.ImageIDs.Row==6 & Data.O.ImageIDs.Column==2,:);
Data.O.DataSetName='20170711_HD_CycE_Plate7_Stain_R6C2'; %Folder name without "Dataset_" beginning and "RESULTS" end
Data.O.SegmentationParameters.NumRows=1;
Data.O.SegmentationParameters.NumColumns=1;
Data.O.SegmentationParameters.DataSetName='20170711_HD_CycE_Plate7_Stain_R6C2'; %Folder name without "Dataset_" beginning and "RESULTS" end
%End
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);

DirName='R:\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170711_HD_CycE_Plate7_Stain_R5C2_R7C2_R7C3RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
%Just this time to segment only some wells
Data.O.NumColumns=2;
Data.O.NumRows=2;
Data.O.ImageIDs=Data.O.ImageIDs((Data.O.ImageIDs.Row==5 & Data.O.ImageIDs.Column==2) | (Data.O.ImageIDs.Row==7 & Data.O.ImageIDs.Column==2) | (Data.O.ImageIDs.Row==7 & Data.O.ImageIDs.Column==3),:);
Data.O.DataSetName='20170711_HD_CycE_Plate7_Stain_R5C2_R7C2_R7C3'; %Folder name without "Dataset_" beginning and "RESULTS" end
Data.O.SegmentationParameters.NumRows=2;
Data.O.SegmentationParameters.NumColumns=2;
Data.O.SegmentationParameters.DataSetName='20170711_HD_CycE_Plate7_Stain_R5C2_R7C2_R7C3'; %Folder name without "Dataset_" beginning and "RESULTS" end
%End
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);

DirName='R:\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170711_HD_CycE_Plate7_Stain_R7C7_R7C8RESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
%Just this time to segment only some wells
Data.O.NumColumns=2;
Data.O.NumRows=1;
Data.O.ImageIDs=Data.O.ImageIDs((Data.O.ImageIDs.Row==7 & Data.O.ImageIDs.Column==7) | (Data.O.ImageIDs.Row==7 & Data.O.ImageIDs.Column==8),:);
Data.O.DataSetName='20170711_HD_CycE_Plate7_Stain_R7C7_R7C8'; %Folder name without "Dataset_" beginning and "RESULTS" end
Data.O.SegmentationParameters.NumRows=1;
Data.O.SegmentationParameters.NumColumns=2;
Data.O.SegmentationParameters.DataSetName='20170711_HD_CycE_Plate7_Stain_R7C7_R7C8'; %Folder name without "Dataset_" beginning and "RESULTS" end
%End
[ResultTable]=O_SegmentCells_v6_Par_proc(Data);
