#!/bin/bash
# Authenticate to ECR, build the image in the directory and push it to ECR.
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# Syntax: ecr-build-push.sh [region] [aws account id] [repository name] [architecture (optional)]
# Example: /bin/bash ecr-build-push-image.sh $REGION $AWS_ACCOUNT_ID $REPOSITORY_NAME $DOCKERFILE_PATH $ARCHITECTURE

REGION=$1
AWS_ACCOUNT_ID=$2
REPOSITORY_NAME=$3
DOCKERFILE_PATH=$4
ARCHITECTURE=$5

if [[ -z $REGION ]] || [[ -z $AWS_ACCOUNT_ID ]] || [[ -z $REPOSITORY_NAME || -z $DOCKERFILE_PATH ]]; then
    echo "The REGION, AWS_ACCOUNT_ID, REPOSITORY_NAME and DOCKERFILE_PATH environment variables "
    echo "should be set in order to run this script. Set these and try again."
    exit 1
fi

# Create the ECR repository if it doesn't exist
output=$(aws ecr describe-repositories --registry-id $AWS_ACCOUNT_ID --repository-name $REPOSITORY_NAME --region $REGION --profile $PROFILE --no-cli-pager --no-cli-pager 2>&1)

if echo ${output} | grep -q 'RepositoryNotFoundException'; then
    echo "The repository $REPOSITORY_NAME does not exists in AWS account $AWS_ACCOUNT_ID region $REGION."
    exit 1
else
    # Build and push the image to ECR
    REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME
    IMAGE_NAME=$REPOSITORY_NAME
    IMAGE_TAG='latest'
    IMAGE_TMSTP=$(date +%s)

    if [[ $ARCHITECTURE = 'arm64' ]]; then
        docker build --file $DOCKERFILE_PATH -t $REPOSITORY_URI:$IMAGE_TAG .
        docker build --file $DOCKERFILE_PATH -t $REPOSITORY_URI:$IMAGE_TMSTP .
    else
        docker build --file $DOCKERFILE_PATH --platform linux/amd64 -t $REPOSITORY_URI:$IMAGE_TAG .
        docker build --file $DOCKERFILE_PATH --platform linux/amd64 -t $REPOSITORY_URI:$IMAGE_TMSTP .
    fi

    docker push $REPOSITORY_URI --all-tags
    exit 0
fi
