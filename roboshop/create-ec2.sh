#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo -e "\n\e[31m !!!!!!!! COMPONENT NAME & ENVIRONMENT ARE NEEDED !!!!!!!!\e[0m \n\t\t"
    echo -e "\e[36m Example Usage : \e[0m bash create-ec2.sh componentName Environment"
    exit 1
fi 


AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" |jq ".Images[].ImageId" | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters "Name=group-name, Values=Allow All" | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')
COMPONENT=$1
ENVIRONMENT=$2
HZ_ID=$(aws route53 list-hosted-zones |jq ".HostedZones[].Id" | sed -e 's/"//g' -e 's/hostedzone//g' -e 's/\///g')
INSTANCE_TYPE=t2.micro

create_server() {
echo -e "\e[36m******** Creating a ${ENVIRONMENT} Server ********\e[0m \n"

echo -e "\e[36m++++++ ${COMPONENT}-${ENVIRONMENT} Server Creation Started ++++++\e[0m"
PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --security-group-ids ${SGID} --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=${COMPONENT}-${ENVIRONMENT}}]" | jq ".Instances[].PrivateIpAddress" | sed -e 's/"//g')
# aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"

echo -e "\e[36m++++++ ${COMPONENT}-${ENVIRONMENT} Server Creation Completed Successfully  ++++++\e[0m \n\n"

echo -e "\e[36m++++++ ${COMPONENT}-${ENVIRONMENT} DNS Record Creation Started ++++++\e[0m"

sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.json > /tmp/dns.json

aws route53 change-resource-record-sets --hosted-zone-id ${HZ_ID} --change-batch file:///tmp/dns.json

echo -e "\e[36m++++++ ${COMPONENT}-${ENVIRONMENT} DNS Record Completed Successfully ++++++\e[0m \n\n"
}

# If  User Provides 'all' as the first argument, then all below mentioned servers will be created.

if [ "$1" == "all" ]; then 
    for component in mongodb catalogue cart user shipping frontend payment mysql redis rabbitmg; do 
        COMPONENT=$component 
        create_server 
    done 
else 
    create_server 
fi