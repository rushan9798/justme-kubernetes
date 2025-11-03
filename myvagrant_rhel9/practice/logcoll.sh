#!/bin/bash

# Set the namespace where your deployments are running
NAMESPACE="default"

# Create a directory to store the log files
LOG_DIR="/tmp/deployment_logs"
mkdir -p $LOG_DIR

# Get a list of deployments in the specified namespace
DEPLOYMENTS=$(kubectl get deployments -n $NAMESPACE -o=name)

# Loop through each deployment and collect its logs
for DEPLOYMENT in $DEPLOYMENTS; do
  # Extract the deployment name from the full deployment path
  DEPLOYMENT_NAME=$(basename $DEPLOYMENT)

  # Get the number of replicas for the deployment
  REPLICAS=$(kubectl get deployment -n $NAMESPACE $DEPLOYMENT_NAME -o=jsonpath='{.spec.replicas}')

  # Create a directory for each deployment's logs
  DEPLOYMENT_LOG_DIR="$LOG_DIR/$DEPLOYMENT_NAME"
  mkdir -p "$DEPLOYMENT_LOG_DIR"

  # Loop through the pods associated with the deployment and collect logs
  PODS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o=name)
  for POD in $PODS; do
    # Extract the pod name from the full pod path
    POD_NAME=$(basename $POD)

    # Use kubectl logs to fetch the logs and save them to a file
    kubectl logs -n $NAMESPACE $POD_NAME > "$DEPLOYMENT_LOG_DIR/$POD_NAME.log"

    echo "Collected logs for $POD_NAME (Deployment: $DEPLOYMENT_NAME, Replicas: $REPLICAS)"
  done
done

echo "Log collection complete. Logs are stored in the '$LOG_DIR' directory."
