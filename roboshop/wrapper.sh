#!/bin/bash

#bash components/frontend.sh

bash components/$1.sh

# if [ $? -ne 0 ] ; then
#     echo -e "\e[36m Example Usage : \e[0m bash wrapper.sh componentName"
#     exit 30
# fi

