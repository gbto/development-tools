#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# This scripts downloads the artifact resulting from a GitHub action from a repository.
# Syntax: github-download-artifact.sh [-f target folder] [-u user] [-r repository] [-t github personal access token] [-a artifact id]

# Declare default arguments
USER="gibboneto"
REPO="tools"
GITHUB_TOKEN=''
ARTIFACT_ID=''
TARGET_FOLDER=''

# Parse user arguments
while getopts f:u:r:t:a: option; do
    case "${option}" in

    f) TARGET_FOLDER=${OPTARG} ;;
    u) USER=${OPTARG} ;;
    r) REPO=${OPTARG} ;;
    t) GITHUB_TOKEN=${OPTARG} ;;
    a) ARTIFACT_ID=${OPTARG} ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
    esac
done

# Warn for missing parameters
if [[ -z $GITHUB_TOKEN ]]; then
    echo "ERROR: You need to pass a GitHub personal token to access your artifacts. Exiting script."
    exit 1

else
    if [[ -z $ARTIFACT_ID ]]; then
        echo "You need to pass an artifact ID to download. Here's the list of artifacts in $REPO repository:"
        curl -s \
            -u username:$GITHUB_TOKEN \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/$USER/$REPO/actions/artifacts
        echo "To download an artifact, indicates its ID as a parameter to this script with -a <ARTIFACT_ID>"

    elif [[ ! -z $ARTIFACT_ID ]]; then

        if [[ -n $TARGET_FOLDER ]]; then

            # Move to new folder
            mkdir $TARGET_FOLDER
            cd $TARGET_FOLDER

            # Download the file from github actions
            curl -s \
                -L -o artifact-$ARTIFACT_ID.zip \
                -u username:$GITHUB_TOKEN \
                -H "Accept: application/vnd.github.v3+json" \
                https://api.github.com/repos/$USER/$REPO/actions/artifacts/$ARTIFACT_ID/zip

            # Unzip the archive and remove it from local
            unzip -o artifact-$ARTIFACT_ID.zip | unzip -o $(unzip -Z1 artifact-$ARTIFACT_ID.zip)

            # Remove the zipped files
            rm $(unzip -Z1 artifact-$ARTIFACT_ID.zip)
            rm "artifact-$ARTIFACT_ID.zip"

            echo "The artifact has been downloaded and extracted successfully. Exiting script."
            exit 0
        fi
    fi
fi
