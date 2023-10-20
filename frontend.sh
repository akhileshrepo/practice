source common.sh

echo -e "\e[36m>>>>>>>>>>> copying roboshop configuration <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.config /etc/nginx/default.d/roboshop.conf
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Install nginx <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nginx -y
func_exit_status

echo -e "\e[36m>>>>>>>>>>> clean the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
unzip /tmp/frontend.zip
func_exit_status

echo -e "\e[36m>>>>>>>>>>> start nginx service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx
systemctl restart nginx
func_exit_status