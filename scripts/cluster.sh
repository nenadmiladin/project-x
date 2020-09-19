#!/bin/bash

az group create --name myResourceGroup --location eastus

az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks install-cli

az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

# Delete
#az group delete --name myResourceGroup --yes --no-wait

#Show info
#az aks show --resource-group myResourceGroup --name myAKSCluster
