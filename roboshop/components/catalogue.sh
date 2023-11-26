#!/bin/bash


#!/bin/bash

USER_ID=$(id -u)
COMPONENT=catalogue
LOG_FILE="/tmp/${COMPONENT}.log"
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

echo -e "************\e[33m Configuring the Catalogue Component \e[0m************"
echo -n "Installing the NodeJS :"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> $LOG_FILE
stat $?

echo -n "Creating the RoboShop User :"
useradd roboshop
stat $?

echo -n "Switching to the RoboShop User :"
su - roboshop
stat $?

echo -n "Configuring the Catalogue in roboshop user :"
curl -s -L -o /tmp/${COMPONENT}.zip
stat $?

echo -n "Extracting the Catalogue in roboshop user :"
cd /home/roboshop
unzip /tmp/${COMPONENT}.zip
stat $?

echo -n "Installing the Catalogue Component Dependencies in roboshop user :"
mv ${COMPONENT}-main ${COMPONENT}
cd /home/roboshop/${COMPONENT}
npm install
