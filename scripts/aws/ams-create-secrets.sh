#!/bin/bash
# Create a secret manager
# Maintainer: Quentin Gaborit, <gibbonetog@gmail.com>
# Syntax: ecr-create-repository.sh [aws region] [aws account id] [repository name]
# Example: /bin/bash secretsmanager-create-secrets.sh $REGION $PROFILE $SECRETS_NAME $SECRETS_VAL $SECRETS_DESC

# Verify the JQ utils that renders JSON cli output is installed
if ! command -v jq &>/dev/null; then
    echo "jq could not be found. Please install with 'brew install jq' or 'sudo apt-get install jq'"
    exit 1
fi

# Parse the inputs
REGION=$1
PROFILE=$2
SECRETS_NAME=$3
SECRETS_VAL=$4
SECRETS_DESC=$5

if [[ -z $REGION ]] || [[ -z $PROFILE ]] || [[ -z $SECRETS_NAME ]] || [[ -z $SECRETS_VAL ]] || [[ -z $SECRETS_DESC ]]; then
    echo "The REGION, PROFILE, SECRETS_NAME, SECRETS_VAL or SECRETS_DESC environment variables "
    echo "should be set in order to run this script. Declare it and try again."
else
    # Try to create the secrets
    creation_output=$(aws secretsmanager create-secret \
        --name $SECRETS_NAME \
        --description "${SECRETS_DESC}" \
        --secret-string $SECRETS_VAL \
        --profile $PROFILE \
        --region $REGION \
        --no-cli-pager 2>&1)

    # Secrets created successfully
    if [ $? == 0 ]; then

        echo "Successfully created $SECRETS_NAME in the $REGION region."
        echo $creation_output | jq
        exit 0

    # Secrets already exists
    elif echo ${creation_output} | grep -q 'ResourceExistsException'; then

        # Ask user whether to delete the secrets permanently
        echo $creation_output
        describe_output=$(aws secretsmanager describe-secret \
            --secret-id $SECRETS_NAME \
            --region $REGION \
            --profile $PROFILE \
            --no-cli-pager 2>&1)
        echo $describe_output | jq

        read -p "Do you want to remove it permanently? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

        # Act uppon user input and exit script
        if [[ "$confirm" == [yY] || "$confirm" == [yY][eE][sS] ]]; then
            deletion_output=$(aws secretsmanager delete-secret \
                --secret-id $SECRETS_NAME \
                --region $REGION \
                --profile $PROFILE \
                --force-delete-without-recovery \
                --no-cli-pager 2>&1)
            echo "The secrets has been removed permanently, skipping the default 7 days recovery window."
            echo "You can try to re-run this script in a few seconds to create the secrets again."
        else
            echo "The current secret will be kept as is. Exiting script."
        fi
        exit 1

    # Printing other potential errors
    else
        echo "An error occurred while attempting to create $SECRETS_NAME in the $REGION region."
        echo $output
        exit 1
    fi
fi
