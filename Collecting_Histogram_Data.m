function [T]=Collecting_Histogram_Data(O,NumberOfCells)
    Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
    Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
    nuc = O.IM{Nucleus_ch};
    labelled_nuc = O.BW{Nucleus_ch};

    % Display seed overlay
%     figure
%     imshow(nuc, [])
%     hold on
%     plot(Centroid(:,1),Centroid(:,2),'.r')

    % Display labelled image
%     figure
    %imshow(labelled_nuc, [])

    % TODO (Lior)
    % initialize nuc_histograms as a array data type
    % Loop over each nucleus (from 1 to max value in BW image)
    %   Get the original image intensity values for one nucleus
    %   Compute histogram(nuc_values(:))
    %   Store historgram result in nuc_histograms array

    nuc_histograms = [];
    [maxVal] = max(labelled_nuc(:));
    for cell_index = 1:maxVal
        nuc_values = nuc(find(labelled_nuc==cell_index));
        new_histogram = hist(nuc_values, 10);
        nuc_histograms = [nuc_histograms; new_histogram];
    end
    
    T = table(nuc_histograms); % return histogram values
end