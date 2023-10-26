#Basic 2 loops
# 1. for and 2. while

#Based on expression
a=10
while [ $a -gt 0 ]; do
  echo Hello
  a=$(($a-1))
  #break  come out of the loop
done

#Based on inputs
for comp in frontend user cart ; do
  echo Installing comp - $comp
done






