#!/bin/bash
PWD=`pwd`
globalEmail=`git config --global --get user.email`
localEmail=`git config --local --get user.email`
signingKey=`git config --local --get user.signingkey`
personalEmail="gibboneto@gmail.com"

if [[ -z $localEmail ]];
then
        echo "The global git configuration will use $globalEmail"
        echo "A local configuration is required for this repository"
        echo "Set it with git config user.email <user@email.com>"
        exit 1
elif [[ $localEmail != $personalEmail ]];
then
        echo "Local commit email is not the one expected"
        echo "Expected commit email: $personalEmail"
        echo "Local commit email: $localEmail"
        exit 1
elif [[ -z $signingKey ]];
then
        echo "No signing key found. Check local gitconfig"
        exit 1
else
        echo ""
        exit 0
fi
