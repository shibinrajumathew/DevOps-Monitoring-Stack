#!/bin/bash

# Define directories to create
DIRS=(
    "/home/ubuntu/monitoring/nagios/etc"
    "/home/ubuntu/monitoring/nagios/var"
    "/home/ubuntu/monitoring/prometheus/data"
    "/home/ubuntu/monitoring/grafana/data"
    "/home/ubuntu/monitoring/node_exporter"
)

# Loop through and create directories
for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    echo "Created: $dir"
done

echo "All directories created successfully!"
