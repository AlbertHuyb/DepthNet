import numpy as np
import os
import sys
import torch
from PIL import Image

def load_data(data_url):
    img_data = []
    kernel_size = []
    print("begin list!")
    dir = os.listdir(data_url)
    print("list!")
    for img in dir:
        # print(img)
        temp_data = Image.open(os.path.join(data_url,img))
        # flag = int(img[11:-4])
        # if flag <= 2:
        #     label = 1
        # elif flag <=5:
        #     label = 2
        # elif flag <= 8:
        #     label = 3
        # else:
        #     label = 4
        # kernel_size.append([label])
        kernel_size.append([int(img[11:-4])])
        img_data.append(np.array(temp_data).astype('float'))
        # print(kernel_size)
        # print(img_data)
        # print("load ",img)
        if len(kernel_size) >= 50000:
            print("load data!")
            break
        if len(kernel_size)%10000 == 0:
            print(len(kernel_size))

    data_num = len(kernel_size)
    kernel_size = np.array(kernel_size)
    img_data = np.array(img_data)

    img_data = img_data[np.newaxis,np.newaxis,:]
    img_data = torch.from_numpy(img_data)
    kernel_size = torch.from_numpy(kernel_size-1).double()

    return img_data,kernel_size



