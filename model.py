import torch
import torch.nn as nn
import torch.nn.functional as F 
import torch.nn.init as init

class depthNet(nn.Module):
    def __init__(self):
        super(depthNet,self).__init__()
        self.conv1 = nn.Conv2d(1,3,3) # 13 -> 11
        self.maxpool1 = nn.MaxPool2d(kernel_size=2,stride=2) # 9->5
        self.conv2 = nn.Conv2d(3,13,3) # 5 -> 3
        self.fc1 = nn.Linear(13*3*3,64)
        self.fc2 = nn.Linear(64,1)

    def forward(self,x):
        # print(x.shape)
        x = self.maxpool1(F.relu(self.conv1(x)))
        # print(x.shape)
        x = F.relu(self.conv2(x))
        # print(x.shape)

        x = x.view(-1, 13 * 3 * 3)
        # x = x.view(-1,13*13)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        
        # x = self.maxpool2(x)
        # print(x)
        # x = x/torch.max(x)
        # x = F.softmax(x[:,:,0,0],dim = 1)

        # x = F.softmax(x,dim = 1)
        # exit()

        return x

