#!/bin/bash

USER_ID=$(id -u)
LOG_FILE="/tmp/${COMPONENT}.log"
COMPONENT_URL="https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
APPUSER=roboshop
APPUSER_HOME="/home/${APPUSER}/${COMPONENT}"

if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m !!!!!!!!!!!! This Script is Expected to be Executed with sudo or as a root user !!!!!!!!!!!!\e[0m"
    echo -e "\e[35m Example Usage : \n\t\t \e[0m sudo bash scriptName componentName"
    exit 1
fi 

stat(){
    if  [ $1 -eq 0 ] ; then      #Since $? is first arg while calling function so we are checking using $1
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi
}

CREATE_USER() {
    echo -n "Creating the RoboShop User :"
    id $APPUSER     &>> $LOG_FILE
    if [ $? -ne 0 ] ; then
        useradd $APPUSER
        stat $?
    else
        echo -ne  "\e[33m Already Exist \e[0m\n"
    fi
}

DOWNLOAD__AND_EXTRACT() {
    echo -n "Downloading the ${COMPONENT} Component :"
    curl -s -L -o /tmp/${COMPONENT}.zip $COMPONENT_URL      &>> $LOG_FILE
    stat $?

    echo -n "Performing Clean-Up of the ${COMPONENT} Component :"
    rm -rf $APPUSER_HOME    &>> $LOG_FILE
    stat $?

    echo -n "Extracting the ${COMPONENT} in roboshop user :"
    cd /home/${APPUSER}
    unzip -o /tmp/${COMPONENT}.zip      &>> $LOG_FILE
    mv /home/${APPUSER}/${COMPONENT}-main /home/${APPUSER}/${COMPONENT}
    stat $?
}

CONFIG_SVS() {
    echo -n "Configuring the ${COMPONENT} Component Permissions :"
    #   mv ${APPUSER_HOME}-main $APPUSER_HOME &>> $LOG_FILE
    chown -R $APPUSER:$APPUSER $APPUSER_HOME 
    chmod -R 770 $APPUSER_HOME
    stat $?

    echo -n "Configuring the ${COMPONENT} Component Systemd File :"
    sed -i -e 's/USERHOST/user.roboshop.internal.com/' -e 's/AMQPHOST/rabbitmq.roboshop.internal.com/' -e 's/DBHOST/mysql.roboshop.internal.com/' -e 's/CARTHOST/cart.roboshop.internal.com/' -e 's/DBHOST/mysql.roboshop.internal.com/' -e 's/CARTENDPOINT/cart.roboshop.internal.com/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal.com/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal.com/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal.com/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal.com/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal.com/' ${APPUSER_HOME}/systemd.service
    mv ${APPUSER_HOME}/systemd.service /etc/systemd/system/${COMPONENT}.service
    stat $?
}

START_SVS() {
    echo -n "Starting the ${COMPONENT} Component Services :"
    systemctl daemon-reload         &>> $LOG_FILE
    systemctl enable $COMPONENT     &>> $LOG_FILE
    systemctl restart $COMPONENT    &>> $LOG_FILE
    stat $?
}
NodeJS() {
    echo -n "Installing the NodeJS :"
    yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y   &>> $LOG_FILE
    yum install nodejs -y &>> $LOG_FILE
    stat $? 
    CREATE_USER #Calls create user function that creates user

    DOWNLOAD__AND_EXTRACT

    CONFIG_SVS

    echo -n "Installing the ${COMPONENT} Component Dependencies :"
    cd $APPUSER_HOME
    npm install      &>> $LOG_FILE
    stat $?

    START_SVS
}

JAVA() {
    echo -n "Installing the Maven :"
    # curl "https://gitlab.com/thecloudcareers/opensource/-/raw/master/lab-tools/maven-java11/install.sh"   &>> $LOG_FILE
    yum install maven -y  &>> $LOG_FILE    
    stat $? 

    CREATE_USER #Calls create user function that creates user

    DOWNLOAD__AND_EXTRACT

    echo -n "Installing the ${COMPONENT} Component Dependencies :"
    cd $APPUSER_HOME
    mvn clean package   &>> $LOG_FILE
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
    stat $?

    CONFIG_SVS

    START_SVS
    
}

PYTHON() {
    echo -n "Installing the Python :"
    yum install python36 gcc python3-devel -y &>> $LOG_FILE
    stat $? 

    CREATE_USER #Calls create user function that creates user

    DOWNLOAD__AND_EXTRACT

    echo -n "Installing the ${COMPONENT} Component Dependencies :"
    cd $APPUSER_HOME
    pip3 install -r requirements.txt   &>> $LOG_FILE
    stat $?

    CONFIG_SVS

    USER_ID=$(id -u roboshop)
    GROUP_ID=$(id -g roboshop)
    echo -n "Updating the UID & GID of the Payment.ini file : "
    sed -i -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}"  "${APPUSER_HOME}/${COMPONENT}.ini"    
    stat $?

    START_SVS
}