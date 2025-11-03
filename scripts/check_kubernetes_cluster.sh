#!/bin/bash

# Function to start Kubernetes cluster using Vagrant
start_kubernetes_cluster() {
    echo "Starting Kubernetes cluster using Vagrant..."
    cd /home/bhushan/Desktop/justme_and_kubernetes/vagrant-provisioning/
    vagrant up
    echo "Kubernetes cluster started successfully!"
}

# Run kubectl get no command with a timeout of 5 seconds
kubectl_output=$(timeout 5 kubectl get no 2>&1)

# Check if the output contains the timeout error message
if [[ $kubectl_output == *"i/o timeout"* ]]; then
    start_kubernetes_cluster
elif [[ $kubectl_output == *"couldn't get"* ]]; then
    echo "Unable to fetch Kubernetes nodes. Proceeding to start Kubernetes cluster..."
    start_kubernetes_cluster
else
    echo "No timeout error detected. Exiting..."
fi
