echo -e "\e[36m>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service  &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> create Mongodb repo <<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install NodeJS repos <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install Node js <<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> add app user <<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> cleaning the app content <<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>create app directory<<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Extract app content <<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[36m>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install Mongo client <<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<\e[0m"
mongo --host 172.31.22.169 </app/schema/catalogue.js  &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> start catalogue service <<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable catalogue  &>>/tmp/roboshop.log
systemctl restart catalogue  &>>/tmp/roboshop.log

