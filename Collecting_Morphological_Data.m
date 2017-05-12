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

stats=regionprops(O.BW{Cell_ch},ShapeSaddle,'area','MeanIntensity');

Area=cat(1,stats.Area);
MeanIntensity=cat(1,stats.MeanIntensity);
Int=Area.*MeanIntensity;
T=table(Int,Int);

