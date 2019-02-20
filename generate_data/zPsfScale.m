function outPSF = zPsfScale(aHei, aWid, ratio, inPSF, hei, wid);

%== This function is more important than what most people will expect!
%==upsample the PSF, resize, and then downsample


outPSF = zeros(aHei*ratio, aWid*ratio);

flow = sum(inPSF(:));
temp = eImresize(inPSF, [hei, wid]*ratio);% 251*251 -> 7*7

[shei, swid] = size(temp);
outPSF(floor(end/2-shei/2)+1:floor(end/2-shei/2)+shei, floor(end/2-swid/2)+1:floor(end/2-swid/2)+swid) = temp;
outPSF = eImresize(outPSF, [aHei, aWid]);
outPSF = outPSF*(flow/sum(outPSF(:))); % น้าปปฏ