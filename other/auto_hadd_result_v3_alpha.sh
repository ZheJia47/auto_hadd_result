#!/bin/bash

# setting target file name & how many jobs
target=(acceptanceupsilon_Sampling1_0924)
job_finished=1

# define function
func(){		
    for ((ijob=1; ijob<=job_finished; ijob=ijob+1))
    do
	if [ -f ${target[0]}_${ijob}.root ]; then
	    njob=njob+1	   
	    count=$(echo "scale=2; 100 * $njob/$job_finished"|bc -l)	   
	fi	
    done    

    echo "path: ${PWD}"
    echo "target: ${target}.root"    
    echo "$count% jobs are finished"
    echo "There are $njob finished files"
    echo "Total: $job_finished files"    
}

#  continuingly scan how many job finished 
while true
do
    declare -i njob=0
    count=0    
    func
    echo ""
    echo ""
    sleep 2

    declare -i njob=0
    count=0
    func
    echo ""
    echo ""
    echo ""
    
    # hadd result into one file
    if [ $njob == $job_finished ]; then
	#source /opt/rh/devtoolset-2/enable
	#source /home/software/root6/bin/thisroot.sh

	[ ! -d ./output_bakeup ] && mkdir output_bakeup
	mv log_* output_bakeup
	mv *.o* output_bakeup

	for ((i=0; i<=${#target[*]}; i=i+1)); do 
	    hadd ${target}.root ${target[i]}_*.root
	    mv ${target[i]}_*.root output_bakeup
	done

	# email
	[ -f email.txt ] && rm email.txt
	touch email.txt
	
	echo "Total $job_finished jobs are finished." >> email.txt
	for ((i=0; i<=${#target[*]}; i=i+1)); do 
	    echo "${target[i]}.root is completed and located at following path:" >> email.txt
	    echo "${PWD}/${target[i]}.root" >> email.txt
	done
	
	echo "Simply download the file by the command below:" >> email.txt
	
	for ((i=0; i<=${#target[*]}; i=i+1)); do 
	    echo "scp zjzhang@140.116.91.168:${PWD}/${target[i]}.root ." >> email.txt
	done
	# mail -s "Jobs from cluster is completed !!" -a ${target}.root xdxxxx4713@gmail.com < email.txt

	echo "Total $job_finished jobs are finished."
	for ((i=0; i<=${#target[*]}; i=i+1)); do 
	    echo "${target[i]}.root is completed and located at following path:" 
	    echo "${PWD}/${target[i]}.root"
	done
	
	echo "Simply download the file by the command below:"
	for ((i=0; i<=${#target[*]}; i=i+1)); do 
	echo "scp zjzhang@140.116.91.168:${PWD}/${target}.root ." 
	done
	
	break
    fi
    sleep 2
done
