#!/bin/bash

COMPONENT=mongodb
source components/common.sh

REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
SCHEMA_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

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
stat $?

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
stat $?
mongo < users.js        &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the MongoDB is Completed \e[0m************"
