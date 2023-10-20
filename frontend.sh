source common.sh

echo -e "\e[36m>>>>>>>>>>> copying roboshop configuration <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.config /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Install nginx <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>> clean the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
cd /usr/share/nginx/html &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
unzip /tmp/frontend.zip &>>${log}
vim /etc/nginx/default.d/nginx-roboshop.config
func_exit_status

echo -e "\e[36m>>>>>>>>>>> start nginx service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx  &>>${log}
systemctl restart nginx  &>>${log}
func_exit_status