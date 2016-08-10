addpath('Z:\OPRETTA\Operetta Processed OutPutFiles\Dataset_20160128_NPSL_drugs_p6RESULTS')
load('SegPar_SegmentationParameters')
Data.O.General_Thresholds
Data.O.Spotting_alg='O_SpotCells_Daniel_1';
Data.O.Spotting_alg='O_SpotCells_Daniel_2';
[CellsTab]=O_SegmentCells_v6(Data);

imshow(im,[])
imshow(IM_small,[])
size(im)
size(IM_small)
imshow(sIM_small,[])
imshow(BW_spots,[])
[x y]
imshow(IM_small,[])
hold on
plot(y,x,'or')
clf
imshow(IM_small,[])
imshow(IM_small,[0 3000])
hold on
plot(y,x,'or')

imshow(im,[0 3000])
imshow(im>1000)
imshow(im>300)
imshow(bwdist(im>300),[])
imshow(bwdist(im<300),[])

imshow(sIM_small, [])
imshow(BW_spots, [])
imshow(sIM_small,[])
hold on
plot(y,x,'or')