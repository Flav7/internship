#!/bin/bash
#param 1 : dossier parent des rep sampleX
#cd $1
#ls
echo "********************************************"
for((i=0;i<31;i+=1))
do
	cd sample$i
	echo "*** sample "$i" ***"
	for fic in `ls | grep metric`
	do
		nbl=`cat $fic | wc -l`
		#declare -i nbl
		#test $nbl -eq 32
		if [ $nbl -eq 32 ] ; then
			echo $fic" is good"
		else
			echo $fic" : WOOOOOOOOOOOOOOOT"
		fi
	done
	cd ..
done

echo "j'ai fini le boulot !"

#str=`cat metric\:f\(x\)\=x\*\*7-77_start\:42_node\:6_mode\:a | wc -l`
