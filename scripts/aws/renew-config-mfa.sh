#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# This script prints the new credentials for AWS according to the environment for 24h
# so that it can be easily copied/pasted. /!\ Modify the arn according to you accounts values.
# The first argument is the IAM profile, the second the token on the MFA device.
# Syntax: ./renew-config-mfa.sh sbx 123456

case $1 in
"gbto")
    echo "Renewing creds for gbto"
    r=$(docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli sts get-session-token --serial-number arn:aws:iam::895539818407:mfa/root-account-mfa-device --token-code $2 --duration-seconds 86400 --profile $1)
    r1=$(echo "$r" | grep AccessKeyId)
    echo $r1 | sed 's/"AccessKeyId": //' | sed 's/,//' | xargs echo "aws_access_key_id ="
    r2=$(echo "$r" | grep SecretAccessKey)
    echo $r2 | sed 's/"SecretAccessKey": //' | sed 's/,//' | xargs echo "aws_secret_access_key ="
    r3=$(echo "$r" | grep SessionToken)
    echo $r3 | sed 's/"SessionToken": //' | sed 's/,//' | xargs echo "aws_session_token ="
    ;;
"sbx")
    echo "Renewing creds for sbx"
    r=$(docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli sts get-session-token --serial-number arn:aws:iam::364737596256:mfa/quentin.gaborit --token-code $2 --duration-seconds 86400 --profile $1)
    r1=$(echo "$r" | grep AccessKeyId)
    echo $r1 | sed 's/"AccessKeyId": //' | sed 's/,//' | xargs echo "aws_access_key_id ="
    r2=$(echo "$r" | grep SecretAccessKey)
    echo $r2 | sed 's/"SecretAccessKey": //' | sed 's/,//' | xargs echo "aws_secret_access_key ="
    r3=$(echo "$r" | grep SessionToken)
    echo $r3 | sed 's/"SessionToken": //' | sed 's/,//' | xargs echo "aws_session_token ="
    ;;
"stg")
    echo "Renewing creds for stg"
    r=$(docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli sts get-session-token --serial-number arn:aws:iam::454902641012:mfa/quentin.gaborit --token-code $2 --duration-seconds 86400 --profile $1)
    r1=$(echo "$r" | grep AccessKeyId)
    echo $r1 | sed 's/"AccessKeyId": //' | sed 's/,//' | xargs echo "aws_access_key_id ="
    r2=$(echo "$r" | grep SecretAccessKey)
    echo $r2 | sed 's/"SecretAccessKey": //' | sed 's/,//' | xargs echo "aws_secret_access_key ="
    r3=$(echo "$r" | grep SessionToken)
    echo $r3 | sed 's/"SessionToken": //' | sed 's/,//' | xargs echo "aws_session_token ="
    ;;
"prd")
    echo "Renewing creds for prod"
    r=$(docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli sts get-session-token --serial-number arn:aws:iam::737219370090:mfa/quentin.gaborit --token-code $2 --duration-seconds 86400 --profile $1)
    r1=$(echo "$r" | grep AccessKeyId)
    echo $r1 | sed 's/"AccessKeyId": //' | sed 's/,//' | xargs echo "aws_access_key_id ="
    r2=$(echo "$r" | grep SecretAccessKey)
    echo $r2 | sed 's/"SecretAccessKey": //' | sed 's/,//' | xargs echo "aws_secret_access_key ="
    r3=$(echo "$r" | grep SessionToken)
    echo $r3 | sed 's/"SessionToken": //' | sed 's/,//' | xargs echo "aws_session_token ="
    ;;
*) echo "Not supported environment" ;;
esac
