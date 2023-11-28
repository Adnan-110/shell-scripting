#!/bin/bash 

COMPONENT=mysql
COMPONENT_URL="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"
source components/common.sh

echo -e "************\e[33m Configuring the MySQL \e[0m************"

echo -n "Configuring the ${COMPONENT} Repos :"
# curl -s -L -o /etc/yum.repos.d/${COMPONENT}.repostat $COMPONENT_URL
curl -s -L -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo
stat $?

echo -n "Installing the ${COMPONENT} :"
yum install ${COMPONENT}-community-server -y   &>> $LOG_FILE
stat $?

echo -n "Starting the ${COMPONENT} :"
systemctl enable mysqld     &>> $LOG_FILE
systemctl start mysqld      &>> $LOG_FILE
stat $?

echo -n "Extracting ${COMPONENT} Default Root Password : "
DEFAULT_ROOT_PSWD=$(sudo grep "temporary password" /var/log/mysqld.log | awk -F " " '{print $NF}')
stat $?

echo -e "************\e[33m Configuration of the MySQL is Completed \e[0m************"
