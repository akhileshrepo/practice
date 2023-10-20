greeting() {
  echo Hello Good Morning,
  echo Hello Devops Trainers
  return
  echo Im a Good learner
}

greeting
echo Function exit status - $?

# You declare the var in main programme, we can access it from functions and vice-versa
# functions has its own special variables

input() {
  echo First Argument - $1
  echo First Argument - $2
  echo All arguments - $*
  echo No of arguments - $#
}
input abc 1234


