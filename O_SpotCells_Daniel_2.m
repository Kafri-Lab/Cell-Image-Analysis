function [BW_spots,sIM_small]=O_SpotCells_Daniel_2(alpha,im,thr)
% AvgCellSize=100 for 20X
% if Is_WaterShed==1 then watershed
W=500;
L=size(im,1);
IM_small=imresize(im,W/L);
sIM_small=imfilter(bwdist(IM_small<thr),fspecial('gaussian',100,1+alpha*W/10));
BW_spots=imregionalmax(sIM_small);
[x,y]=find(BW_spots);

sIM_thresholded=sIM_small>1;
%sIM_masked= sIM_small sIM_thresholded;
sIM_masked = sIM_thresholded .* sIM_small;
BW_spots_thresh=imregionalmax(sIM_masked);
[x_thresh,y_thresh]=find(BW_spots_thresh);

%dan_gui({IM_small, sIM_small}, 1, 2, y, x)
%drawnow;

%figure('KeyPressFcn',@(obj,evt) 0);
%waitfor(gcf,'CurrentCharacter');
%curChar=uint8(get(gcf,'CurrentCharacter'));
%close all

tab1 = figure(1);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
set(tab1, 'units','normalized','outerposition',[0 0 1 1]);
set(tab1,'DefaultFigureWindowStyle','normal')
set(tab1, 'KeyPressFcn',@(obj,evt) 0);
imshow(IM_small,[]);
hold on;
plot(y,x,'.r');


tab2 = figure(2);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
set(tab2,'DefaultFigureWindowStyle','normal')
set(tab2, 'KeyPressFcn',@(obj,evt) 0);
set(tab2, 'units','normalized','outerposition',[0 0 1 1]);
imshow(sIM_small, []);
hold on;
plot(y,x,'.r');

tab3 = figure(3);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
set(tab3,'DefaultFigureWindowStyle','normal')
set(tab3, 'KeyPressFcn',@(obj,evt) 0);
set(tab3, 'units','normalized','outerposition',[0 0 1 1]);
imshow(sIM_masked, []);
hold on;
plot(y_thresh,x_thresh,'.r');


drawnow;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
waitfor(gcf,'CurrentCharacter');
curChar=uint8(get(gcf,'CurrentCharacter'))

% Stop process if window is closed
if not(ishandle(tab1)) | not(ishandle(tab2))
    close all;
    error('Quitting because you closed the GUI');
end
    
X=round(min(x*L/W,size(im,1)));
Y=round(min(y*L/W,size(im,2)));
I=sub2ind(size(im),X,Y);
Z=zeros(size(im));
Z(I)=1;
BW_spots=Z;


