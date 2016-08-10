function [ WS ] = O_WaterShedCells( im,BW_spots,sIM_small )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

stats=regionprops(BW_spots,'area');
val=median(cat(1,stats.Area));

if val>50
    SeedingOpt='FullNuclei';
else
    SeedingOpt='dots';
end


if nargin==2
    sIM_small=imresize(im,0.5);
    sIM_small=imfill(sIM_small);
elseif isempty(sIM_small)
    sIM_small=imresize(im,0.5);
    sIM_small=imfill(sIM_small);
else
    sIM_small=imresize(im,size(sIM_small));
end

% RESIZE SEEDS
switch SeedingOpt
    case 'dots'
        im_spots=zeros(size(sIM_small));
        SizeConversion=size(sIM_small)./size(im);
        [x,y]=find(BW_spots);
        x=round(x*SizeConversion(1));y=round(y*SizeConversion(2));
        x(x==0)=1;y(y==0)=1;
        I=sub2ind(size(sIM_small),x,y);
        im_spots(I)=1;
    case 'FullNuclei'
        im_spots=imresize(BW_spots,size(sIM_small));
end
im_s=imimposemin(max(sIM_small(:))-sIM_small,im_spots);
WS=watershed(im_s)>0;
WS=imresize(WS,size(im));



