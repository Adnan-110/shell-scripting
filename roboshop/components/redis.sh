#!/bin/bash

USER_ID=$(id -u)
COMPONENT=redis
LOG_FILE="/tmp/${COMPONENT}.log"

stat(){
    if  [ $1 -eq 0 ] ; then      #Since $? is first arg while calling function so we are checking using $1
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi
}

if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m !!!!!!!!!!!! This Script is Expected to be Executed with sudo or as a root user !!!!!!!!!!!!\e[0m"
    echo -e "\e[35m Example Usage : \n\t\t \e[0m sudo bash scriptName componentName"
    exit 1
fi 

echo -e "************\e[33m Configuring the Redis \e[0m************"

echo -n "Installing Redis :"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo 
yum install redis-6.2.13 -y
stat $?

echo -n "Enabling Redis Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "Starting Reddis :"
systemctl enable redis      &>> $LOG_FILE
systemctl daemon-reload      &>> $LOG_FILE
systemctl restart redis     &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the Redis is Completed \e[0m************"

