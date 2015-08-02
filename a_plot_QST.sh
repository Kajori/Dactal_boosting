#!/bin/bash
#-------------------------------------------------------------------------------
# Filename : a_plot_QST.sh
# Description :  Computes the Quartet support score (QST score) of the trees produced in each iteration.  where ${loop} ranges from 0 to ${end_loop}. Then it stores the QST score of the all the trees produced after each iteration ${loop} as st_ASTRID_QST_ms_${ms}_p_${p}_L${loop} where ms =maximum subset size and p = padding size
#
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs : sh a_plot_QST.sh end_replicate  end_loop ms p basic_index_string
#-------------------------------------------------------------------------------

#set -x
export PATH=/home/kbanerj3/tools/installed/python2.7/bin:$PATH
export JAVA_HOME=/projects/tallis/kbanerj3/tools/jdk1.7.0_79
export PATH=/projects/tallis/kbanerj3/tools/jdk1.7.0_79/bin:$PATH
AstralPATH=/projects/tallis/kbanerj3/astral/ASTRAL-master/Astral

end_replicate=$1
end_loop=$2
ms=$3
p=$4
basic_index_string=$5

echo " Parameters are "
echo " end_replicate = ${end_replicate}"
echo " end_loop=${end_loop}"
echo "ms=${ms}"
echo "p=${p}"
echo "basic_index_string=${basic_index_string}"

set -x
rm st_ASTRID_QST_ms*

loop=0
while [ ${loop} -lt ${end_loop}  ]; do
	echo " ************** " ${loop} " ************** "
	echo
	r=1
	while [ ${r} -lt ${end_replicate}  ]; do
	    echo " r = "${r}
	    basic_index=${basic_index_string}-R${r}
      genetree=gene_tree_${basic_index}
	    index=${basic_index}_L${loop}

	    current_score=$(java -jar ${AstralPATH}/astral.4.7.8.jar -q starting_tree_${index} -i ${genetree} 2>&1 | tail -n1 | cut -f5 -d' ' )
	    echo ${current_score}
      echo ${current_score} >> st_ASTRID_QST_ms_${ms}_p_${p}_L${loop}
      let r=r+1
	done
	let loop=loop+1
done
