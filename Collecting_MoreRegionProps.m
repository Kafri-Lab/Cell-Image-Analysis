function [T]=CollectNucleusData(O,NumberOfCells)
  T = table();

  % Known segmentable regions
  known_labels = { ...
    'Nucleus', ...
    'Cell', ...
  };

  % Calculate shape stats for each labelled region
  stats_per_label = { ...
    'Area', ...
    'BoundingBox', ...
    'Centroid', ...
    'Eccentricity', ...
    'Solidity', ...
    'MajorAxisLength', ...
    'MinorAxisLength', ...
    'Orientation', ...
  };

  % Calculate intensity stats for each channel
  stats_per_channel = { ...
    'MaxIntensity', ...
    'MeanIntensity', ...
    'MinIntensity', ...
    'WeightedCentroid', ...
  };

  % Create a a map of ch_name --> channel_number for each known label
  channels = containers.Map();
  for i=1:length(known_labels)
    ch_name = known_labels{i};
    channels(ch_name)=find(cell2mat(strfind(O.General_Thresholds.Label,ch_name)));
  end

  % Loop over known channels
  for k = channels.keys()
    ch_name = k{1};
    ch_abrv = ch_name(1); % N or C
    ch_num = channels(ch_name);
    if isempty(ch_num)
      continue  % skip if the channel is not assigned
    end

    Stats=regionprops(O.BW{ch_num},stats_per_label);
    
    if isempty(Stats)
      T=table()  % if there are no cells to measure back off quickly
      break
    end


    % Calculate shape stats
    T{:,[ch_abrv '_Area']}=cat(1,Stats.Area);
    T{:,[ch_abrv '_BoundingBox']}=cat(1,Stats.BoundingBox);
    T{:,[ch_abrv '_Centroid']}=cat(1,Stats.Centroid);
    T{:,[ch_abrv '_Eccentricity']}=cat(1,Stats.Eccentricity);
    T{:,[ch_abrv '_Solidity']}=cat(1,Stats.Solidity);
    T{:,[ch_abrv '_MajorAxisLength']}=cat(1,Stats.MajorAxisLength);
    T{:,[ch_abrv '_MinorAxisLength']}=cat(1,Stats.MinorAxisLength);
    T{:,[ch_abrv '_Orientation']}=cat(1,Stats.Orientation);

    % Calculate total intensity for each channel
    for idx=1:length(O.ImagedChannels)
      idx=O.ImagedChannels(idx);
      stats=regionprops(O.BW{ch_num},O.IM{idx},{'Area', 'MeanIntensity',});
      col_name = [ch_abrv '_Ch' num2str(idx) '_TotalIntensity'];
      T{:,col_name}=cat(1,stats.MeanIntensity).*cat(1,stats.Area);
    end

    % Calculate intensity stats for each channel
    for idx=1:length(O.ImagedChannels)
      idx=O.ImagedChannels(idx);
      stats=regionprops(O.BW{ch_num},O.IM{idx},stats_per_channel);
      for stat_name=stats_per_channel
        col_name = [ch_abrv '_Ch' num2str(idx) '_'  char(stat_name)];  % eg. N_Ch1_Centroid
        stat_value = eval(sprintf('cat(1,stats.%s);',char(stat_name)));
        T{:,col_name}=stat_value;
      end
    end

    % Calculate gradient (std dev) for each channel (total and mean)
    for idx=1:length(O.ImagedChannels)
      idx=O.ImagedChannels(idx);
      gradient_im = imgradient(O.IM{idx});
      stats=regionprops(O.BW{ch_num},gradient_im,{'Area', 'MeanIntensity',});
      col_name = [ch_abrv '_Ch' num2str(idx) '_GradientMeanIntensity'];
      T{:,col_name}=cat(1,stats.MeanIntensity);
      col_name = [ch_abrv '_Ch' num2str(idx) '_GradientTotalIntensity'];
      T{:,col_name}=cat(1,stats.MeanIntensity).*cat(1,stats.Area);
    end

  end

end