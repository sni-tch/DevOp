#!/bin/bash

# Configuration
IMAGE="snit4/programnew"
CPU_CORES=(0 1)
CONTAINERS=("srv1" "srv2")
PORTS=(8081 8082)
CHECK_INTERVAL=10
BUSY_THRESHOLD=70.0
IDLE_THRESHOLD=5.0

# Function to launch a container
launch_container() {
    local name=$1
    local core=$2
    local port=$3

    echo "Launching container '$name' on CPU core #$core, mapped to port $port..."
    docker run -d --name "$name" --cpuset-cpus="$core" -p "$port":8081 "$IMAGE"

    echo "Waiting 30 seconds to initialize container '$name'..."
    sleep 30
}

# Function to retrieve CPU usage of a container
get_cpu_usage() {
    local name=$1
    docker stats --no-stream --format "{{.CPUPerc}}" "$name" | sed 's/%//'
}

# Function to stop and remove a container
stop_container() {
    local name=$1

    echo "Stopping container '$name'..."
    docker kill --signal=SIGINT "$name"
    docker wait "$name"
    docker rm "$name"
}

# Initialize
active_containers=()
launch_container "${CONTAINERS[0]}" "${CPU_CORES[0]}" "${PORTS[0]}"
active_containers+=("${CONTAINERS[0]}")

# Main loop
while true; do
    for i in "${!CONTAINERS[@]}"; do
        name="${CONTAINERS[$i]}"

        if [[ $(docker ps -q --filter "name=$name") ]]; then
            cpu_usage=$(get_cpu_usage "$name")
            echo "Container '$name': CPU usage = $cpu_usage%"

            # Launch the next container if current is busy
            if (( $(echo "$cpu_usage > $BUSY_THRESHOLD" | bc -l) )) && [[ $i -lt ${#CONTAINERS[@]}-1 ]]; then
                next_name="${CONTAINERS[$i+1]}"
                if ! [[ " ${active_containers[*]} " =~ " $next_name " ]]; then
                    launch_container "$next_name" "${CPU_CORES[$i+1]}" "${PORTS[$i+1]}"
                    active_containers+=("$next_name")
                fi
            fi

            # Stop the container if it's idle
            if (( $(echo "$cpu_usage < $IDLE_THRESHOLD" | bc -l) )) && [[ $i -gt 0 ]]; then
                echo "Container '$name' is idle. Stopping..."
                stop_container "$name"
                active_containers=("${active_containers[@]/$name}")
            fi
        fi
    done

    # Check for image updates
    echo "Checking for image updates..."
    if docker pull "$IMAGE" | grep -q "Downloaded newer image"; then
        echo "New image update found. Restarting active containers..."
        for name in "${active_containers[@]}"; do
            stop_container "$name"
            index=$(echo "${CONTAINERS[@]}" | grep -n -w "$name" | cut -d: -f1)
            launch_container "$name" "${CPU_CORES[$((index-1))]}" "${PORTS[$((index-1))]}"
        done
    fi

    sleep "$CHECK_INTERVAL"
done
