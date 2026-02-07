#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="/var/log/shell-roboshop/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_DIR=$PWD   #doubt
MYSQL_HOST="mysql.exploreops.online"

if [ $USERID -ne 0 ]; then
    echo -e "$R please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE() {
if [ $1 -ne 0 ]; then
    echo -e "$2 ...$R FAILURE $N" | tee -a $LOGS_FILE  
    exit 1
else 
    echo -e "$2 ...$G SUCCESS $N" | tee -a $LOGS_FILE      
fi
}

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Added rabbitmq repo"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
systemctl start rabbitmq-server
VALIDATE $? "Enabled and Started rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
VALIDATE $? "Created users and given permissions"



