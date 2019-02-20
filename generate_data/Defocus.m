function outDefocusedImage = Defocus(inFocusedImage, inBlurMap, inKernel, inSigma);

%Input: focused image, depth map in the format of blursize, blur kernel, noise level
%Output: a rendered defocused image

inKernelSize = size(inKernel, 1);
throughout = sum(inKernel(:));
backup = inFocusedImage;
inFocusedImage = fft2(inFocusedImage);
%====
[hei, wid] = size(inFocusedImage);
outDefocusedImage = zeros(hei, wid);

count = 0;
while(1)
    blurSZ = max(inBlurMap(:));
    select = inBlurMap==blurSZ;

    if blurSZ==-999
        break;
    end;  
    if blurSZ ==0
        outDefocusedImage(select) = backup(select)*throughout;
        inBlurMap(select) = -999;
        continue;
    end;
    inBlurMap(select) = -999;
    
    psf = eScaleKernelOne(hei, wid, inKernel, blurSZ, throughout);
        
    temp = abs(ifft2(inFocusedImage.*psf));    
    outDefocusedImage(select) = temp(select); % �������е����ݶ������kernel��������ǲ�ͬλ��ȡ��Ӧ��ֵ
    
    count = count +1;

end;
outDefocusedImage = outDefocusedImage + randn(hei, wid)*inSigma;

