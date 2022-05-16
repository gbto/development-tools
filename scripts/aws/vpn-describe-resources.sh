#!/bin/bash
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# This script prints network resources status for VPC deletion issue resolution.
# Syntax: vpn-describe-resources.sh [VPC id] [region]

VPC_ID=$1
REGION=$2

aws ec2 describe-vpc-peering-connections --region $REGION --filters 'Name=requester-vpc-info.vpc-id,Values='$VPC_ID | grep VpcPeeringConnectionId
aws ec2 describe-nat-gateways --region $REGION --filter 'Name=vpc-id,Values='$VPC_ID | grep NatGatewayId
aws ec2 describe-instances --region $REGION --filters 'Name=vpc-id,Values='$VPC_ID | grep InstanceId
aws ec2 describe-vpn-gateways --region $REGION --filters 'Name=attachment.vpc-id,Values='$VPC_ID | grep VpnGatewayId
aws ec2 describe-network-interfaces --region $REGION --filters 'Name=vpc-id,Values='$VPC_ID | grep NetworkInterfaceId
