function [T]=CollectNucleusData(O,NumberOfCells)
  props_per_label = { ...
    % 'Area', ...
    'BoundingBox', ...
    'Centroid', ...
    'Eccentricity', ...
    'Solidity', ...
    'MajorAxisLength', ...
    'MinorAxisLength', ...
    'Orientation', ...
    'EulerNumber', ...
  };

  Cell_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Cell')));
  CellStats=regionprops(O.BW{Cell_ch},props_per_label);

  Nucleus_ch=find(cell2mat(strfind(O.General_Thresholds.Label,'Nucleus')));
  NucStats=regionprops(O.BW{Nucleus_ch},props_per_label);

  NBoundingBox=cat(1,NucStats.BoundingBox);
  NCentroid=cat(1,NucStats.Centroid);
  NEccentricity=cat(1,NucStats.Eccentricity);
  NSolidity=cat(1,NucStats.Solidity);
  NMajorAxisLength=cat(1,NucStats.MajorAxisLength);
  NMinorAxisLength=cat(1,NucStats.MinorAxisLength);
  NOrientation=cat(1,NucStats.Orientation);
  NEulerNumber=cat(1,NucStats.EulerNumber);

  CBoundingBox=cat(1,CellStats.BoundingBox);
  CCentroid=cat(1,CellStats.Centroid);
  CEccentricity=cat(1,CellStats.Eccentricity);
  CSolidity=cat(1,CellStats.Solidity);
  CMajorAxisLength=cat(1,CellStats.MajorAxisLength);
  CMinorAxisLength=cat(1,CellStats.MinorAxisLength);
  COrientation=cat(1,CellStats.Orientation);
  CEulerNumber=cat(1,CellStats.EulerNumber);

  %% Stats for ecah labelled channel (ie. nuc, cyto)
  T=table(NBoundingBox, NCentroid, NEccentricity, NSolidity, NMajorAxisLength, NMinorAxisLength, NOrientation, NEulerNumber, CBoundingBox, CCentroid, CEccentricity, CSolidity, CMajorAxisLength, CMinorAxisLength, COrientation, CEulerNumber);

  %% Calculate stats for each channel
  props_per_channel = { ...
    'MaxIntensity', ...
    'MeanIntensity', ...
    'MinIntensity', ...
    'WeightedCentroid', ...
  };

  for ch_num=1:length(O.ImagedChannels)
    ch_num=O.ImagedChannels(ch_num);
    stats=regionprops(O.BW{Nucleus_ch},O.IM{ch_num},props_per_channel);
    for prop_name=props_per_channel
      col_name = sprintf('Ch%s%s',num2str(ch_num),char(prop_name));
      prop_value = eval(sprintf('cat(1,stats.%s);',char(prop_name)));
      eval(sprintf('T.%s = prop_value;', col_name));
    end
  end
  
  % %% Calculate total intensity for each channel (INCOMPLETE)
  % col_name = sprintf('Ch%sTotalIntensity',Channel);
  % T(:,col_name) = cat(1,stats.MeanIntensity).*NArea;

  % for label=['N','C']
  % for Channel=Data.O.ImagedChannels
  %   stats=regionprops(O.BW{Nucleus_ch},O.IM{Channel},'Area',);
  %   for prop_name=props_per_channel
  %     col_name = sprintf('Ch%s%s',Channel,prop_name);
  %     prop_value = eval(sprintf('cat(1,stats.%s)',prop_name))
  %     T(:,col_name) = prop_value;
  %   end
  % end

end