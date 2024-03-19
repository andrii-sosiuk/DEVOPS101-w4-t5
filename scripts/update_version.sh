#!/bin/bash

param1="$1"
param2="$2"
param3="$3"

# Function to increment the patch version
increment_patch() {
    local version="$1"
    IFS='.' read -r major minor patch <<< "$version"
    patch=$((patch + 1))
    echo "$major.$minor.$patch"
}

# Function to update the version in the file
update_version_file() {
    local new_version="$1"
    local file="$2"
    echo "$new_version" > "$file"
    echo "Version updated to $new_version in $file"
}

# Validate input
if [[ -z "$param1" ]] || [[ -z "$param2" ]]; then
    echo "Usage:"
    echo "  $0 update <file_path>"
    echo "  $0 set <version_number> <file_path>"
    exit 1
fi

# Process parameters
if [[ "$param1" == "update" ]]; then
    file_path="$param2"
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File $file_path not found."
        exit 1
    fi
    current_version=$(cat "$file_path")
    new_version=$(increment_patch "$current_version")
    update_version_file "$new_version" "$file_path"

elif [[ "$param1" == "set" ]]; then
    new_version="$param2"
    file_path="$param3"
    if [[ -z "$file_path" ]]; then
        echo "Error: File path must be provided."
        exit 1
    fi
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File $file_path not found."
        exit 1
    fi
    update_version_file "$new_version" "$file_path"
else
    echo "Invalid action: $param1"
    echo "Usage:"
    echo "  $0 update <file_path>"
    echo "  $0 set <version_number> <file_path>"
    exit 1
fi
