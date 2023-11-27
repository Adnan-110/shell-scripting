#!/bin/bash

#!/bin/bash

USER_ID=$(id -u)
COMPONENT=user
LOG_FILE="/tmp/${COMPONENT}.log"
COMPONENT_URL="https://github.com/stans-robot-project/user/archive/main.zip"
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

echo -e "************\e[33m Configuring the User Component \e[0m************"
echo -n "Installing the NodeJS :"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> $LOG_FILE
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

echo -n "Downloading the User Component :"
curl -s -L -o /tmp/${COMPONENT}.zip $COMPONENT_URL      &>> $LOG_FILE
stat $?

echo -n "Performing Clean-Up of the User Component :"
rm -rf $APPUSER_HOME    &>> $LOG_FILE
stat $?

echo -n "Extracting the User Component in roboshop user :"
cd /home/roboshop
unzip -o /tmp/${COMPONENT}.zip      &>> $LOG_FILE
stat $?

echo -n "Configuring the User Component Permissions :"
mv ${APPUSER_HOME}-main $APPUSER_HOME &>> $LOG_FILE
chown -R $APPUSER:$APPUSER $APPUSER_HOME 
chmod -R 770 $APPUSER_HOME
stat $?

echo -n "Installing the User Component Dependencies :"
cd $APPUSER_HOME
npm install      &>> $LOG_FILE
stat $?

echo -n "Configuring the User Component Systemd File :"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal.com/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal.com/'  $APPUSER_HOME/systemd.service
mv ${APPUSER_HOME}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the User Component Services :"
systemctl daemon-reload         &>> $LOG_FILE
systemctl enable $COMPONENT     &>> $LOG_FILE
systemctl restart $COMPONENT    &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the User Component is Completed \e[0m************"

