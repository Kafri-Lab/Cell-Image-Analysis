function [T]=Collecting_Morphological_Data(O,BW,NumberOfCells)

Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
Total_num_of_cells=max(O.BW{Cell_ch}(:));

[fx,fy]=gradient(imgaussfilt(O.IM{Cell_ch},2));
[fxx,fxy]=gradient(fx);
[fyx,fyy]=gradient(fy);
D=fyy.*fxx-fxy.*fyx;

CellSymmetry=imgaussfilt(fxx-fyy,10);
ShapeSaddle=imgaussfilt(D,10);
ShapeSaddleNormalized = normalize0to1(ShapeSaddle);
stats=regionprops(O.BW{Nucleus_ch},ShapeSaddleNormalized,'area','MeanIntensity','Centroid');

Centroid=cat(1,stats.Centroid);

%T=table(Centroid,);
nuc = O.Original_IM{3};
cyt = O.Original_IM{1};
saddleOverlayImage = ShapeSaddle;
Dcolumn = [];

for n=1:size(Centroid,1)
    
    x = round(Centroid(n,1));
    y = round(Centroid(n,2));
    
    Dvalue = ShapeSaddle(y,x);
    Dcolumn = [Dcolumn;round(Dvalue,2)];
    Dvalue = sprintf('%.2f ', Dvalue);
    text = text2im(Dvalue);
    text = text.*double(max(nuc(:)));
    [sizeY, sizeX] = size(text);
    
    if x+1>=size(nuc,1)
        nuc(y:sizeY+y-1,x-sizeX:x-1)=text;
    else
        nuc(y:sizeY+y-1,x:sizeX+x-1)=text;
    end
    
end 



Mitosis = table(Centroid,Dcolumn);
Mitosis
figure
imshow(nuc, [])
hold on
plot(Centroid(:,1),Centroid(:,2),'.r')
figure
imshow(cyt, [])
hold on
plot(Centroid(:,1),Centroid(:,2),'.r')
figure
imshow(saddleOverlayImage, [])
hold on
plot(Centroid(:,1),Centroid(:,2),'.r')
pause;
close all;

