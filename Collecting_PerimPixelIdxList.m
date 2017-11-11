function [T]=Collecting_PerimPixelIdxList(O,BW,NumberOfCells)

Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));

cell_labels = O.BW{Cell_ch};
nuc_labels = O.BW{Nucleus_ch};

% Whole cell
cell_stats=regionprops(bwperim(cell_labels),'PixelIdxList');
PerimPixelIdxList = cell(1, length(cell_stats));
for id=1:max(cell_labels(:))
  PerimPixelIdxList{id} = cell_stats(id).PixelIdxList;
end
CellPerimPixelIdxList = PerimPixelIdxList';

% Nuc
nuc_stats=regionprops(bwperim(nuc_labels),'PixelIdxList');
PerimPixelIdxList = cell(1, length(cell_stats));
for id=1:max(nuc_labels(:))
  PerimPixelIdxList{id} = nuc_stats(id).PixelIdxList;
end
NucPerimPixelIdxList = PerimPixelIdxList';

T=table(CellPerimPixelIdxList,NucPerimPixelIdxList);

