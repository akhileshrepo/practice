cp user.service /etc/systemd/system/user.service

cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
dnf install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app
npm install

dnf install mongodb-org-shell -y
mongo --host 172.31.30.75 </app/schema/user.js

systemctl daemon-reload
systemctl enable user
systemctl restart user

