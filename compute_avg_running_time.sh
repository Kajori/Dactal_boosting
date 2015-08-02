#-------------------------------------------------------------------------------
# File :  compute_avg_running_time.sh
# Description :  It coputes the average running time of the starting tree and aso the average runnning time
# of the loops.
# Author :  Kajori Banerjee
#
#-------------------------------------------------------------------------------
# Inputs :
# sh compute_avg_running_time.sh ${end_replicate} ${end_loop} ${basic_index_string} ${output_filename}
#-------------------------------------------------------------------------------

end_replicate=$1
end_loop=$2
basic_index_string=$3
filename=$4

rm  ${filename}
sum=0
count=0
loop=0
r=1
while [ ${r} -lt ${end_replicate} ]; do
	echo " r=${r}"
	basic_index=${basic_index_string}-R${r}
	run_time=$(cat runtime_st_astrid_${basic_index}_L${loop})
  let sum=sum+run_time
	let r=r+1
	let count=count+1
done
let avg=sum/count
echo " Average running time of ASTRID starting tree = ",${avg}  >> ${filename}

sum=0
count=0
loop=1
while [ ${loop} -lt ${end_loop} ]; do
      r=1
			while [ ${r} -lt ${end_replicate} ]; do
        echo " r=${r}"
        basic_index=${basic_index_string}-R${r}
        cat runtime_loop_${basic_index}_L${loop}
        run_time=$(cat runtime_loop_${basic_index}_L${loop})

        #echo "run_tim",${run_time}
        let sum=sum+run_time
        let r=r+1
        let count=count+1
			done
			let loop=loop+1
done
let avg=sum/count
echo " avg running time of for each iteration",${avg} >> ${filename}
