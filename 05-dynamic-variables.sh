#!/bin/bash

 
# Dynamic Variable are something which will have linux command stored on them.
# Example below


DATE=$(date +%x)    #Here $() is syntax and inside them we have written date cmd of linux with option %x and + we use when we want to use option which starts with % or maybe anyother which I don't know yet

echo -e "Good Morning, Today's date is \e[32m $DATE \e[0m"

NO_OF_SESSION=$(who|wc -l)      #Here who cmd show the active sessions and when we use that wc -l it will return the count of line 

echo -e "Total Number of Connected Sessions : \e[32m $NO_OF_SESSION \e[0m"