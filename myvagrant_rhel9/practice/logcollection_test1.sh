#!/bin/bash

# Define the namespace
namespace="default"

# Array containing deployment names and their corresponding number of replicas
declare -A deployments
deployments=(
    ["nfs-client-provisioner"]=2
    # [""]=1
    # [""]=1
    # Add more deployments with their respective replica counts
)

# Get the current date
current_date=$(date +"%Y-%m-%d")

# Loop through each deployment and collect logs
for deployment_name in "${!deployments[@]}"
do
    replicas="${deployments[$deployment_name]}"
    
    for ((i=0; i<$replicas; i++))
    do
        if [ -n "$namespace" ]; then
            log_file="$deployment_name-replica-$i-$current_date.log"
            kubectl logs -n "$namespace" "$(kubectl get pods -n "$namespace" -l app="$deployment_name" -o name | grep "$deployment_name-$i" | cut -d'/' -f 2)" >> "$log_file"
        else
            log_file="$deployment_name-replica-$i-$current_date.log"
            kubectl logs "$(kubectl get pods -l app="$deployment_name" -o name | grep "$deployment_name-$i" | cut -d'/' -f 2)" >> "$log_file"
        fi
        echo "Logs collected for $deployment_name replica $i and saved in $log_file"
    done
done

echo "Logs collected for deployments in namespace $namespace."

