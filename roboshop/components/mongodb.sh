#!/bin/bash

USER_ID=$(id -u)
COMPONENT=mongodb
LOG_FILE="/tmp/${COMPONENT}.log"
REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

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

echo -e "************\e[33m Configuring the MongoDB \e[0m************"
echo -n "Configuring the MongoDB Repos :"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo $REPO_URL
stat $?

echo -n "Installing the MongoDB :"
yum install -y ${COMPONENT}-org     &>> $LOG_FILE
stat $?

echo -n "Enabling MongoDB Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Starting MongoDB :"
systemctl enable mongod      &>> $LOG_FILE
systemctl daemon-reload      &>> $LOG_FILE
systemctl restart mongod     &>> $LOG_FILE

echo -n "Downloading the MongoDB Schema :"
curl -s -L -o /tmp/${COMPONENT}.zip $SCHEMA_URL
stat $?

echo -n "Extracting the MongoDB Component :"
cd /tmp
unzip -o ${COMPONENT}.zip       &>> $LOG_FILE
stat $?

echo -n "Injecting the Schema :"
cd mongodb-main         &>> $LOG_FILE
mongo < catalogue.js    &>> $LOG_FILE
mongo < users.js        &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the MongoDB is Completed \e[0m************"
