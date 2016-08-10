function [Condition,Seeds]=Choose_Seeds(O,ch)

Seed_ch=find(O.General_Thresholds.Seed);
Nucleus_ch=find(strcmp(O.General_Thresholds.Label,'Nucleus'));
Cell_ch=find(strcmp(O.General_Thresholds.Label,'Cell'));
    
if ~isempty(Nucleus_ch) && ...
        ~isempty(Cell_ch) && ...
        ch==Cell_ch && ...
        O.General_Thresholds.Intensity_thr(Nucleus_ch)>0 && ...
        O.General_Thresholds.smoothing_alpha(Nucleus_ch)>0 
    Condition='Use Nucleii as seeds';
    
elseif isempty(Seed_ch)
    Condition='each channal with its own seeds';
    
else
    Condition='One seeds channal for all';
    
end
    

%% implement watershedding
switch Condition
       
    case 'Use Nucleii as seeds'
        Seeds=O.BW{Nucleus_ch};
    case 'each channal with its own seeds'
        if isempty(O.BW_spots{ch})
            Seeds=[];
        else
            Seeds=O.BW_spots{ch};
        end
        
    case 'One seeds channal for all'
        Seeds=O.BW_spots{Seed_ch};
end

        
    

