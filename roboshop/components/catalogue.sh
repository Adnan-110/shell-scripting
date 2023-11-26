#!/bin/bash


#!/bin/bash

USER_ID=$(id -u)
COMPONENT=catalogue
LOG_FILE="/tmp/${COMPONENT}.log"
COMPONENT_URL="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER=roboshop
APPUSER_HOME="/home/${APPUSER}/${COMPONENT}"

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
yum install nodejs -y &>> $LOG_FILE
stat $?

echo -n "Creating the RoboShop User :"
id $APPUSER     &>> $LOG_FILE
if [ $? -ne 0 ] ; then
    useradd $APPUSER
    stat $?
else
    echo -n "Already Exist"
fi

echo -n "Downloading the Catalogue Component :"
curl -s -L -o /tmp/${COMPONENT}.zip $COMPONENT_URL      &>> $LOG_FILE
stat $?

echo -n "Extracting the Catalogue in roboshop user :"
cd /home/roboshop
unzip -o /tmp/${COMPONENT}.zip      &>> $LOG_FILE
stat $?

echo -n "Configuring the Catalogue Component Permissions :"
mv ${APPUSER_HOME}-main $APPUSER_HOME &>> $LOG_FILE
chown -R $APPUSER:$APPUSER $APPUSER_HOME 
chmod -R 770 $APPUSER_HOME
stat $?

echo -n "Installing the Catalogue Component Dependencies :"
cd $APPUSER_HOME
npm install      &>> $LOG_FILE
stat $?

