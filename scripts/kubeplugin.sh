#!/bin/bash

# Usage
usage() {
    echo "Usage: $0 -n namespace [-r resource] [-b] [-a]"
    echo "  -n namespace    Specify the namespace (mandatory)"
    echo "  -r resource     Specify the resource type"
    echo "  -b              Brief output"
    echo "  -a              Output all resources (cannot be used with -r)"
    exit 1
}

resource=""
namespace=""
brief=0
all_resources=0

# Options
while getopts ":r:n:ba" opt; do
    case $opt in
        r)
            resource=$OPTARG
            ;;
        n)
            namespace=$OPTARG
            ;;
        b)
            brief=1
            ;;
        a)
            all_resources=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done


echo $brief

# Check if namespace was provided
if [ -z "$namespace" ]; then
    echo "Error: -n (namespace) is mandatory." >&2
    usage
fi

# Check for conflicting options
if [[ $all_resources -eq 1 && -n $resource ]]; then
    echo "Error: -a cannot be used with -r." >&2
    usage
fi

# Check if -a or -r is present
if [[ $all_resources -eq 0 && -z $resource ]]; then
    echo "Error: Either -r or -a must be specified unless outputting all resources." >&2
    usage
fi

if [[ $brief -eq 0 ]]; then
  # Print headers with proper column width using printf
  printf "%-16s %-16s %-60s %-8s %-8s\n" "Resource" "Namespace" "Name" "CPU" "Memory"
fi

# Retrieve resource usage statistics from Kubernetes
kubectl top $resource -n $namespace | tail -n +2 | while read line
do
  # Extract CPU and memory usage from the output
  NAME=$(echo $line | awk '{print $1}')
  CPU=$(echo $line | awk '{print $2}')
  MEMORY=$(echo $line | awk '{print $3}')

  # Output the statistics to the console using printf for formatted output
  if [[ $brief -eq 0 ]]; then
    printf "%-16s %-16s %-60s %-8s %-8s\n" "$resource" "$namespace" "$NAME" "$CPU" "$MEMORY"
  fi
done
