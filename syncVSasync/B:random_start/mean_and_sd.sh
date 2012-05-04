#!/bin/bash
for((j=0;j<31;j+=1))
do
	cd 'sample'$j
	touch mean_A
	touch mean_S
	touch sd_A
	touch sd_S
	for((i=1;i<33;i+=1)) #lignes 1..9
	do
		suma=0
		sums=0
		ma=0
		ms=0
		va=0
		vs=0
		sda=0
		sds=0
		lsa=`ls | grep :a | wc -l`
		lss=`ls | grep :s | wc -l`
		#echo -n -e $i"\t" >> mean_A
		for fic in `ls | grep :a`
		do
			suma=`echo "scale=20;$suma+$(head -$i $fic | tail -1)" | bc`
		done
		#echo -n -e $i"\t" >> mean_sd_S
		for fic in `ls | grep :s`
		do
			sums=`echo "scale=20;$sums+$(head -$i $fic | tail -1)" | bc`
		done
		ma=`echo "scale=17;$suma/$lsa" | bc`
		ms=`echo "scale=17;$sums/$lss" | bc`
		#echo -n -e $ma"\t" >> mean_A
		#echo -n -e $ms"\t" >> mean_sd_S
		echo $ma >> mean_A
		echo $ms >> mean_S
		
		for fic in `ls | grep :a`
		do
			tmp=0
			tmp=`echo $(head -$i $fic | tail -1)`
			tmp=`echo "scale=20;$tmp-$ma" | bc`
			tmp=`echo "scale=20;$tmp*$tmp" | bc`
			va=`echo "scale=20;$va+$tmp" | bc`
		done
		va=`echo "scale=17;$va/$lsa" | bc`
		sda=`echo "scale=17;sqrt($va)" | bc`
		echo $sda >> sd_A
		
		for fic in `ls | grep :s`
		do
			tmp=0
			tmp=`echo $(head -$i $fic | tail -1)`
			tmp=`echo "scale=20;$tmp-$ms" | bc`
			tmp=`echo "scale=20;$tmp*$tmp" | bc`
			vs=`echo "scale=20;$vs+$tmp" | bc`
		done
		vs=`echo "scale=17;$vs/$lss" | bc`
		sds=`echo "scale=17;sqrt($vs)" | bc`
		echo $sds >> sd_S
	done
	cd ..
	echo $j
done


