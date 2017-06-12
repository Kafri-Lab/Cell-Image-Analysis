function [T]=Saving_Boundaries(O,NumberOfCells)
    Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
    Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
    labelled_nuc = O.BW{Nucleus_ch};
    labelled_cyto = O.BW{Cell_ch};

    cyto_boundaries = {};
    cyto_boundaries = {};
    for cell_index = 1:max(labelled_nuc(:))
        nuc_boundaries{cell_index} = find(bwperim(labelled_nuc==cell_index));
    end
    for cell_index = 1:max(labelled_cyto(:))
        cyto_boundaries{cell_index} = find(bwperim(labelled_cyto==cell_index));
    end

    T = table();
    T.nuc_boundaries = nuc_boundaries';
    T.cyto_boundaries = cyto_boundaries';
end