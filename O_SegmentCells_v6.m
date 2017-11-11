function [ResultTable]=O_SegmentCells_v6(Data)
 
%% There are several ways to use this program as will be described
% 1. If we do not need to estimate nuclear area
%   A. choose parameters with the O_GUI_6
%   B. save parameters
%   C. load SegPar_XXX
% [CellsTab]=O_SegmentCells_v6_Par_proc(Data);

% 2.If we DO need to estimate nuclear area (this performs MUCH slower)
%   A. choose parameters with the O_GUI_6
%   B. save parameters
%   C. Copy the following into Matlab
% copy the directory where segmentation parameters been saved
% impath = '\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20150625_CT_Histone_FixedRESULTS\';
% load([impath 'SegPar_SegmentationParameters.mat'])

% Data.O.SegmentationParameters.Regional_Thresholding=1; % ACTIVATES REGIONAL SHAREHOLDING (IDENTIFIES NUCLEAR AREA)
% Data.O.SegmentationParameters.Edge_Sharpness=1; % optional (identifies mitotics)
% Data.O.SegmentationParameters.Save_Masks=0; % optional (do not saves all segmented images; =1, save all mask images)
% [CellsTab]=O_SegmentCells_v6_Par_proc(Data);

%% Important Notes: 
% When segmenting through option "2" - calculation of nuclear area - it is obligatory to use the background subtraction option.

%% Selecting to segment only part of the data: (example)
% the example below shows how to segment only results from Row 7
% I=find(Data.O.ImageIDs.Row==7);
% Data.O.ImageIDs=Data.O.ImageIDs(I,:);

%% to collect a new property:
% 1) DEFINE: Data.O.Collecting_X_Data='Collecting_Lkb_Data';
% 2) see example Collecting_Lkb_Data.m

%% To have the software accept images as input rather than load images add
% the field: O.SegmentationParameters.No_Loading_Images=true. The images
% used will then be O.IM

ImageIDs=Data.O.ImageIDs;

%% NOTE(DanielS): Optionally limit what is segmented
% row = [5];
% column = [2 7];
% field = [19 20];
% min_time = -Inf;
% max_time = Inf;
% ImageIDs = Data.O.ImageIDs;
% rows=ismember(ImageIDs.Row, row) & ismember(ImageIDs.Column, column) & ismember(ImageIDs.Field,field) & ImageIDs.Time <= max_time & ImageIDs.Time >= min_time;
% ImageIDs = Data.O.ImageIDs(rows,:);

I=find(ImageIDs.Channel==1);
ImageIDs=ImageIDs(I,:);
ImageIDs(:,{'Channel'})=[];
iT=find(strcmpi(ImageIDs.Properties.VariableNames,'time'));
ImageIDs=sortrows(ImageIDs,[iT 1:iT-1]);

ResultTable=[];

if ~isdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
    mkdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
end
if ~isdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ExampleImages'])
    mkdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ExampleImages'])
end


clc

NumberOfImages=size(ImageIDs,1)
% N = NumberOfImages;
% parfor_progress(N); % Initialize parfor_progress
t1=datetime;
%for i=1 % only run once FOR TESTING ONLY
for i=1:NumberOfImages
    t2=datetime;
    fprintf('Processing image %d of %d.\n',i,NumberOfImages);
%     K=parfor_progress;
    [iterTable,ImageID,O]=O_SegmentCells_v6_SingleImage(Data.O,ImageIDs(i,:),t1,t2);
    %iterTable = segmentation results for one image
    %ImageID = one line of ImageIDs describing the current image
    iterTable=[ImageID(ones(size(iterTable,1),1),:) iterTable];
    ResultTable=[ResultTable ; iterTable];
    if mod(i,10)==0
        for k=1:size(O.General_Thresholds,1)
            if any(O.BW{k}(:))
                figure(1);imshow(showseg_thick(mat2gray(O.IM{k}),O.BW{k},[1 0 0])) %Edited by Miriam 4/7/17
               print([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ExampleImages\Image_c' num2str(k) '_Ind_' num2str(i)],'-dpng')
            end
        end
    end
end
% parfor_progress(0); % Clean up parfor_progress



save_path = [Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ResultTable.mat']
save(save_path,'ResultTable');


