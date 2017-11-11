function [T]=Collecting_Lkb_Data(O,BW,NumberOfCells)
if ~isdir([O.SegmentationParameters.OutputDir 'Dataset_' regexprep(O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\Images'])
   mkdir([O.SegmentationParameters.OutputDir 'Dataset_' regexprep(O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\Images']) 
   mkdir([O.SegmentationParameters.OutputDir 'Dataset_' regexprep(O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\MASKS'])
end
    
%% preparing data
Nucleus_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Nucleus')));
Cell_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Cell')));
Lkb_ch=find(strcmpi(O.General_Thresholds.Name,'LKB1'));
Lkb_thr=O.General_Thresholds.Intensity_thr(Lkb_ch);
Total_num_of_cells=max(O.BW{Cell_ch}(:));

%% test for focus
OutSideRing=imdilate(O.BW{Nucleus_ch},strel('square',10))&~O.BW{Nucleus_ch};
IndiseRing=O.BW{Nucleus_ch}&~imerode(O.BW{Nucleus_ch},strel('square',10));
IndiseRing=bwareaopen(IndiseRing,5e2);
IndiseRing=double(IndiseRing).*O.BW{Cell_ch};
FocusScore1=mean(O.IM{Nucleus_ch}(IndiseRing>0))-mean(O.IM{Nucleus_ch}(OutSideRing>0));
stats1=regionprops(O.BW{Nucleus_ch},O.IM{Nucleus_ch},'MeanIntensity');
[xx,yy]=gradient(O.IM{Nucleus_ch});
imGrad=sqrt(xx.^2+yy.^2);
stats2=regionprops(IndiseRing,imGrad,'MeanIntensity');
MeanIntensity2=ones(Total_num_of_cells,1);
MeanIntensity2(1:length(stats2))=cat(1,stats2.MeanIntensity);
MeanDNAInt=cat(1,stats1.MeanIntensity);
if isempty(MeanIntensity2)
    FocusScore2=[];
    FocusScore1=[];
else
    FocusScore2=cat(1,stats1.MeanIntensity)./MeanIntensity2;
    FocusScore1=FocusScore1(ones(size(FocusScore2)));
end

%% Lkb int in cytoplasm
CytBW=O.BW{Cell_ch}&~imerode(O.BW{Nucleus_ch},strel('square',5));
CytBW=double(CytBW).*O.BW{Cell_ch};
stats=regionprops(CytBW,O.IM{Lkb_ch},'Area','MeanIntensity');
LKB_Int_Cyt=cat(1,stats.Area).*cat(1,stats.MeanIntensity);
LKB_MeanInt_Cyt=cat(1,stats.MeanIntensity);

%% size of LKB cytoplasmic regions
Lkb_thr=14000;
bw1=O.IM{2}>Lkb_thr&~imerode(O.BW{Nucleus_ch},strel('square',5));
bw1=bw1&~imerode(O.BW{Nucleus_ch},strel('square',5));
HATS=bwareaopen(bw1,50);
HATS=HATS.*O.BW{Cell_ch};

% subplot(1,2,2)
% kaka=imshowpair(HATS>0,imdilate(DOTS>0,strel('disk',2)),'colorchannels','red-cyan');
% imk=kaka.CData;
% imk2=imoverlay(imk,imdilate(bwperim(O.BW{Nucleus_ch}),strel('disk',2)),[0 1 0 ]);
% imk3=imoverlay(imk2,imdilate(bwperim(O.BW{Cell_ch}),strel('disk',2)),[0 0 1]);
% imshow(imk3)


stats=regionprops(HATS,O.IM{2},'Area','meanintensity');
vals=zeros(Total_num_of_cells,1);
v=cat(1,stats.Area);
vals(1:length(v))=v;
LKB_HATSize=vals;

vals=zeros(Total_num_of_cells,1);
v=cat(1,stats.MeanIntensity);
vals(1:length(v))=v;
LKB_HATBrightness=vals;

Centroids=regionprops(O.BW{Nucleus_ch},'centroid');
Centroids=cat(1,Centroids.Centroid);
HAT_Polarity=zeros(Total_num_of_cells,1);
for i=1:size(Centroids,1)
    [x,y]=find(HATS==i);x=x-Centroids(i,2);y=y-Centroids(i,1);
    [THETA,RHO] = cart2pol(x,y);
    N=hist(THETA,-pi:0.1:pi);
    HAT_Polarity(i)=length(find(N>0))/length(N);
end


%% Lkb int in nucleus
Nuc=O.BW{Cell_ch}&~CytBW;
Nuc=double(Nuc).*O.BW{Cell_ch};
stats=regionprops(Nuc,O.IM{Lkb_ch},'Area','MeanIntensity');
vals=cat(1,stats.Area).*cat(1,stats.MeanIntensity);
LKB_Int_Nuc=zeros(Total_num_of_cells,1);
LKB_Int_Nuc(1:length(vals))=vals;

vals=cat(1,stats.MeanIntensity);
LKB_Int_MeanNuc=zeros(Total_num_of_cells,1);
LKB_Int_MeanNuc(1:length(vals))=vals;


%% counting focci alg 1

imo=stdfilt(O.IM{2},ones(9));
DOTS=imo>6000;
DOTS=O.BW{Nucleus_ch}.*DOTS;
stats=regionprops(DOTS,'EulerNumber');
vals=zeros(Total_num_of_cells,1);
v=cat(1,stats.EulerNumber);
vals(1:length(v))=v;
LKB_num_Focci_1=vals;








figure(1)
clf
subplot(1,2,1)
imshowpair(O.IM{Nucleus_ch},O.IM{Lkb_ch},'falsecolor','colorchannels','red-cyan')
hold on
for i=1:size(Centroids,1)
    text(Centroids(i,1)+100,Centroids(i,2)+100,num2str(round([LKB_Int_Cyt(i) ; LKB_Int_Nuc(i)]/1e6)),'color','y','fontsize',6,'fontweight','bold')
end
title([num2str(round(mean(FocusScore1))) ' \ ' num2str(round(mean(FocusScore2)))])


hold off
subplot(1,2,2)
kaka=imshowpair(HATS>0,imdilate(DOTS>0,strel('disk',2)),'colorchannels','red-cyan');
imk=kaka.CData;
imk2=imoverlay(imk,imdilate(bwperim(O.BW{Nucleus_ch}),strel('disk',2)),[0 1 0 ]);
imk3=imoverlay(imk2,imdilate(bwperim(O.BW{Cell_ch}),strel('disk',2)),[0 0 1]);
imshow(imk3)
hold on
for i=1:Total_num_of_cells
    text(Centroids(i,1)+100,Centroids(i,2)+100,num2str(round(100*HAT_Polarity(i))),'color','y','fontsize',8,'fontweight','bold')
end
hold off


drawnow
saveas(gcf,[O.SegmentationParameters.OutputDir 'Dataset_' regexprep(O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\Images\Img_' regexprep(num2str(O.ImageID{1,:}),'\s*','_') '.png'])
BW=O.BW{Nucleus_ch};
save([O.SegmentationParameters.OutputDir 'Dataset_' regexprep(O.SegmentationParameters.DataSetName,'\W','_')  'RESULTS\MASKS\Img_' regexprep(num2str(O.ImageID{1,:}),'\s*','_') ],'BW')



T=table(HAT_Polarity,LKB_HATBrightness,LKB_HATSize,MeanDNAInt,FocusScore1,FocusScore2,LKB_Int_Cyt,LKB_Int_MeanNuc,LKB_MeanInt_Cyt,LKB_Int_Nuc,...
    LKB_num_Focci_1);

