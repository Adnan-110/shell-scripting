#!/bin/bash

COMPONENT=frontend
source components/common.sh


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
unzip -o /tmp/${COMPONENT}.zip    &>> $LOG_FILE
# unzip -o ${COMPONENT}.zip     &>> $LOG_FILE
stat $?

echo -n "Configuration of ${COMPONENT} Component :"
mv ${COMPONENT}-main/* .
mv static/* .            
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Updating Reverse Proxy :"
    for component in catalogue user cart ; do 
        sed -i -e "/${component}/s/localhost/${component}.roboshop.internal.com/" /etc/nginx/default.d/roboshop.conf
    done
    stat $?


echo -n "Restarting the ${COMPONENT} Component :"
systemctl enable nginx      &>> $LOG_FILE
systemctl daemon reload     &>> $LOG_FILE
systemctl restart nginx     &>> $LOG_FILE
stat $?     

echo -e "************\e[33m Configuration of the FrontEnd Component is Completed \e[0m************"
#echo -e "***** \e[35m $COMPONENT Configuration Is Complted \e[0m ******"