function [kernel1, kernel2] = eScaleKernel(hei, wid, inKernel1, inKernel2, blurSZ, throughout1, throughout2);
        
if blurSZ<0
    inKernel1 = fliplr(flipud(inKernel1));
    inKernel2 = fliplr(flipud(inKernel2));
    blurSZ = abs(blurSZ);
end;
ratio = 10;
scaledKernel1 = zPsfScale(251, 251, 20, inKernel1, blurSZ, blurSZ);
scaledKernel2 = zPsfScale(251, 251, 20, inKernel2, blurSZ, blurSZ);

[shei, swid] = size(scaledKernel1);
kernel1 = zeros(hei, wid);
kernel1(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = scaledKernel1;
kernel1 = fft2(fftshift(kernel1));

kernel2 = zeros(hei, wid);
kernel2(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = scaledKernel2;
kernel2 = fft2(fftshift(kernel2));
