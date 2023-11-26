#!/bin/bash 

<<COMMENT
```
### Expressions are categorized in to three types and based on the expression, we need to use operators
```
    1. Numbers
    2. Strings
    3. Files
```

Operators on numbers:
```
    -eq is equal to, -ne is not equal to , 
    -gt is greater than, -ge is greater than equal to, 
    -lt is less than, -le is less than equal to

    [ 1 -eq 1 ] 
    [ 1 -ne 1 ]
```

Operators on Strings:


    = , == , !=

    [ abc = abc ]

    -z , -n 

    [ -z "$var" ] -> This is true if var is not having any data
    [ -n "$var" ] _> This is true if var is having any data

    -z and -n are inverse proportional options


Operators on files:
    Lot of operators are available and you can check them using man pages of bash 

    [ -f file ] -> True of file exists and file is a regular file 

    [ -d xyz ]  -> True if file exists and it is a directory

    ### Explore the file types, There are 7 types on files in Linux.


-b operator: This operator checks whether a file is a block special file or not. It returns true if the file is a block special file, otherwise returns false.
-c operator: This operator checks whether a file is a character special file or not. It returns true if it is a character special file otherwise returns false.
-c operator: This operator checks whether a file is a character special file or not. It returns true if it is a character special file otherwise returns false.
-e operator: This operator checks whether the given file exists or not. If it exists this operator returns true otherwise returns false.
-r operator: This operator checks whether the given file has read access or not. If it has read access then it returns true otherwise returns false.
-w operator: This operator checks whether the given file has write access or not. If it has write then it returns true otherwise returns false.
-x operator: This operator checks whether the given file has execute access or not. If it has execute access then it returns true otherwise returns false.
-s operator: This operator checks the size of the given file. If the size of given file is greater than 0 then it returns true otherwise it returns false.



COMMENT
