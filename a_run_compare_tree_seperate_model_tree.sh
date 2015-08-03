#!/bin/bash
#-------------------------------------------------------------------------------
# Filename : a_run_compare_tree_seperate_model_tree.sh
# Description :  Used for Astral-2 datatset where there is a seperate model tree for each replicate. Computes the FN and FP rate of the trees produced in each iteration and also the best_QST and best_LL tree produced after each iteration.  where ${loop} ranges from 0 to ${end_loop}. Then it stores the FN and FP  of the all the trees produced after each iteration ${loop} as st_ASTRID_FN_QST_ms_${ms}_p_${p}_L${loop}  and st_ASTRID_FP_QST_ms_${ms}_p_${p} respectively where ms =maximum subset size and p = padding size
#
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs : sh  a_run_compare_tree_seperate_model_tree.sh  end_replicate  end_loop ms p basic_index_string model_tree_path
#-------------------------------------------------------------------------------


set -x
export PATH=/projects/tallis/kbanerj3/tools/Python-2.7.10/build/bin:$PATH


############################### FN rate for plotting ADSTRID as the starting tree ###############################

end_replicate=$1
end_loop=$2
ms=$3
p=$4
basic_index_string=$5
model_tree_path=$6

rm output.txt

#flag =1 means we want to plot the FN rates of the trees produced in each iteration
#flag =2 means we want to plot the FN rates of the best QST trees produced in each iteration
filename=( st_ASTRID_FN_QST_ms_${ms}_p_${p} st_ASTRID_FN_best_QST_ms_${ms}_p_${p} )
filename2=( st_ASTRID_FP_QST_ms_${ms}_p_${p} st_ASTRID_FP_best_QST_ms_${ms}_p_${p} )

i=0
while [ ${i} -lt echo ${#filename[@]}  ];do
    loop=0
    while [ ${loop} -lt ${end_loop} ];do
        rm ${filename[${i}]}_L${loop}
        r=1
        while [ ${r} -lt ${end_replicate} ]; do
            echo " loop = ${loop} r= ${r}"
            basic_index=${basic_index_string}-R${r}
            index=${basic_index}_L${loop}
            if [ ${i} -eq 0 ]
            then
                echo " using starting tree "
                estimated_tree=starting_tree_${index}
            else
                echo " using best_QST_ "
                estimated_tree=best_QST_${index}
            fi


            rm model_tree_${index}
            cp ${model_tree_path}/${r}/s_tree.trees model_tree_${index}
            python remove_branch_length.py  model_tree_${index}


            sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  ${model_tree_${index}} ${estimated_tree}
            sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  ${model_tree_${index}} ${estimated_tree}  >> ${filename[${i}]}_L${loop}


            sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  ${estimated_tree} ${model_tree_${index}}   >> ${filename2[${i}]}_L${loop}

            rm model_tree_${index}
            let r=r+1
        done
        let loop=loop+1
        echo "                  loop = loop +1 "
    done
    let i=i+1
done
