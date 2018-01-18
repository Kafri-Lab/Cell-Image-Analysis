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
% limit what is segmented
row = [5];
column = [2 7];
field = [19];
min_time = 193;
max_time = 193;
ImageIDs = Data.O.ImageIDs;
rows=ismember(ImageIDs.Row, row) & ismember(ImageIDs.Column, column) & ismember(ImageIDs.Field,field) & ImageIDs.Time <= max_time & ImageIDs.Time >= min_time;
Data.O.ImageIDs = Data.O.ImageIDs(rows,:);

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


% Ceryl for tracking
DirName='\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20170811_CTSL_RPE1_movieRESULTS';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_More_Data= { ...
                                'Collecting_MoreRegionProps', ...
                                % 'Collecting_EdgeDef', ...
                                % 'Saving_Boundries', ...
                                % 'Collecting_Morphological_Data', ...
                                % 'Collecting_Histogram_Data', ...
                                % 'Collecting_prctile_data', ...
};

% limit what is segmented
row = [5];
column = [3];
field = [2];
min_time = 1;
max_time = 247;
ImageIDs = Data.O.ImageIDs;
rows=ismember(ImageIDs.Row, row) & ismember(ImageIDs.Column, column) & ismember(ImageIDs.Field,field) & ImageIDs.Time <= max_time & ImageIDs.Time >= min_time;
Data.O.ImageIDs = Data.O.ImageIDs(rows,:);

[ResultTable]=O_SegmentCells_v6(Data);



% Camilla for tracking
DirName='\\carbon.research.sickkids.ca\rkafri\DanielS\Images\20180112_CG_DPC_ROS__2018-01-12T17_35_12-Measurement1_Field41';
FileName='SegPar_SegmentationParameters';
load([DirName '\' FileName])
Data.O.Collecting_More_Data= { ...
                                'Collecting_MoreRegionProps', ...
                                'Collecting_EdgeDef', ...
                                'Saving_Boundries', ...
                                'Collecting_Morphological_Data', ...
                                'Collecting_Histogram_Data', ...
                                'Collecting_prctile_data', ...
};
% limit what is segmented
row = [5];
column = [7];
field = [41];
min_time = 1;
max_time = 269;
ImageIDs = Data.O.ImageIDs;
rows=ismember(ImageIDs.Row, row) & ismember(ImageIDs.Column, column) & ismember(ImageIDs.Field,field) & ImageIDs.Time <= max_time & ImageIDs.Time >= min_time;
Data.O.ImageIDs = Data.O.ImageIDs(rows,:);

[ResultTable]=O_SegmentCells_v6(Data);
