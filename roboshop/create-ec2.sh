#!/bin/bash

if [ -z $1 ] ; then
    echo -e "\e[31m !!!!!!!! COMPONENT NAME IS NEEDED !!!!!!!!\e[0m \n\t\t"
    echo -e "\e[36m Example Usage : \e[0m bash create-ec2.sh componentName"
    exit 1
fi 


AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" |jq ".Images[].ImageId" | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters "Name=group-name, Values=Allow All" | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')
COMPONENT=$1
HZ_ID=$(aws route53 list-hosted-zones |jq ".HostedZones[].Id" | sed -e 's/"//g' -e 's/hostedzone//g' -e 's/\///g')
INSTANCE_TYPE=t2.micro
echo -e "\e[36m******** Creating a Server ********\e[0m"

echo -e "\e[36m++++++ ${COMPONENT} Server Creation Started ++++++\e[0m"
PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --security-group-ids ${SGID} --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=${COMPONENT}}]" | jq ".Instances[].PrivateIpAddress" | sed -e 's/"//g')
# aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"

echo -e "\e[36m++++++ ${COMPONENT} Server Creation Completed Successfully  ++++++\e[0m \n\n"

echo -e "\e[36m++++++ ${COMPONENT} DNS Record Creation Started ++++++\e[0m"

sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.json > /tmp/dns.json

$ aws route53 change-resource-record-sets --hosted-zone-id ${HZ_ID} --change-batch file:///tmp/dns.json

echo -e "\e[36m++++++ ${COMPONENT} DNS Record Completed Successfully ++++++\e[0m \n\n"
