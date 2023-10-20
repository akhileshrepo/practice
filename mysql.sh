MYSQL_ROOT_PASSWORD-$1
if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
  echo Input password missing
  exit 1
fi



cp mysql.repo /etc/yum.repos.d/mysql.repo


dnf module disable mysql -y

dnf install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD}
mysql -uroot -pRoboShop@1