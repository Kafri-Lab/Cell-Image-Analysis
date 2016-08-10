function [BG]=O_NormalizeImages(im,ImageNormalizarionParameters)

OKflat=~isempty(ImageNormalizarionParameters.flat.Multipicative_Biase);
OKdark=~isempty(ImageNormalizarionParameters.flat.Additive_Biase);
OK_bg=ImageNormalizarionParameters.OWidth_alpha>0;


if ~OK_bg && ~OKflat && ~OKdark
    BG.BG=im;
elseif OK_bg && ~OKflat && ~OKdark
    [BG]=Background_calc(im,ImageNormalizarionParameters);
end

function [BG]=Background_calc(im,ImageNormalizarionParameters)
W=500;
CWidth_alpha=ImageNormalizarionParameters.CWidth_alpha;
OWidth_alpha=ImageNormalizarionParameters.OWidth_alpha;
L=size(im,1);
a=W/L;
SmallIM=imresize(im,a);
BG.SmallIM=SmallIM;
Owidth=round(0.5*W*OWidth_alpha);
Cwidth=round(10*CWidth_alpha);
Cwidth=max([Cwidth 1]);
imc=imclose(SmallIM,strel('square',Cwidth));
imo=imopen(imc,strel('square',Owidth));
BG.imo=imo;
BG.imresize_alpha=a;
CorrectedImage=SmallIM-imo;
BG.BG=imresize(CorrectedImage,size(im));

    
