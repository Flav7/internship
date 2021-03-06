#!/bin/bash

########################################################################
## @autor : Flavien Bailly					      ##
## @date   : June 2012						      ##
##								      ##
## This script initialize a network. It uses correct URI to add       ##
## neighbors to nodes. Here is a picture of the network :	      ##
##								      ##
##				F				      ##
##                             / \       			      ##
##			      /   \				      ##
##			     D-----E     			      ##
##			      \   /				      ##
##			       \ /				      ##
##				C				      ##
##			       / \				      ##
##			      /   \				      ##
##			     A     B				      ##
##								      ##
########################################################################


#A 2222
wget -O trash_file localhost:2222/neighbor/add/C/4444

#B 3333
wget -O trash_file localhost:3333/neighbor/add/C/4444
i
#C 4444
wget -O trash_file localhost:4444/neighbor/add/A/2222
wget -O trash_file localhost:4444/neighbor/add/B/3333
wget -O trash_file localhost:4444/neighbor/add/D/5555
wget -O trash_file localhost:4444/neighbor/add/E/6666

#D 5555
wget -O trash_file localhost:5555/neighbor/add/C/4444
wget -O trash_file localhost:5555/neighbor/add/E/6666
wget -O trash_file localhost:5555/neighbor/add/F/7777

#E 6666
wget -O trash_file localhost:6666/neighbor/add/C/4444
wget -O trash_file localhost:6666/neighbor/add/D/5555
wget -O trash_file localhost:6666/neighbor/add/F/7777

#F 7777
wget -O trash_file localhost:7777/neighbor/add/D/5555
wget -O trash_file localhost:7777/neighbor/add/E/6666
