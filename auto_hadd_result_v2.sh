# For auto hadding results from different jobs when your jobs are finished.
# Please using screen then excuting this script.
# When jobs are finished, results from different jobs would auto hadded and sent an email to notice you the jobs are finished.
# author: Zhe-Jia Zhang <xdxxxx4713@gmail.com>
# 2019 November 11

#!/bin/bash
# setting target file name, how many jobs, your cluster address and your email address
target=DrellYan200GeV        # output file name
job_finished=100                       # total number of jobs
cluster_address=zjzhang@140.116.91.168 # your cluster address
email_address=xdxxxx4713@gmail.com     # your email address
#local_address=                        # if you want to recieve the result from your local device (Static IP)

# define function
func(){		
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
	# source /opt/rh/devtoolset-2/enable
	# source /home/software/root6/bin/thisroot.sh

	# [ ! -d ./output_bakeup ] && mkdir output_bakeup
	# mv log_* output_bakeup
	# mv *.o* output_bakeup
		
	# hadd ${target}.root ${target}_*.root
	# cat time_record/time_record_*.txt > time_record.txt
	# mv ${target}_*.root output_bakeup
	#rm *~

	# email
	[ -f email.txt ] && rm email.txt
	touch email.txt
	
	echo "Total $job_finished jobs are finished." >> email.txt
	# echo "${target}.root is completed and located at following path:" >> email.txt
	# echo "${PWD}/${target}.root" >> email.txt
	# echo "Simply download the file by the command below:" >> email.txt
	# echo "scp ${cluster_address}:${PWD}/${target}.root ." >> email.txt
	
	# mail -s "Jobs from cluster are completed !!" -a ${target}.root ${email_address} < email.txt
	mail -s "Jobs from cluster are completed !!" ${email_address} < email.txt

	echo "Total $job_finished jobs are finished."
	# echo "${target}.root is completed and located at following path:" 
	# echo "${PWD}/${target}.root" 
	# echo "Simply download the file by the belowing command line:" 
	# echo "scp ${cluster_address}:${PWD}/${target}.root ." 

	break
    fi
    sleep 2
done
