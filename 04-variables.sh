#!/bin/bash

# What is Variable?
# A variable is something that holds data dynamically

# The advantage & disadvantage in shell is that there are no Data types.
# In bash everything will be considered as string by default.

a=10
b=Ten

# How can we print a variable in scripting ?
# To print a variable u need to start with a $ sign.
# Example below 

echo printing the value of a : $a           # ${a} and $a both are same.
echo printing the value of b : ${b}         # ${b} and $b both are same.

# If you dont declare the variable and try to print it, that will print empty string/ null
# Example below

echo printing the value of c : $c

# Advantage is that it won't throw any error but there is advantage of this functionaltiy as well

#For example if run below command, since there is no CUSTDATA variable declared it will delete the prod directory

#rm -rf /data/prod/${CUSTDATA}  

#in above case the above command is similar to rm -rf /data/prod/
