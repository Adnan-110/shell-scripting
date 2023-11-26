#!/bin/bash

# Loops : When you want to run an action for certain number of times, we use loops.

# There are 2 major types of loops ; 
#     1) For loop       ( When you know something to be executed n number of time, we use for loop)
#     2) While loop     ( When you don't know something to be executed n number of times, we use while loop)

# echo Value is 10
# echo Value is 20 
# echo Value is 30
# echo Value is 40
# echo Value is 50 

# for loop syntax 
for i in 10 20 30 40 50 ; do 
    echo "Vaules from the loops are $i"
done    

<<COMMENT
while [ condition ];
do
    # statements
    # commands
done

#!/bin/bash  
#Script to get specified numbers  
  
read -p "Enter starting number: " snum  
read -p "Enter ending number: " enum  
  
while [[ $snum -le $enum ]];  
do  
echo $snum  
((snum++))  
done  
  
echo "This is the sequence that you wanted."  

until [ expression ];  
do  
command1  
command2  
. . .  
. . . .   
commandN  
done  


i=1  
until [ $i -gt 10 ]  
do  
echo $i  
((i++))  
done  

COMMENT
