function [kernel1, kernel2] = zKernel(type, hei, wid, ratio);

if nargin<4
    ratio = 1;
end;

if type=='r' %random
    kernel1 = rand(hei, wid);
    kernel1(kernel1>0.5)=1;
    kernel1(kernel1<=0.5)=0;
    
    kernel2 = rand(hei, wid);
    kernel2(kernel2>0.5)=1;
    kernel2(kernel2<=0.5)=0;
end;

if type=='z' %zhou
    K = im2double(imread('./kernel/zhou.bmp'));
    K = imresize(K, [hei, wid*2]);
    kernel1 = K(:, 1:end/2); 
    kernel2 = K(:, end/2+1:end);
end;

if type=='c' %circular
    temp = fspecial('disk', floor(hei/2)-1);
    temp = temp/max(temp(:));
    [shei, swid] = size(temp);
    kernel1 = zeros(hei, wid);
    kernel1(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = temp;
    
    temp = fspecial('disk', floor(hei/3));
    temp = temp/max(temp(:));
    [shei, swid] = size(temp);
    kernel2 = zeros(hei, wid);
    kernel2(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = temp;
end;

if all(type =='stereo')
    temp = fspecial('disk', floor(hei/2)-1);
    temp = temp/max(temp(:));
    [shei, swid] = size(temp);
    kernel1 = zeros(hei, wid);
    kernel1(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = temp;
    kernel1(1:end/2, :) = 0;
    kernel2 = flipud(kernel1);
end;
    
if all(type =='twohol')
    kernel1 = zeros(hei, wid);
    temp =fspecial('disk', hei/4);
    temp = temp/max(temp(:));
    [shei, swid] = size(temp);
    kernel1 = zeros(hei, wid);
    kernel1(3:shei+2, 3:swid+2) = temp;
    kernel2 = fliplr(flipud(kernel1));
end;

if all(type == '2slits')
    kernel1 = zeros(hei, wid);
    kernel1(end/2-3:end/2+3, :) = 1;
    kernel2 = kernel1';
end;

kernel1 = imresize(kernel1, ratio);
kernel2 = imresize(kernel2, ratio);