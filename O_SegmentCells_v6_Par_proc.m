function [ResultTable]=O_SegmentCells_v6_Par_proc(Data)
 
%% There are several ways to use this program as will be described
% 1. If we do not need to estimate nuclear area
%   A. choose parameters with the O_GUI_6
%   B. save parameters
%   C. load SegPar_XXX
% [CellsTab]=O_SegmentCells_v6_Par_proc(General_Thresholds,SegmentationParameters,ImageIDs);

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
I=find(ImageIDs.Channel==1);
ImageIDs=ImageIDs(I,:);
ImageIDs(:,{'Channel'})=[];
iT=find(strcmpi(ImageIDs.Properties.VariableNames,'time'));
ImageIDs=sortrows(ImageIDs,[iT 1:iT-1]);

NumberOfImages=size(ImageIDs,1);

if ~isdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
    mkdir([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS'])
end

clc
% N = NumberOfImages;
% parfor_progress(N); % Initialize parfor_progress
t1=datetime;
BreakPoints=1:5000:NumberOfImages; 
BreakPoints(end+1)=max(NumberOfImages);
for iB=1:length(BreakPoints)-1
    ResultTable=[];
    tic
    parfor i=BreakPoints(iB):BreakPoints(iB+1)-1
        t2=datetime;
        %     K=parfor_progress;
        [iterTable,ImageID]=O_SegmentCells_v6_SingleImage(Data.O,ImageIDs(i,:),t1,t2);
        if ~isempty(iterTable)
          iterTable=[ImageID(ones(size(iterTable,1),1),:) iterTable];
          ResultTable=[ResultTable ; iterTable];
        end
    end
    toc
    save([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ResultTable_BP' num2str(iB) '.mat'],'ResultTable');
end
% parfor_progress(0); % Clean up parfor_progress

% concatenate all result tables 'ResultTable_BPX.mat'
resultDir = [Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS'];
DirContents=dir(resultDir);
N = ones(length(DirContents),1)*nan;
for i=1:length(DirContents)
    Tkns=regexp(DirContents(i).name,'_BP(\d+)','tokens');
    if ~isempty(Tkns)
        N(i)=str2double(Tkns{1}{1});
    end
end

Tab = [];
for i=1:max(N)
    temp = load([resultDir '\ResultTable_BP' num2str(i) '.mat']);
    Tab = [Tab; temp.ResultTable];
end
ResultTable = Tab;
save([Data.O.SegmentationParameters.OutputDir 'Dataset_' regexprep(Data.O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\ResultTable.mat'],'ResultTable');
 

