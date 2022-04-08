#!/bin/bash
# Maintainer: Quentin Gaborit, <quentin.gaborit@ledger.fr>
# Syntax: Remove .sh extension and place file in .git/hooks/ folder of any git repository

PWD=$(pwd)
currentEmail=$(git config --get user.email)
signingKey=$(git config --get user.signingkey)
workEmail="quentin.gaborit@ledger.fr"

######### COMMIT EMAIL VERIFICATION
if [[ -z $currentEmail ]];
then
        echo "A git configuration is required to push commits to this repository."
        echo "Set it with git config user.email <user@email.com>"
        exit 1
elif [[ $currentEmail != $workEmail ]];
then
        echo "Expected and current user email differ"
        echo "Current commit email $currentEmail"
        echo "Work commit email: $workEmail"
        exit 1
elif [[ -z $signingKey ]];
then
        echo "No signing key found. Check global gitconfig"
        exit 1
else
        echo "Commit can be successfully pushed with email $currentEmail"
fi

######### SQL FLUFF

######### PYTHON BLACK

