#!/bin/bash

#A
wget -O trash_file localhost:2222/neighbor/add/C/4444

#B
wget -O trash_file localhost:3333/neighbor/add/C/4444

#C
wget -O trash_file localhost:4444/neighbor/add/A/2222
wget -O trash_file localhost:4444/neighbor/add/B/3333
wget -O trash_file localhost:4444/neighbor/add/D/5555
wget -O trash_file localhost:4444/neighbor/add/E/6666

#D
wget -O trash_file localhost:5555/neighbor/add/C/4444
wget -O trash_file localhost:5555/neighbor/add/E/6666
wget -O trash_file localhost:5555/neighbor/add/F/7777

#E
wget -O trash_file localhost:6666/neighbor/add/C/4444
wget -O trash_file localhost:6666/neighbor/add/D/5555
wget -O trash_file localhost:6666/neighbor/add/F/7777

#F
wget -O trash_file localhost:7777/neighbor/add/D/5555
wget -O trash_file localhost:7777/neighbor/add/E/6666
