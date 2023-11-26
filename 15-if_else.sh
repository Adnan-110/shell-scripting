#!/bin/bash

echo -e "Demo if, if-else and else if usage \n"

ACTION=$1

if[ACTION == start] ; then
    echo -e "\e[31m Starting the Service \e[0m"
    exit 0
elif[ACTION == stop] ; then
    echo -e "\e[32m Stoping the Service \e[0m"
    exit 1
elif[ACTION == restart] ; then
    echo -e "\e[33m Restarting the Service \e[0m"
    exit 2
else
    echo -e "\e[34m Valid Options are start - stop - restart only \e[0m"
    exit 3
fi

