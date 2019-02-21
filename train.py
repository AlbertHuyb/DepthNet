from util import load_data
from model import depthNet
import torch.optim as optim
import torch.nn as nn
import torch
import os

dataFolder = './data'
modelFolder = './models/model.pt'
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)
batch_size = 4

# data, label = load_data(dataFolder,batch_size)
# data = data.to(device)
# label = label.to(device)
# print(data.size(),label.size())

dataloader = load_data(dataFolder,batch_size,device)

net = depthNet().double().to(device)
net.train()
# if os.path.exists(modelFolder):
#     net.load_state_dict(torch.load(modelFolder))
#     print("load model")
# else:
#     print("no model!")

# criterion = nn.CrossEntropyLoss()
criterion = nn.L1Loss(reduction='sum')
optimizer = optim.SGD(net.parameters(),lr = 0.001,momentum=0.9)
# print(data.type())

iteration = 10
for iter in range(iteration):
    for step, (batch_data,batch_label) in enumerate(dataloader):
        # if label[i] != 2 and label[i] != 12:
        #     continue
        optimizer.zero_grad()
        out = net.forward(batch_data)
        #     print(out[0].shape,label[i].shape)
        if torch.any(torch.isnan(out)):
            print("NAN emerge!")
            print(torch.isnan(out))
            print(out)
            # continue
            exit()
        # print(out,batch_label)
        loss = criterion(out,batch_label)
        loss.backward()
        optimizer.step()
        #     print(out[0],label[i])
        #     print(i,loss.item())
        # print(out,batch_label)
        # print(step,loss.item())
        if step%100 == 0:
            print(out,batch_label)
            print(step,loss.item())
            # exit()

torch.save(net.state_dict(), modelFolder)