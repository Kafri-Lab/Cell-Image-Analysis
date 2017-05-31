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

Centroid_=cat(1,stats.Centroid);

cyt = O.Original_IM{1};
saddleOverlayImage = ShapeSaddle;
Mitosis = []; 

for a=1:2
    
    nuc = O.Original_IM{3};
    if a==1
        figTitle = 'Saddle Point Metric';
    else
        figTitle = 'Cell Symmetry Metric';
    end 
    
    for n=1:size(Centroid_,1)
        
        x = round(Centroid_(n,1));
        y = round(Centroid_(n,2));
        
        if a==1
            value = ShapeSaddle(y,x); 
            Mitosis = [Mitosis;str2double(value)];
        else
            value = CellSymmetry(y,x);
        end
        
        value = sprintf('%.2f', value);
        text = text2im(value);
        text = text.*double(max(nuc(:)));
        [sizeY,sizeX] = size(text);
       
        if x+1>=size(nuc,1)
            nuc(y:sizeY+y-1,x-sizeX:x-1)=text;
        else
            nuc(y:sizeY+y-1,x:sizeX+x-1)=text;
        end
        
    end
    
    figure
    imshow(nuc, [])
    title(figTitle);
    hold on
    plot(Centroid_(:,1),Centroid_(:,2),'.r')
end

T = table(Centroid_,Mitosis);

figure
imshow(cyt, [])
hold on
plot(Centroid_(:,1),Centroid_(:,2),'.r')

% figure
% imshow(saddleOverlayImage, [])
% hold on
% plot(Centroid_(:,1),Centroid_(:,2),'.r')
save('Mitosis_Probability.mat', 'T');
pause;
close all;


