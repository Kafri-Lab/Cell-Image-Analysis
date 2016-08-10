function [im]=showseg_thick(im,mask, color)
% im - image
% bw - a bw (binary) mask of segmentation results
im=imoverlay(im,imdilate(bwperim(mask),strel('disk',1)), color); %[1 0 0]

%im=imoverlay(NormalizeImage(im),imdilate(bwperim(mask),strel('disk',1)),[1 0 0]);
% BW2 = bwperim(BW1) returnsa binary image containing only the perimeter 
% pixels of objects inthe input image BW1.

% im = showseg(imadjust(imProtein_clean), Nuclei);
% im2 = showseg(im, Cells);
% figure(); imshow(im2, [])