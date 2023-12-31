#!/bin/bash

COMPONENT=redis
source components/common.sh

echo -e "************\e[33m Configuring the Redis \e[0m************"

echo -n "Installing $COMPONENT :"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>> $LOG_FILE
yum install redis-6.2.13 -y &>> $LOG_FILE
stat $?

echo -n "Enabling $COMPONENT Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "Starting $COMPONENT :"
systemctl enable redis      &>> $LOG_FILE
systemctl daemon-reload      &>> $LOG_FILE
systemctl restart redis     &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the Redis is Completed \e[0m************"

