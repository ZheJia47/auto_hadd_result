#!/bin/bash

# setting target file name & how many jobs
target=acceptanceupsilon_Sampling1_0924
job_finished=3

#  continuingly scan how many job finished 
while true
do    
    declare -i njob=0
    count=0
    
    for ((ijob=1; ijob<=job_finished; ijob=ijob+1))
    do
	if [ -f ${target}_${ijob}.root ]; then
	    njob=njob+1	   
	    count=$(echo "scale=2; 100 * $njob/$job_finished"|bc -l)	   
	fi	
    done    

    echo "path: ${PWD}"
    echo "target: ${target}.root"    
    echo "$count% jobs are finished"
    echo "There are $njob finished files"
    echo "Total: $job_finished files"
    echo ""
    echo ""
    sleep 2

    declare -i njob=0
    count=0
    for ((ijob=1; ijob<=job_finished; ijob=ijob+1))
    do
	if [ -f ${target}_${ijob}.root ]; then
	    njob=njob+1	   
	    count=$(echo "scale=2; 100 * $njob/$job_finished"|bc -l)	   
	fi	
    done    

    echo "path: ${PWD}"
    echo "target: ${target}.root"    
    echo "$count% jobs are finished"
    echo "There are $njob finished files"
    echo "Total: $job_finished files"
    echo ""
    echo ""
    echo ""

    # email how many percent finished
    #a1=$(echo "scale=0; 100 * $njob/$job_finished"|bc -l)
    #if [ $a1 >= 25 ] && [ $a1 <= 50 ]; then
#	if [ -f email.txt ]; then
#	    rm email.txt
#	fi
#	touch email.txt
#	echo "There are $njob finished files" >> email.txt
#	echo "Total: $job_finished files" >> email.txt
#	echo "Target is ${target}.root located at following path:" >> email.txt
#	echo "${PWD}/${target}.root" >> email.txt
	
    #	mail -s "$count% jobs are finished" xdxxxx4713@gmail.com < email.txt
    #   break
 #   fi
   
    # hadd result into one file
    if [ $njob == $job_finished ]; then
	#source /opt/rh/devtoolset-2/enable
	#source /home/software/root6/bin/thisroot.sh

	mkdir output_bakeup
	mv log_* output_bakeup
	mv Run14.o* output_bakeup
	mv Run16.o* output_bakeup
		
	hadd ${target}.root ${target}_*.root
	mv ${target}_*.root output_bakeup
	rm *~

	# email
	if [ -f email.txt ]; then
	    rm email.txt
	fi
	touch email.txt
	
	echo "Total $job_finished jobs are finished." >> email.txt
	echo "${target}.root is completed and located at following path:" >> email.txt
	echo "${PWD}/${target}.root" >> email.txt
	echo "Simply download the file by the command below:" >> email.txt
	echo "scp zjzhang@140.116.91.168:${PWD}/${target}.root ." >> email.txt
	
	mail -s "Jobs from cluster is completed !!" -a ${target}.root xdxxxx4713@gmail.com < email.txt

	break
    fi
    sleep 2
done
