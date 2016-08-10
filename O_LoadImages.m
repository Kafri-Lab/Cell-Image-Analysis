function [O]=O_LoadImages(O)
DirName=O.DirName;
FileType=O.FileType;
if strcmpi(O.FileType,'Operetta')
    Ri=O.ImageID.Row;
    Ci=O.ImageID.Column;
    Fi=O.ImageID.Field;
    Ti=O.ImageID.Time;
    if O.LoadingPie
        figure(998)
        clf
    end
    for k=O.ImagedChannels'
        if O.LoadingPie
            figure(998)
            pie(k/max(O.ImagedChannels))
            title('Loading Images','fontsize',14,'color','r')
            drawnow
        end
        ImageName=['r' sprintf('%02d',Ri) 'c' sprintf('%02d',Ci) ...
            'f' sprintf('%02d',Fi) 'p01-ch' num2str(k) 'sk' num2str(Ti) 'fk1fl1.tiff'];
        im=double(imread([DirName '\Images\' ImageName]));
        IM{k}=im;
        WS{k}=[];
        O.BW{k}=[];
        O.BW_spots{k}=[];
    end
    
else 
    Nums=O.ImageID;
    BaseName=O.Image_Retrieval_data.Image_File_Base_Name;
    NumberLengths=O.Image_Retrieval_data.NumberLengths;
    if O.LoadingPie
        figure(998)
        clf
    end
    
    for k=O.ImagedChannels'
        if O.LoadingPie
            figure(998)
            pie(k/max(O.ImagedChannels))
            title('Loading Images','fontsize',14,'color','r')
            drawnow
        end
        Nums.Channal=k;
        [im]=O_Get_Image_File(O.DirName,Nums,NumberLengths,BaseName,FileType);
        IM{k}=im;
        WS{k}=[];
        O.BW_spots{k}=[];
    end
    
end


ImageNormalizarionParameters.Magnification=O.Magnification;
ImageNormalizarionParameters.FlatField_Correction=O.FlatField_Correction;
if O.FlatField_Correction==1
    ImageNormalizarionParameters.flat=O.flat;
end
O.Original_IM=IM;

ImageNormalizarionParameters.flat.Multipicative_Biase=[];
ImageNormalizarionParameters.flat.Additive_Biase=[];
for k=O.ImagedChannels'
    ImageNormalizarionParameters.CWidth_alpha=O.General_Thresholds.CloseW(k);
    ImageNormalizarionParameters.OWidth_alpha=O.General_Thresholds.OpenW(k);
    [BG]=O_NormalizeImages(IM{k},ImageNormalizarionParameters);
    IM{k}=BG.BG;
    
    % ****** USED ONLY IN GUI **********************
    if O.Selected_ch>0 % Selected_ch is the Display_Channal from the GUI
        if O.General_Thresholds.OpenW(O.Selected_ch)>0 && ...
                k==O.Selected_ch
            O.CalcDark2.SmallIM=BG.SmallIM;
            O.CalcDark2.imo=BG.imo;
            O.CalcDark2.a=BG.imresize_alpha;
        end
    end
    % *********************************************
    
end

O.NewImageSelected=false;
O.IM=IM;
O.WS=WS;
O.ImageSize=sqrt(sum((size(IM{1})).^2));



