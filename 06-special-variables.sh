#!/bin/bash

# Special Variables are $0 to $9, $$, $*, $@, $#

echo "Printing Script Name : $0"   # $0 prints the script name

echo "First Argument is : $1 "
echo "Second Argument is : $2 "
echo "Third Argument is : $3 "

# bash  scriptName.sh firstArg secondArg thirdArg  ........ninthArg
#             $0         $1       $2        $3     ........$9

# you can provide more than 9 arguments, but suppose u have provided 10 arguments then 1st argument will be nullified from $1 
# and 10th argument will become $1, Likewise it will go for further 

echo "Total Number of Arguments are : $# "   # Prints the overall arguments used in the script 
echo "Exit Code of the last command is : $? "   # This prints the exit code of the last command
echo "Print all the arguments are used : $* "   # Prints all the arguments used.
echo "Print all the arguments are used : $@ "  # Prints all the arguments used.

# echo "Variables Used In The Script $*"    # $* is going to print the used variables  
# echo "Variabels used are $@"              # $@ is going to print the used variables  