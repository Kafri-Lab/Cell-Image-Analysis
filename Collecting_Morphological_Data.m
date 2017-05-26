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
stats=regionprops(O.BW{Cell_ch},ShapeSaddleNormalized,'area','MeanIntensity','Centroid');


Area=cat(1,stats.Area);
MeanIntensity=cat(1,stats.MeanIntensity);
Centroid=cat(1,stats.Centroid);
Int=Area.*MeanIntensity;
figure; imshow(D,[])


T=table(Int,Int);
currentImage = O.Original_IM{3};
saddleOverlayImage = ShapeSaddle;

for n=1:size(Centroid,1)
    
   x = round(Centroid(n,1));
   y = round(Centroid(n,2));
    
    Dvalue = ShapeSaddle(y,x)
    %Dvalue = num2str(Dvalue);
    Dvalue = sprintf('%.2f', Dvalue);
    text = text2im(Dvalue);
    text = text.*double(max(currentImage(:)));
    text_sad = text2im(Dvalue).*double(max(ShapeSaddle(:)));
    [sizeY, sizeX] = size(text);
    x
    y
    if x+1>=size(currentImage,1)
        currentImage(y:sizeY+y-1,x-sizeX:x-1)=text;
        saddleOverlayImage(y:sizeY+y-1,x-sizeX:x-1)=text_sad;
    else
        currentImage(y:sizeY+y-1,x:sizeX+x-1)=text;
        saddleOverlayImage(y:sizeY+y-1,x:sizeX+x-1)=text_sad;
    end
end 

figure
imshow(currentImage, [])
figure
imshow(saddleOverlayImage, [])
pause

    

%loop over the centroid values and find the associated pixels
%(ShapeSaddle(x,y]
%create an image using text2im for each associated pixel and overlay it on
%to the original image one at a time I(specify where you want )
