log=/tmp/roboshop.log
func_apppreq() {
  echo -e "\e[36m>>>>>>>>>>> create ${component} service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>>>> add app user <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  useradd roboshop &>>${log}

  echo -e "\e[36m>>>>>>>>>>> cleaning the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  rm -rf /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>>create app directory<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mkdir /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  echo -e "\e[36m>>>>>>>>>>> Extract app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cd /app
  unzip /tmp/${component}.zip  &>>${log}
  cd /app
}

func_systemD() {
  echo -e "\e[36m>>>>>>>>>>> start user service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  systemctl daemon-reload  &>>${log}
  systemctl enable ${component}  &>>${log}
  systemctl restart ${component}  &>>${log}
}

func_schema_setup() {
  if [ "${schema_setup}" == "mongodb"]; then
    echo -e "\e[36m>>>>>>>>>>> Install Mongodb client <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    dnf install mongodb-org-shell -y &>>${log}

    echo -e "\e[36m>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host 172.31.20.41 </app/schema/${component}.js  &>>${log}
  fi

  if [ "${schema_setup}" == "mysql"]; then
      echo -e "\e[36m>>>>>>>>>>> Install Mysql client <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      dnf install mysql -y &>>${log}

      echo -e "\e[36m>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      mysql -h 172.31.31.50 -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  fi
}

func_nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>> create Mongodb repo <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>>>> Install NodeJS repos <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>>>>> Install Node js <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install nodejs -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}

  func_schema_setup

  func_systemD
}

func_java() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>> Install Maven <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install maven -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>> Download Maven dependencies <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

  func_schema_setup

  func_systemD
}

func_python() {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>>>>> Build ${component}  service<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install python36 gcc python3-devel -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>> Install ${component} service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  pip3.6 install -r requirements.txt &>>${log}

  func_systemD

}