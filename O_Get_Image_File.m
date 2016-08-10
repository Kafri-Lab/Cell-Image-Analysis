function [im]=O_Get_Image_File(DirName,Nums,NumberLengths,BaseName,FileType)

if strcmpi(FileType,'FileType1')
% NameType #1
% example: LKB1_PML_S0003(P4)_C02_M0000_ORG.tif

FileName=[BaseName '_S' sprintf(['%0' num2str(NumberLengths(1)) 'd'],Nums.S) '(P' num2str(Nums.P) ')_C' sprintf(['%0' num2str(NumberLengths(3)) 'd'],Nums.Channal-1) '_M' sprintf(['%0' num2str(NumberLengths(4)) 'd'],Nums.M) '_ORG.tif'];
im=double(imread([DirName '\' FileName]));

elseif strcmpi(FileType,'FileType2')
    % NameType #2
    % example: LKB1_PML_S0003(P4)_C02_M0000_ORG.tif
    
    FileName=[BaseName '_S' sprintf(['%0' num2str(NumberLengths(1)) 'd'],Nums.S) '(TR' num2str(Nums.P) ')_C' sprintf(['%0' num2str(NumberLengths(3)) 'd'],Nums.Channal-1) '_M' sprintf(['%0' num2str(NumberLengths(4)) 'd'],Nums.M) '_ORG.tif'];
    im=double(imread([DirName '\' FileName]));
    
elseif strcmpi(FileType,'Operetta')
    
end



