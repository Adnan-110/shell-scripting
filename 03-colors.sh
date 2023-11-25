#!/bin/bash

#Each and every color you see on terminal will have a color code and we need to use that code based on our need.

# Colors       Foreground          Background
# Red              31                  41
# Green            32                  42
# Yellow           33                  43
# Blue             34                  44
# Magenta          35                  45
# Cyan             36                  46

#Syntax to print COLORS is :

#echo -e "\e[COLORCODEm I am printing colored text\e[0m"

echo -e "\e[31m I am printing Red colored text\e[0m"
echo -e "\e[32m I am printing Green colored text\e[0m"
echo -e "\e[33m I am printing Yellow colored text\e[0m"
echo -e "\e[34m I am printing Blue colored text\e[0m"
echo -e "\e[35m I am printing Magenta colored text\e[0m"
echo -e "\e[36m I am printing Cyan colored text\e[0m"

echo -e "\n\n\n"

# Background + Foreground

echo -e "\e[43;34m I am printing text with Yellow color in background and Blue in foreground\e[0m"

