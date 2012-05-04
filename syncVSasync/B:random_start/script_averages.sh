#!/bin/bash
for((j=0;j<31;j+=1))
do
	cd 'sample'$j
	touch meanfileAsync.csv
	touch meanfileSync.csv
	for((i=1;i<33;i+=1)) #lignes 1..9
	do
		suma=0
		sums=0
		for fic in `ls | grep :a`
		do
			#sum+=$(head -$i $fic | tail -1)
			suma=`echo "scale=20;$suma+$(head -$i $fic | tail -1)" | bc`
		done
		for fic in `ls | grep :s`
		do
			#sum+=$(head -$i $fic | tail -1)
			sums=`echo "scale=20;$sums+$(head -$i $fic | tail -1)" | bc`
		done
		lsa=`ls | grep :a | wc -l`
		lss=`ls | grep :s | wc -l`
		#echo "scale=17;$suma/`ls | grep :a | wc -l`" | bc >> meanfileAsync.csv
		echo -n `echo "scale=17;$suma/$lsa" | bc` >> meanfileAsync.csv ;  echo  " ," >> meanfileAsync.csv
		#echo "scale=17;$sums/`ls | grep :s | wc -l`" | bc >> meanfileSync.csv
		echo -n `echo "scale=17;$sums/$lss" | bc` >> meanfileSync.csv ;  echo  " ," >> meanfileSync.csv
	done
	cd ..
	echo $j
done


