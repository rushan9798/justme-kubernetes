#!/bin/bash

# Check if the system is powered on
uptime &> /dev/null
if [ $? -eq 0 ]; then
    echo "System is powered on. Starting Kubernetes cluster..."
    # Navigate to the directory containing Vagrantfile
    cd /home/bhushan/Desktop/justme_and_kubernetes/vagrant-provisioning/ || exit
    # Start the Kubernetes cluster using Vagrant
    vagrant up
else
    echo "System is not powered on. Cannot start Kubernetes cluster."
fi
