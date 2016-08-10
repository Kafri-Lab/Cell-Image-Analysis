function [BW_spots,sIM_small]=O_SpotCells_Daniel_1(alpha,im,thr)
% AvgCellSize=100 for 20X
% if Is_WaterShed==1 then watershed
W=500;
L=size(im,1);
IM_small=imresize(im,W/L);
sIM_small=imfilter(IM_small,fspecial('gaussian',100,1+alpha*W/10));
BW_spots=imregionalmax(sIM_small);
[x,y]=find(BW_spots);


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

drawnow;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
waitfor(gcf,'CurrentCharacter');
curChar=uint8(get(gcf,'CurrentCharacter'))

% Stop process if window is closed
if not(ishandle(tab1)) | not(ishandle(tab2))
    close all;
    error('Quitting because you closed the GUI');
end


% C = imfuse(IM_small,sIM_small,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);

X=round(min(x*L/W,size(im,1)));
Y=round(min(y*L/W,size(im,2)));
I=sub2ind(size(im),X,Y);
Z=zeros(size(im));
Z(I)=1;
BW_spots=Z;
% BW_spots=BW_spots&im>thr;

end


