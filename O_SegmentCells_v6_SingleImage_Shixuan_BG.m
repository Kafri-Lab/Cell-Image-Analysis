function [iterTable,ImageID,O]=O_SegmentCells_v6_SingleImage_Shixuan_BG(O,ImageIDs, BG)
% to collect a new property:
% 1) DEFINE: Data.O.Collecting_X_Data='Collecting_Lkb_Data';
% 2) see example Collecting_Lkb_Data.m

% To have the software accept images as input rather than load images add
% the field: O.SegmentationParameters.No_Loading_Images=true. The images
% used will then be O.IM

disp(ImageIDs(1,1:4))


Labeled_channals=find(~strcmp(O.General_Thresholds.Label,'Non'));
Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
Watershed_ch=find(O.General_Thresholds.Watershed);
Seed_ch=find(O.General_Thresholds.Seed);
Number_of_time_points=max(ImageIDs.Time);
OutPutdir=[O.OutputDir O.DataSetName];
if ~exist(OutPutdir,'dir')
    mkdir(OutPutdir);
end

if isempty(Nucleus_ch)
    disp('This version does not work without a defined nuclear channal')
    return
end

% LoadingPie makes a pie chart plot for loding images
O.LoadingPie=false;

%% IMAGE PROCESSING STARTS HERE

O.ImageID=ImageIDs;
% STEP 1: loading 4 images
if ~isfield(O.SegmentationParameters,'No_Loading_Images')
    [O]=O_LoadImages_Shixuan_BG(O, BG);
end

for ch=Labeled_channals'
    % STEP 2: calculate seeds
    im=O.IM{ch};
    thr=O.General_Thresholds.Intensity_thr(ch);
    alpha=O.General_Thresholds.smoothing_alpha(ch);
    eval(['[BW_spots,sIM_small]=' O.Spotting_alg '(alpha,im,thr);'])
    O.BW_spots{ch}=BW_spots;
    
    % STEP 3: thresholding
    O.BW{ch}=O.IM{ch}>O.General_Thresholds.Intensity_thr(ch);
    O.sIM_small{ch}=sIM_small;
end

%% STEP 4: segmenting nucleus
% watershedding
ch=Nucleus_ch;
NucIM=O.IM{ch};
thr=O.General_Thresholds.Intensity_thr(ch);
if isempty(Seed_ch)
    Seeds=O.BW_spots{ch};
else
    Seeds=O.BW_spots{Seed_ch};
end

O.WS{ch}=O_WaterShedCells(NucIM,Seeds,O.sIM_small{ch});
% combining watershed with thresholded im
O.BW{ch}=O.BW{ch} & O.WS{ch};

% REMOVING "CELLS" THAT ARE TOO BIG OR SMALL
Mn=O.General_Thresholds.Min_Area(ch);
Mx=O.General_Thresholds.Max_Area(ch);
O.BW{ch}=bwareafilt(O.BW{ch},[Mn Mx+1]);

% RegionalThresholding
if O.SegmentationParameters.Regional_Thresholding==1
    WS=imreconstruct(O.BW{ch},O.WS{ch});
    WS=bwlabel(WS);
    CC = bwconncomp(WS);
    THR=ones(size(O.BW{ch}))*10*thr;
    for i=1:length(CC.PixelIdxList)
        srt=sort(im(CC.PixelIdxList{i}),'descend');
        LocalThr=median(srt(1:50));
        THR(CC.PixelIdxList{i})=LocalThr;
    end
    O.BW{ch}=im>0.1*THR&WS;
end

% REMOVING "CELLS" THAT ARE TOO BIG OR SMALL
Mn=O.General_Thresholds.Min_Area(ch);
Mx=O.General_Thresholds.Max_Area(ch);
O.BW{ch}=bwareafilt(O.BW{ch},[Mn Mx+1]);

% clean up
O.BW{ch}=imfill(O.BW{ch},'holes');
O.BW{ch}=imclearborder(O.BW{ch});

%% STEP 5: segmenting Cell (optional)
% watershedding
ch=Cell_ch;
if ~isempty(ch)
    Seeds=O.BW{Nucleus_ch};
    O.WS{ch}=O_WaterShedCells(O.IM{ch},Seeds);
    
    % combining watershed with thresholded im
    O.BW{ch}=O.BW{ch} & O.WS{ch};
    
    % clean up
    O.BW{ch}=imfill(O.BW{ch},'holes');
    Mn=O.General_Thresholds.Min_Area(ch);
    Mx=O.General_Thresholds.Max_Area(ch);
    O.BW{ch}=bwareafilt(O.BW{ch},[Mn Mx+1]);
    O.BW{ch}=imclearborder(O.BW{ch});
end


