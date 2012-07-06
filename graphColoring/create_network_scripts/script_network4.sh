#!/bin/bash

#A 2222 
wget -O trash_file localhost:2222/neighbor/add/B/3333
wget -O trash_file localhost:2222/neighbor/add/C/4444
wget -O trash_file localhost:2222/neighbor/add/F/7777

#B 3333
wget -O trash_file localhost:3333/neighbor/add/A/2222
wget -O trash_file localhost:3333/neighbor/add/G/8888
wget -O trash_file localhost:3333/neighbor/add/H/9999

#C 4444
wget -O trash_file localhost:4444/neighbor/add/A/2222
wget -O trash_file localhost:4444/neighbor/add/D/5555
wget -O trash_file localhost:4444/neighbor/add/I/11111

#D 5555
wget -O trash_file localhost:5555/neighbor/add/C/4444
wget -O trash_file localhost:5555/neighbor/add/E/6666
wget -O trash_file localhost:5555/neighbor/add/H/9999

#E 6666
wget -O trash_file localhost:6666/neighbor/add/D/5555
wget -O trash_file localhost:6666/neighbor/add/F/7777
wget -O trash_file localhost:6666/neighbor/add/G/8888

#F 7777
wget -O trash_file localhost:7777/neighbor/add/A/2222
wget -O trash_file localhost:7777/neighbor/add/E/6666
wget -O trash_file localhost:7777/neighbor/add/J/11222

#G 8888
wget -O trash_file localhost:8888/neighbor/add/B/3333
wget -O trash_file localhost:8888/neighbor/add/E/6666
wget -O trash_file localhost:8888/neighbor/add/I/11111

#H 9999
wget -O trash_file localhost:9999/neighbor/add/B/3333
wget -O trash_file localhost:9999/neighbor/add/D/5555
wget -O trash_file localhost:9999/neighbor/add/J/11222

#I 11111
wget -O trash_file localhost:11111/neighbor/add/C/4444
wget -O trash_file localhost:11111/neighbor/add/G/8888
wget -O trash_file localhost:11111/neighbor/add/J/11222

#J 11222
wget -O trash_file localhost:11222/neighbor/add/F/7777
wget -O trash_file localhost:11222/neighbor/add/H/9999
wget -O trash_file localhost:11222/neighbor/add/I/11111
