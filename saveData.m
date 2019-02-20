function [  ] = saveData( patch_size,blurpic,depthMap,outFolder )
%SAVEDATA 此处显示有关此函数的摘要
%   此处显示详细说明
block_size = zeros(1,2);
block_size(1) = size(blurpic,1)/patch_size(1);
block_size(2) = size(blurpic,2)/patch_size(2);
for x = 1:block_size(1)
    for y = 1:block_size(2)
        kernel_size = depthMap(patch_size(1)*x,patch_size(2)*y);
        save_patch = blurpic(patch_size(1)*(x-1)+1:patch_size(1)*x,patch_size(2)*(y-1)+1:patch_size(2)*y);
        
        random_key = num2str(floor(rand(1,10)*10));
        random_key(find(isspace(random_key))) = [];
        imwrite(save_patch,[outFolder,'/',random_key,'_',num2str(kernel_size),'.bmp']);
    end
end

end

