#!/bin/bash

USER_ID=$(id -u)
COMPONENT=frontend
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

echo -e "************\e[33m Configuring the FrontEnd Component \e[0m************"

echo -n "Installing Nginx :" 

yum install nginx -y    &>> $LOG_FILE
stat $?
# if  [ $? -eq 0 ] ; then
#     echo -e "\e[32m Successfully Completed \e[0m"
# else
#     echo -e "\e[31m Failed to Install \e[0m"
# fi
    
echo -n "Downloading the ${COMPONENT} Component :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" 
stat $?
# if  [ $? -eq 0 ] ; then
#     echo -e "\e[32m Successfully Completed \e[0m"
# else
#     echo -e "\e[31m Failed to Download \e[0m"
# fi

echo -n "Clean-Up of ${COMPONENT} Component :"
cd /usr/share/nginx/html
rm -rf *    &>> $LOG_FILE
stat $?

echo -n "Extracting the ${COMPONENT} Component :"
unzip -o /tmp/${COMPONENT}.zip     &>> $LOG_FILE
stat $?

echo -n "Configuration of ${COMPONENT} Component :"
mv ${COMPONENT}-main/* .
mv static/* .
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Restarting the ${COMPONENT} Component :"
systemctl enable nginx      &>> $LOG_FILE
systemctl daemon reload     &>> $LOG_FILE
systemctl restart nginx     &>> $LOG_FILE
stat $?

echo -e "************\e[33m Configuration of the FrontEnd Component is Completed \e[0m************"
#echo -e "***** \e[35m $COMPONENT Configuration Is Complted \e[0m ******"