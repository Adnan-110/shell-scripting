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

echo "show databases;" | mysql -uroot -pRoboShop@1           &>> $LOG_FILE
if [ $? -ne 0 ] ; then
    echo "Changing $COMPONENT root password : "
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'" | mysql --connect-expired-password -uroot -p$DEFAULT_ROOT_PSWD      &>> $LOG_FILE
    stat $?
fi

echo "show plugins" | mysql mysql -uroot -pRoboShop@1 | grep validate_password           &>> $LOG_FILE
if [ $? -eq 0 ] ; then
    echo -n "Uninstalling the password validate plugin : "
    echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1      &>> $LOG_FILE
    stat $?
fi

echo -n "Downloading $COMPONENT Schema : " 
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Extracting the $COMPONENT : "
unzip -o /tmp/${COMPONENT}.zip      &>> $LOG_FILE
stat $?

echo -n "Injecting the Schema :"
cd $COMPONENT-main
mysql -u root -pRoboShop@1 <shipping.sql     &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the MySQL is Completed \e[0m************"
