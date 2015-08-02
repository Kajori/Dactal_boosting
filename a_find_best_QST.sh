#!/bin/bash
#-------------------------------------------------------------------------------
# Filename : a_find_best_QST.sh
# Description :  Computes the best tree w.r.t. Quartet support score (QST score). It computes the QST score of each starting_tree_${basic_index}_L${loop} where ${loop} ranges from 0 to ${end_loop}. then it stores the best tree produced after each iteration as best_QST_${basic_index}_L${loop}.
# It reports the starting tree if it has the best QST score after all the iterations.
# best_QST_${basic_index}_L0 is always the starting tree
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs : sh a_find_best_QST.sh genetree basic_index  end_loop
#-------------------------------------------------------------------------------

#Java is need to run Astral
export JAVA_HOME=/projects/tallis/kbanerj3/tools/jdk1.7.0_79
export PATH=/projects/tallis/kbanerj3/tools/jdk1.7.0_79/bin:$PATH
AstralPATH=/projects/tallis/kbanerj3/astral/ASTRAL-master/Astral
set -x

genetree=$1
basic_index=$2
end_loop=$3

echo " Parameters are "
echo " gene_tree= ${genetree}"
echo " basic_index=${basic_index}"
echo " end_loop=${end_loop}"

loop=0
maxscore=-9999
max_index=-1
while [ ${loop} -lt ${end_loop}  ]; do
	echo " ************** " ${loop} " ************** "
	echo
	index=${basic_index}_L${loop}

	current_score=$(java -jar ${AstralPATH}/astral.4.7.8.jar -q starting_tree_${index} -i ${genetree} 2>&1 | tail -n1 | cut -f5 -d' ' )
	echo " current_score =  ${current_score}"
	val=$(echo "${current_score} >= ${maxscore} " | bc)
    echo " val =",{$val}
    if [ ${val} -eq 1 ]
    then
        maxscore=${current_score}
        max_index=${loop}
    fi

    echo " maxscore "${maxscore}
    echo ${maxscore} > max_score_QST_${index}
	cat starting_tree_${basic_index}_L${max_index}  > best_QST_${index}

	let loop=loop+1
done
