#!/bin/bash

# Script updates version file.
# Version format: Magor.Minor.Patch
# where Magor, Minor and Patch are integer numbers.

version_file=""
command=""
magor=""
minor=""
patch=""
new_version=""
current_version=""

usage() {

    echo "Usage: update_version.sh <command> [options] <file_path>"
    echo ""
    echo "<command>: Specifies the action to be performed by the script. It can be one of the following:"
    echo ""
    echo "get: Prints the current version number to the console."
    echo "increment: Increments the specified part of the version number (major, minor, or patch)."
    echo "set: Sets the version number to a new value provided through options."
    echo ""
    echo "[options]: Specifies which part of the version number to operate on and, for the set command, the new values. Options include:"
    echo ""
    echo "-m NUM: For the increment command, increments the Major version. For the set command, sets the Major version to NUM."
    echo "-n NUM: For the increment command, increments the Minor version. For the set command, sets the Minor version to NUM."
    echo "-p NUM: For the increment command, increments the Patch version. For the set command, sets the Patch version to NUM."
    echo ""
    echo "<file_path>: The path to the file containing the version number to be modified or retrieved. "
    exit 1

}

if [ $# -lt 1 ]; then
    usage
else
    command=$1
    shift
fi

if [[ $command != "get" && $command != "set" && $command != "increment" ]]; then
    usage
fi

# Parse argumants for get and increment
if [[ $command == "get" || $command == "increment" ]]; then
    while [[ $# -gt 1 ]]; do
        param=$1
        if [[ $param != "-m" && $param != "-n" && $param != "-p" ]]; then
            usage
        fi
        if [ $param == "-m" ]; then
            major="true"
            shift
        elif [ $param == "-n" ]; then
            minor="true"
            shift
        elif [ $param == "-p" ]; then
            patch="true"
            shift
        fi
    done
fi

# Parse argumants for set
if [[ $command == "set" ]]; then
    if [ $# -lt 2 ]; then
        usage
    fi
    if [ $# -eq 2 ]; then
        new_version=$1
        shift
    else
        while [[ $# -gt 1 ]]; do
            param=$1
            if [[ $param != "-m" && $param != "-n" && $param != "-p" ]]; then
                usage
            fi
            if [ $param == "-m" ]; then
                shift
                major=$1
            elif [ $param == "-n" ]; then
                shift
                minor=$1
            elif [ $param == "-p" ]; then
                shift
                patch=$1
            fi
            shift
        done
    fi
fi

#  Get file path
if [ $# -eq 1 ]; then
    version_file=$1
    if [[ ! -a $version_file ]]; then
        echo "Could not find file: $version_file"
        exit 1
    fi
else
    usage
fi

current_version=$(cat $version_file)
current_splitted=($(cat $version_file | awk 'BEGIN {FS = "\\."} {print $1, $2, $3}'))
current_major=${current_splitted[0]}
current_minor=${current_splitted[1]}
current_patch=${current_splitted[2]}

if [ $command == "get" ]; then
    if [[ "$major" == "" && "$minor" == "" && "$patch" == "" ]]; then
        echo $current_version
        exit 0
    else
        result=""
        if [ "$major" == "true" ]; then
            result="$result $current_major"
        fi
        if [ "$minor" == "true" ]; then
            result="$result $current_minor"
        fi
        if [ "$patch" == "true" ]; then
            result="$result $current_patch"
        fi
        echo $result
    fi
fi

if [ $command == "increment" ]; then
    new_major=$current_major 
    new_minor=$current_minor 
    new_patch=$current_patch 
    if [[ "$major" == "" && "$minor" == "" && "$patch" == "" ]]; then
        new_patch=$((new_patch+1)) 
    else
        if [ "$major" == "true" ]; then
            new_major=$((new_major+1))
        fi
        if [ "$minor" == "true" ]; then
            new_minor=$((new_minor+1))
        fi
        if [ "$patch" == "true" ]; then
            new_patch=$((new_patch+1))
        fi
    fi
    echo "set version to: $new_major.$new_minor.$new_patch"
    echo "$new_major.$new_minor.$new_patch" > $version_file
    exit 0
fi

if [ $command == "set" ]; then
    new_major=$current_major 
    new_minor=$current_minor 
    new_patch=$current_patch 
    if [ "$major" != "" ]; then
        new_major=$major
    fi
    if [ "$minor" != "" ]; then
        new_minor=$minor
    fi
    if [ "$patch" != "" ]; then
        new_patch=$patch
    fi
    echo "set version to: $new_major.$new_minor.$new_patch"
    echo "$new_major.$new_minor.$new_patch" > $version_file
    exit 0
fi

# echo "COMMAND: $command"
# echo "PARAMS:"
# echo "$major"
# echo "$minor"
# echo "$patch"
# echo "FiILE: $version_file"
# echo "CURRENT_VERSION: $current_version"
# echo "NEW_VERSION: $new_version"
# echo "CURRENT_SPLITTED: $current_splitted"
# echo "CURRENT_MAJOR: $current_major"


