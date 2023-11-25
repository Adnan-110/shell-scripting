#!/bin/bash 

# This is a single line comment 

# Below is an example of multi line comment

<<COMMENT
echo "Cloud DevOps Training"
echo "Shall Scripting"
a=100
b=300
echo $a
COMMENT 
echo "Value of b is $b"


# we can comment on multiple lines using << and name of comment.  
#we start a comment block with << and name anything to the block and wherever we want to stop the comment, we will simply type the name of the comment.
#The word COMMENT can be anything but it should be the same for ending the comment block.

