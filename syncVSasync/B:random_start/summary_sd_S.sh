#!/bin/bash
touch summary_sd_S
for((i=1;i<33;i+=1)) #lignes 1..9
do
	sum=0
	mean=0
	va=0
	for((j=0;j<31;j+=1)) 
	do
		cd 'sample'$j
		sum=`echo "scale=20;$sum+$(head -$i sd_S | tail -1)" | bc`
		cd ..
	done
	mean=`echo "scale=20;$sum/31" | bc`

	for((j=0;j<31;j+=1)) 
	do
		tmp=0
		cd 'sample'$j
		tmp=`echo $(head -$i sd_S | tail -1)`
		tmp=`echo "scale=20;$tmp-$mean" | bc`
		tmp=`echo "scale=20;$tmp*$tmp" | bc`
		va=`echo "scale=20;$va+$tmp" | bc`
		cd ..
	done
	
	va=`echo "scale=17;$va/31" | bc`
	sda=`echo "scale=17;sqrt($va)" | bc`
	echo -e -n $i"\t" >> summary_sd_S
	echo -e -n $mean"\t" >> summary_sd_S
	echo $sda >> summary_sd_S
	
	echo $i
done


