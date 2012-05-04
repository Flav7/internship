#!/bin/bash

ruby ../heartest.rb $*
if [ $? -eq 2 ] ; then
	echo "error 2"
	exit 1
else
	echo "good"
	exit 0
fi


