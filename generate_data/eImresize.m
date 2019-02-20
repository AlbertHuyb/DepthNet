function imout = eImresize(im, sz);

%Elementary function to resize the aperture
%
sz = round(sz);
if abs(sz(1))<1|abs(sz(2))<1
    sz = [1, 1];
end;
SS = sum(im(:));

[hei, wid] = size(im);
 
imtemp = zeros(sz(1), wid);
step = hei/sz(1);
for ii = 1:sz(1);
    for pos = ceil((ii-1)*step) : floor(ii*step)-1; %1对n的n个
        imtemp(ii, :) = imtemp(ii, :)+im(pos+1, :);
    end;
    
    if ceil((ii-1)*step)==ceil(ii*step)
        a = ceil((ii-1)*step)-1; %前一个
        imtemp(ii, :) = imtemp(ii, :)+im(a+1, :)*step; %再加上一些前一个的分量
        continue;
    end;
    
    a = floor(ii*step);
    if a<hei
        imtemp(ii, :) = imtemp(ii, :)+im(a+1, :)*(ii*step-a);
    end;
    
    a = ceil((ii-1)*step)-1;
    if a>=0
        imtemp(ii, :) = imtemp(ii, :)+im(a+1 , :)*(ceil((ii-1)*step) - (ii-1)*step);
    end;
end;

imout = zeros(floor(sz));
step = wid/sz(2);
for ii = 1:sz(2);
    for pos = ceil((ii-1)*step) : floor(ii*step)-1;
        imout(:, ii) = imout(:, ii)+imtemp(:, pos+1);
    end;
    
    if ceil((ii-1)*step)==ceil(ii*step)
        a = ceil((ii-1)*step)-1;
        imout(:, ii) = imout(:, ii)+imtemp(:, a+1)*step; 
        continue;
    end;
    
    a = floor(ii*step);
    if a<wid
        imout(:, ii) = imout(:, ii)+imtemp(:, a+1)*(ii*step-a);
    end;
    a = ceil((ii-1)*step)-1;
    if a>=0
        imout(:, ii) = imout(:, ii)+imtemp(:, a+1)*(ceil((ii-1)*step) - (ii-1)*step);
    end;
end;

imout = imout*(sz(1)*sz(2)/hei/wid);