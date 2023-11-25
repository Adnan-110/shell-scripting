#!/bin/bash

 
# Dynamic Variable are something which will have linux command stored on them.
# Example below


DATE=$(date +%x)    #Here $() is syntax and inside them we have written date cmd of linux with option %x and + we use when we want to use option which starts with % or maybe anyother which I don't know yet

echo "Good Morning, Today's date is $DATE"
