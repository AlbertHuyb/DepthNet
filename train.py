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

data, label = load_data(dataFolder)
data = data.to(device)
label = label.to(device)
# print(data.size(),label.size())

net = depthNet().double().to(device)
net.train()
if os.path.exists(modelFolder):
    net.load_state_dict(torch.load(modelFolder))
    print("load model")
else:
    print("no model!")

# criterion = nn.CrossEntropyLoss()
criterion = nn.MSELoss()

optimizer = optim.SGD(net.parameters(),lr = 0.05,momentum=0.9)
# print(data.type())

iteration = 10
for iter in range(iteration):
    for i in range(data.shape[2]):
        # if label[i] != 2 and label[i] != 12:
        #     continue
        optimizer.zero_grad()
        out = net.forward(data[:,:,i,:,:])
        #     print(out[0].shape,label[i].shape)
        if torch.isnan(out[0]):
            print("NAN emerge!")
            continue
            # exit()
        loss = criterion(out[0],label[i])
        loss.backward()
        optimizer.step()
        #     print(out[0],label[i])
        #     print(i,loss.item())
        if i%100 == 0:
                print(out,label[i])
                print(i,loss.item())

torch.save(net.state_dict(), modelFolder)