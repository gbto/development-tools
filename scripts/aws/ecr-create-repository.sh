#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# Authenticates to an AWS ECR container registry and create a repository (to get the account id,
# you can run the command 'aws sts get-caller-identity --profile $PROFILE').
# Syntax: ecr-create-repository.sh [aws region] [aws account id] [repository name] [profile]
# Example: /bin/bash ecr-create-repository.sh $REGION $AWS_ACCOUNT_ID $REPOSITORY_NAME $PROFILE

# Verify the JQ utils that renders JSON cli output is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install with 'brew install jq' or 'sudo apt-get install jq'"
    exit 1
fi

# Parse the inputs
REGION=$1
AWS_ACCOUNT_ID=$2
REPOSITORY_NAME=$3
PROFILE=$4

if [[ -z $REGION ]] ||  [[ -z $AWS_ACCOUNT_ID ]] ||  [[ -z $REPOSITORY_NAME ]] || [[ -z $PROFILE ]];
then
    echo "The REGION, AWS_ACCOUNT_ID, REPOSITORY_NAME or PROFILE environment variables "
    echo "should be set in order to run this script. Declare it and try again."
fi

# Declare the policy to attach to the repository
defaultPolicy()
{
    cat <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

# Authenticate
aws ecr get-login-password --region $1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create the ECR repository if it doesn't exist
output=$(aws ecr describe-repositories --registry-id $AWS_ACCOUNT_ID --repository-name $REPOSITORY_NAME --region $REGION --profile $PROFILE --no-cli-pager --no-cli-pager  2>&1)

if echo ${output} | grep -q 'RepositoryNotFoundException';
then
    # Create the ECR repository
    echo ">> Creating the $REPOSITORY_NAME:$REGION in $AWS_ACCOUNT_ID"
    repository=$(aws ecr create-repository \
        --registry-id $AWS_ACCOUNT_ID \
        --repository-name $REPOSITORY_NAME \
        --region $REGION \
        --profile $PROFILE \
        --no-cli-page)

    echo "Created the repository: "
     echo $repository | jq

    # Set the policy to allow pushing images
    echo ">> Attaching the default policy to the repository $REPOSITORY_NAME"
    policy=$(aws ecr set-repository-policy \
            --registry-id $AWS_ACCOUNT_ID \
            --repository-name $REPOSITORY_NAME \
            --policy-text "$(defaultPolicy)" \
            --profile $PROFILE \
            --region $REGION \
            --no-cli-pager)
    echo ">> Attached the following policy:"
    echo $policy | jq
else
    echo "The repository $REPOSITORY_NAME already exists in account $AWS_ACCOUNT_ID region $REGION with the following configuration:"
    echo $output | jq
fi

