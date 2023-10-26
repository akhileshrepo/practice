a=10

echo A is $a

#special variables
# $0, $#, $N, $*

#substitution variables
## command substitution

DATE=$(date)

echo Today Date is $DATE

##arithemetic substitution
ADD=$(( 2+2 ))

echo add 2+2 is $ADD


##access environment variables
echo Username - $USER

echo Env Var abc - $abc  #adding env var

#It won't display until we export the abc=100
export abc=100

Then run the script we can able to see the Env Var








