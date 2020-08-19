rm -f log
cat log_{1..180} > log
rm log_*
rm Run14.o* 
rm *~

source /opt/rh/devtoolset-2/enable 
source /home/software/root6/bin/thisroot.sh

target=acceptanceupsilon_Sampling1_0924  

hadd ${target}.root ${target}_*.root
mkdir output_bakeup
mv ${target}_*.root output_bakeup
