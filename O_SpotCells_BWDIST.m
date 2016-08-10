function [BW_spots,sIM_small]=O_SpotCells_BWDIST(alpha,im,thr)
% AvgCellSize=100 for 20X
% if Is_WaterShed==1 then watershed
W=500;
L=size(im,1);
IM_small=imresize(im,W/L);
BWD=bwdist(IM_small<thr);
sIM_small=imfilter(BWD,fspecial('gaussian',100,1+alpha*W/10));
if any(isnan(sIM_small(:)))
    BW_spots=zeros(size(sIM_small));
else
    BW_spots=imregionalmax(sIM_small);
end
[x,y]=find(BW_spots);
X=round(min(x*L/W,size(im,1)));
Y=round(min(y*L/W,size(im,2)));
I=sub2ind(size(im),X,Y);
Z=zeros(size(im));
Z(I)=1;
BW_spots=Z;


