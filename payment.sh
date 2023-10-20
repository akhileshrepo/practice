component=payment
source common.sh

rabbitmq_password-$1
if [ -z "${rabbitmq_password}" ]; then
  echo rabbitmq appuser password missing
  exit 1
fi


func_python