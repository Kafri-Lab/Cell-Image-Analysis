function [T]=Finding_Dividing_Cells_Based_On_Gem_Histone(O,BW,NumberOfCells)

DNAChannal=find(strcmpi(O.General_Thresholds.Name,'mTurquoise'));
GemChannal=find(strcmpi(O.General_Thresholds.Name,'Venus'));

im1=O.IM{1};
ims=imfilter(im1,fspecial('gaussian',100,10));
BWS=imregionalmax(ims)&(O.General_Thresholds.Intensity_thr(1)<O.IM{1});
[x,y]=find(BWS);
% imshow(O.IM{1},[])
% hold on
% plot(y,x,'or')
% hold off

D=squareform(pdist([x y]));
[xx,yy]=find(D>0 & D<50);

xy=[x y];

RelevantPairs=xy(xx,:);
BW_RelevantPairs_Dist=zeros(size(im1));
BW_RelevantPairs_Dist(sub2ind(size(im1), RelevantPairs(:,1), RelevantPairs(:,2)))=1;
% imshow(imdilate(BW_RelevantPairs,strel('disk',3)))


BW_RelevantPairs_Gem=imdilate(O.IM{2}<600 & BWS,strel('disk',10));

BW_RelevantPairs_Size=bwareafilt(O.BW{1}>0,[0 800]);
BW=BW_RelevantPairs_Dist&BW_RelevantPairs_Size&BW_RelevantPairs_Dist;






DividingCells=zeros(max(O.BW{1}(:)),1);


DividingCells(O.BW{1}(BW))=1;

T=table(DividingCells);