%% STEP 6: making sure nucleii are CONTAINED in cells + labeling
if ~isempty(Cell_ch)
    O.BW{Nucleus_ch}=O.BW{Nucleus_ch} & O.BW{Cell_ch};
    O.BW{Cell_ch}=imreconstruct(O.BW{Nucleus_ch},O.BW{Cell_ch});
    for ch=setdiff(Labeled_channals',[Cell_ch Nucleus_ch])
        O.BW{ch}=O.BW{ch} & O.BW{Cell_ch};
    end
    
    O.BW{Cell_ch}=bwlabel(O.BW{Cell_ch});
    
    for ch=setdiff(Labeled_channals',[Cell_ch])
        O.BW{ch}=double(O.BW{ch}).*O.BW{Cell_ch};
    end
else
    O.BW{Nucleus_ch}=bwlabel(O.BW{Nucleus_ch});
end

%% STEP 7: COLLECTING DATA
NumberOfCells=max(O.BW{Nucleus_ch}(:));
[T]=CollectNucleusData(O,NumberOfCells);
iterTable=T;
if isfield(O.SegmentationParameters,'Edge_Sharpness') && O.SegmentationParameters.Edge_Sharpness==1
    [T]=Collecting_EdgeDef(O,NumberOfCells);
    iterTable=[iterTable T];
end

if ~isempty(Cell_ch)
    [T]=CollectCellData(O,NumberOfCells);
    iterTable=[iterTable T];
end

if isfield(O,'Collecting_X_Data')
    eval(['[T]=' O.Collecting_X_Data '(O,NumberOfCells);'])
    iterTable=[iterTable T];
end



%     figure(1)
%     imshow(showseg_thick(NormalizeImage(O.IM{1}),O.BW{1},[1 0 0]),[])
%     figure(2)
%     imshow(showseg_thick(NormalizeImage(O.IM{3}),O.BW{3},[1 0 0]),[])
% %     [x,y]=find(O.BW_spots);
% %     hold on
% %     plot(y,x,'.c')
% %     hold off
%     disp('l')
%%
ImageID=O.ImageID;
function [T]=CollectNucleusData(O,NumberOfCells)

Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
NucStats=regionprops(O.BW{Nucleus_ch},'Area','Eccentricity','Solidity','Centroid',...
    'MajorAxisLength','MinorAxisLength','Orientation');
Eccentricity=cat(1,NucStats.Eccentricity);
Solidity=cat(1,NucStats.Solidity);
MajorAxisLength=cat(1,NucStats.MajorAxisLength);
MinorAxisLength=cat(1,NucStats.MinorAxisLength);
Orientation=cat(1,NucStats.Orientation);
Centroid=cat(1,NucStats.Centroid);
NArea=cat(1,NucStats.Area);
Ncells=length(NArea);

NInt=zeros(length(NArea),4);
for Channel=1:4
    if ismember(Channel,O.ImagedChannels)
        stats_nuc=regionprops(O.BW{Nucleus_ch},O.IM{Channel},'MeanIntensity');
        NInt(1:Ncells,Channel)=cat(1,stats_nuc.MeanIntensity).*NArea;
    end
end
T=table(Eccentricity,Solidity,MajorAxisLength,MinorAxisLength,Orientation,Centroid,NArea,NInt);

function [T]=Collecting_EdgeDef(O,NumberOfCells)
Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));

ED=zeros(1,NumberOfCells);
edgeim=stdfilt(O.IM{Nucleus_ch});
MaskPerim=imdilate(bwperim(O.BW{Nucleus_ch}),strel('disk',2));
MaskCellInterior=imfill(MaskPerim,'holes');

MaskPerim=MaskPerim.*O.BW{Nucleus_ch};

MaskCellInterior=MaskCellInterior.*O.BW{Nucleus_ch};
MaskCellInterior=bwlabel(MaskCellInterior);
MaskPerim=bwlabel(MaskPerim);

EdgeP1=regionprops(MaskPerim,edgeim,'meanintensity');
EdgeP2=regionprops(MaskCellInterior,edgeim,'meanintensity');
Ed1=cat(1,EdgeP1.MeanIntensity);
Ed2=cat(1,EdgeP2.MeanIntensity);
if size(Ed2,2)>1
    Ed2=Ed2';
end
if size(Ed1,2)>1
    Ed1=Ed1';
end
ED=Ed1./Ed2;
T=table(ED);

function [T]=CollectCellData(O,NumberOfCells)
Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
CellStats=regionprops(O.BW{Cell_ch},'Area');
CArea=cat(1,CellStats.Area);
CInt=zeros(NumberOfCells,4);
for Channel=1:4
    if ismember(Channel,O.ImagedChannels)
        stats_cell=regionprops(O.BW{Cell_ch},O.IM{Channel},'MeanIntensity');
        CInt(1:NumberOfCells,Channel)=cat(1,stats_cell.MeanIntensity).*CArea;
    end
end
T=table(CInt);

function [imn]=NormalizeImage(im,varargin)

IM=im2double(im);
imn=(IM-min(IM(:)))/(max(IM(:))-min(IM(:)));

if ~isempty(varargin)
    imn=(IM-varargin{1}(1))/(varargin{1}(2)-varargin{1}(1)); %%??
end

function [BW]=ThresholdImage(im,thr,seeds,alg)






