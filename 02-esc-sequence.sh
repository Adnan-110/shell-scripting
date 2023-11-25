#! /bin/shell

echo Welcome To Shell Scripting 
echo "This is Day 1 of our Shell Scripting"

#Escape sequence characters 
#\n : New Line
#\t : Tab Space
#Whenever we want to enable escape sequence character in string we need to use -e with the echo
#Whenever you're using escape sequence characters, always enclose them in DOUBLE QUOTES 
#" " : Double Quotes 
#''  : Single Quotes
echo Before
echo !!!!!!!!
echo "Line1\nLine2"
echo Line3
echo Line4
echo !!!!!!!!

echo After
echo !!!!!!!!
echo -e "Line1 \n Line2"
echo Line3
echo -e "Line4\tLine5"
echo Line6
echo !!!!!!!!
