    
    for i=1:min(5,length(I2))
        for Channal=[2 4]
            [im]=O_Get_Image_File(Data.O.DirName,[ResultTable(I2(i),1:3) table(Channal)],[4 1 2 4],'LKB1_p38_63X','FileType2');
            IM{Channal}=im;
            load(['\\carbon.research.sickkids.ca\rkafri\OPRETTA\Operetta Processed OutPutFiles\Dataset_20160208_Eden_LKB1_p38_63XRESULTS\MASKS\Img_' num2str(ResultTable.S(I2(i))) '_' num2str(ResultTable.P(I2(i))) '_' num2str(ResultTable.M(I2(i))) '_1']);
        end
        
        xy=ResultTable.Centroid(I2(i),:);
        figure(1+2*(k-1))
        subplot(3,5,i+10)
        imshow(imcrop(IM{4},[xy(1)-W xy(2)-W 2*W 2*W]),[])
        figure(2+2*(k-1))
        subplot(3,5,i+10)
        BW=imcrop(IM{4},[xy(1)-W xy(2)-W 2*W 2*W])>0.6e4;
        imshow(showseg_thick(NormalizeImage(imcrop(IM{2},[xy(1)-W xy(2)-W 2*W 2*W])),BW,[1 0 0]))

    end
