log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service  &>>${log}

echo -e "\e[36m>>>>>>>>>>> create Mongodb repo <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>> Install NodeJS repos <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>> Install Node js <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>> add app user <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>> cleaning the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>create app directory<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>> Extract app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip  &>>${log}
cd /app

echo -e "\e[36m>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>> Install Mongo client <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mongo --host 172.31.22.169 </app/schema/catalogue.js  &>>${log}

echo -e "\e[36m>>>>>>>>>>> start catalogue service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload  &>>${log}
systemctl enable catalogue  &>>${log}
systemctl restart catalogue  &>>${log}
