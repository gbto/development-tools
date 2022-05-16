#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# This script cleans bucket from all objects and versions before removing it entirely.
# Syntax: s3-remove-object-versions.sh [bucket name]

BUCKET=$1

set -e

echo "Removing all versions from $BUCKET"

versions=$(aws s3api list-object-versions --bucket $BUCKET | jq '.Versions')
markers=$(aws s3api list-object-versions --bucket $BUCKET | jq '.DeleteMarkers')
let count=$(echo $versions | jq 'length')-1

if [ $count -gt -1 ]; then
    echo "removing files"
    for i in $(seq 0 $count); do
        key=$(echo $versions | jq .[$i].Key | sed -e 's/\"//g')
        versionId=$(echo $versions | jq .[$i].VersionId | sed -e 's/\"//g')
        cmd="aws s3api delete-object --bucket $BUCKET --key $key --version-id $versionId --no-cli-pager"
        echo $cmd
        $cmd
    done
fi

let count=$(echo $markers | jq 'length')-1

if [ $count -gt -1 ]; then
    echo "removing delete markers"

    for i in $(seq 0 $count); do
        key=$(echo $markers | jq .[$i].Key | sed -e 's/\"//g')
        versionId=$(echo $markers | jq .[$i].VersionId | sed -e 's/\"//g')
        cmd="aws s3api delete-object --bucket $BUCKET --key $key --version-id $versionId --no-cli-pager"
        echo $cmd
        $cmd
    done
fi
