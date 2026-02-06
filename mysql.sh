#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="/var/log/shell-roboshop/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE() {
if [ $1 -ne 0 ]; then
    echo "$2 is...FAILURE" | tee -a $LOGS_FILE  
    exit 1
else 
    echo "$2 is...SUCCESS" | tee -a $LOGS_FILE      
fi
}

dnf install mysql-server -y
VALIDATE $? "Installing mysql server"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? "Enabled and Started mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"