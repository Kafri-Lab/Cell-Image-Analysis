function [T]=Collecting_prctile_data(O,BW,NumberOfCells)
% NOTE THIS IS OPERATES ON CHANNEL 3 (Expected to be STRADa)

Nucleus_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Nucleus')));
Cell_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Cell')));
Total_num_of_cells=max(O.BW{Cell_ch}(:));


% STRADa_ch = 3;
% STRADa_im = O.IM{STRADa_ch};
target_image = O.IM{Cell_ch};
cell_labels = O.BW{Cell_ch};
nuc_labels = O.BW{Nucleus_ch};

cyto_labels = cell_labels;
cyto_labels(nuc_labels>0)=0;

% Whole cell pixel values
cell_stats=regionprops(cell_labels,target_image,'PixelValues');
PixelValues = cell(1, length(cell_stats));
for id=1:max(cell_labels(:))
  PixelValues{id} = cell_stats(id).PixelValues;
end
CellPixelValues = PixelValues';

% Nuc pixel values
nuc_stats=regionprops(nuc_labels,target_image,'PixelValues');
PixelValues = cell(1, length(cell_labels));
for id=1:max(nuc_labels(:))
  PixelValues{id} = nuc_stats(id).PixelValues;
end
NucPixelValues = PixelValues';

% Cyto pixel values
cyto_stats=regionprops(cyto_labels,target_image,'PixelValues');
PixelValues = cell(1, length(cell_labels));
for id=1:max(cyto_labels(:))
  PixelValues{id} = cyto_stats(id).PixelValues;
end
CytoPixelValues = PixelValues';

% Whole cell prctile values
CellPrctileValues = [];
for id=1:max(cell_labels(:))
  CellPrctileValues(id,:) = prctile(CellPixelValues{id},[0 10 20 30 40 50 60 70 80 90 100]);
end

% Nuc prctile values
NucPrctileValues = [];
for id=1:max(cell_labels(:))
  NucPrctileValues(id,:) = prctile(NucPixelValues{id},[0 10 20 30 40 50 60 70 80 90 100]);
end

% Cyto prctile values
CytoPrctileValues = [];
for id=1:max(cell_labels(:))
  CytoPrctileValues(id,:) = prctile(CytoPixelValues{id},[0 10 20 30 40 50 60 70 80 90 100]);
end


T=table(NucPrctileValues,CellPrctileValues,CytoPrctileValues);

