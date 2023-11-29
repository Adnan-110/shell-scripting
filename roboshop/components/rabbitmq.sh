#!/bin/bash

COMPONENT=rabbitmq
source components/common.sh

echo -e "************\e[33m Configuring the RabbitMQ \e[0m************"

echo -n "Configuring the $COMPONENT Repos :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash      &>>LOG_FILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash    &>> $LOG_FILE
stat $?

echo -n "Installing the $COMPONENT :"
yum install rabbitmq-server -y  &>> $LOG_FILE
stat $?

echo -n "Starting $COMPONENT Service :"
systemctl enable rabbitmq-server       &>> $LOGFILE
systemctl start rabbitmq-server        &>> $LOGFILE
stat $?

rabbitmqctl list_users | grep ${APPUSER}  &>> $LOG_FILE
if [ $? -ne 0 ] ; then
    echo -n "Creating $APPUSER for $COMPONENT : "
    rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
    stat $?
fi

echo -n "Providing Permission to $APPUSER : "
rabbitmqctl set_user_tags roboshop administrator    &>> $LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"        &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the RabbitMQ is Completed \e[0m************"
