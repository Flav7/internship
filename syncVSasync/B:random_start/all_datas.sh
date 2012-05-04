#!/bin/bash
for((j=0;j<31;j+=1))
do
	cd 'sample'$j
	touch gnuplotAsync
	touch gnuplotSync
	for((i=1;i<33;i+=1)) #lignes 1..9
	do
		suma=0
		sums=0
		echo -n -e $i"\t" >> gnuplotAsync
		for fic in `ls | grep :a`
		do
			echo -n `head -$i $fic | tail -1` >> gnuplotAsync
			echo -n -e "\t" >> gnuplotAsync
			suma=`echo "scale=20;$suma+$(head -$i $fic | tail -1)" | bc`
		done
		echo -n -e $i"\t" >> gnuplotSync
		for fic in `ls | grep :s`
		do
			echo -n `head -$i $fic | tail -1` >> gnuplotSync
			echo -n -e "\t" >> gnuplotSync
			sums=`echo "scale=20;$sums+$(head -$i $fic | tail -1)" | bc`
		done
		lsa=`ls | grep :a | wc -l`
		lss=`ls | grep :s | wc -l`
		#echo "scale=17;$suma/`ls | grep :a | wc -l`" | bc >> meanfileAsync.csv
		echo `echo "scale=17;$suma/$lsa" | bc` >> gnuplotAsync
		#echo "scale=17;$sums/`ls | grep :s | wc -l`" | bc >> meanfileSync.csv
		echo `echo "scale=17;$sums/$lss" | bc` >> gnuplotSync
	done
	cd ..
	echo $j
done


