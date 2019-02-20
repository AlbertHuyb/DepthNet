function generateData;
% this code is used to generate defocused picture patch data
% written by Yubin Hu

inFolder = './focused-pic';
outFolder = './data';
kernelFolder = '.kernel';

levelOfGT = 20;

inSigma = 0; %Noise level
pattern = 'z';  %Choose the aperture pattern pair

%% Load Aperture Pair
sz = 13; %Can be any number 
K = im2double(imread('./kernel/Levin.bmp'));
compress_ratio = size(K,1)/sz;
kernel = zeros(sz);
for x = 1:sz
    for y = 1:sz
        kernel(x,y) = K(round(compress_ratio*x),round(compress_ratio*y));
    end
end
transmission = sum(kernel(:));
kernel = double(kernel)/transmission;

%% Load Image and Depth map
inDir = dir(inFolder);
inDir = inDir(3:end);
for i = 1:length(inDir)
    inName = inDir(i).name
%     if strcmp(inName,'5.jpg')
%         break
%     end
    inName = ['./',inName];
    pic = im2double(rgb2gray(imread([inFolder, inName])));
    [hei, wid] = size(pic);
    
    block_size = floor([hei,wid]/sz);
    use_pic = pic(1:sz*block_size(1),1:sz*block_size(2));
    hei_range = linspace(1,13,block_size(1));
    hei_range = repmat(hei_range,sz,1);
    hei_range = hei_range(:);
    wid_range = linspace(1,13,block_size(2));
    wid_range = repmat(wid_range,sz,1);
    wid_range = wid_range(:);
    
    [X, Y] = meshgrid(wid_range, hei_range);
    
    %Discretized the blursize map
    blurSizeMap = X;
    blurSizeMap = round(blurSizeMap);
    
    blurpic = Defocus(use_pic, blurSizeMap, kernel, inSigma);
    saveData([sz,sz],blurpic,blurSizeMap,outFolder);
    
%     blurpic = Defocus(use_pic, fliplr(blurSizeMap), kernel, inSigma);
%     saveData([sz,sz],blurpic,fliplr(blurSizeMap),outFolder);
%     
%     blurSizeMap = Y;
%     blurSizeMap = round(blurSizeMap);
%     
%     blurpic = Defocus(use_pic, blurSizeMap, kernel, inSigma);
%     saveData([sz,sz],blurpic,blurSizeMap,outFolder);
%         
%     blurpic = Defocus(pic, flipud(blurSizeMap), kernel, inSigma);
%     saveData([sz,sz],blurpic,flipud(blurSizeMap),outFolder);
    
end
