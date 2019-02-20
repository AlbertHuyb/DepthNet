function psf = eScaleKernelOne(hei, wid, inKernel, blurSZ, throughout);

if blurSZ<0
    inKernel = fliplr(flipud(inKernel));
    blurSZ = abs(blurSZ);
end;    

scaledKernel = zPsfScale(251, 251, 20, inKernel, blurSZ, blurSZ);

[shei, swid] = size(scaledKernel);
psf = zeros(hei, wid);
psf(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, ...
        floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = scaledKernel;
psf = fft2(fftshift(psf));
