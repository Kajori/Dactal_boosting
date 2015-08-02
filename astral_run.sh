#-------------------------------------------------------------------------------
# File : astral_run
#used to run only Astral on the datatset
# It also computes the Quartet support score, FN and FP rates of the trees produced and stores then in the file computes the Astral_QST, Astral_FN and Astral_FP respectively.
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs :
# sh astral_run.sh
#-------------------------------------------------------------------------------

r=1
ils=MC1 #DATASET
num_replicates=5


#simulated mammalian - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/simulated_mammalian/${ils}-200-500
#model_tree=/projects/tallis/kbanerj3/dataset/simulated_mammalian/simmulated_mammalian_model.tree
#basic_index_string=${ils}-200-500

#avian - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/avian/${ils}-200-500
#model_tree=/projects/tallis/kbanerj3/dataset/avian/avian-model-species.tre
#basic_index_string=${ils}-200-500

#15taxa - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/15-taxa/50gt-100bp
#model_tree=/projects/tallis/kbanerj3/dataset/15-taxa/15-taxa_mode_species_tree
#basic_index_string=50gt-500bp

#Astral2 - MC1 - DATASET
genetreePATH=/projects/tallis/kbanerj3/dataset/Astral-2/MC1-200-taxa-50gt
model_tree=/projects/tallis/kbanerj3/dataset/Astral-2/true-specis-trees/MC1-model.200.500000.0.000001
basic_index_string=${ils}-200-50gt

#export java for ASTRAL
export JAVA_HOME=/projects/tallis/kbanerj3/tools/jdk1.7.0_79
export PATH=/projects/tallis/kbanerj3/tools/jdk1.7.0_79/bin:$PATH

export LD_LIBRARY_PATH=/projects/tallis/kbanerj3/tools/libc/glibc-2.14/build:$LD_LIBRARY_PATH

AstralPATH=/projects/tallis/kbanerj3/astral/ASTRAL-master/Astral
ScriptsPATH=/projects/tallis/kbanerj3/dactal/dactal_scripts
sh ${ScriptsPATH}/blank.sh
sh ${ScriptsPATH}/blank.sh

let end_loop=num_loop+1
let end_replicate=num_replicates+1

set -x
rm Astral_QST Astral_FN  Astral_FP
total_runtime=0
#simulated mammalian - DATASET
#python ${ScriptsPATH}/compute_gene_tree_0.2XILS.py ${genetreePATH}/

while [ $r -lt ${end_replicate} ];do
    #preparing gene tree
    echo " %%%%%%%%%%%%%%%%%%%%%% r= " ${r} " ************** "

    basic_index=${basic_index_string}-R${r}
    rm gene_tree_${basic_index} #DO NOT this for the simulated mammalian - DATASET


    #DATASET dependent - change the file path inside compute_gene_tree_list.py depending on the dataset
    #python ${ScriptsPATH}/compute_gene_tree_list.py ${genetreePATH}/R${r} gene_tree_${basic_index}
    cp ${genetreePATH}/${r}/estimatedgenetre gene_tree_${basic_index} #for Astral 2 dataset

    start_astral=`date +%s`
    java -jar ${AstralPATH}/astral.4.7.8.jar -i gene_tree_${basic_index} -o astral_tree_${basic_index} &> xyz.txt
	end_astral=`date +%s`
    let total_runtime=total_runtime+$((end_astral-start_astral))


    current_score=$(java -jar ${AstralPATH}/astral.4.7.8.jar -q astral_tree_${basic_index} -i gene_tree_${basic_index} 2>&1 | tail -n1 | cut -f5 -d' ' )

	echo ${current_score}
    echo ${current_score} >> Astral_QST

     # DATASET - Astral 2
    #start
    if [ $r -lt 10 ]
   then
        R=0${r}
    else
        R=${r}
    fi
    model_tree_path=${model_tree}
    cp ${model_tree_path}/${R}/s_tree.trees model_tree_${basic_index}
    python ${ScriptsPATH}/remove_branch_length.py  model_tree_${basic_index}
    model_tree=model_tree_${basic_index}
    #end

    sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  ${model_tree} astral_tree_${basic_index}
    sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  ${model_tree} astral_tree_${basic_index}  >> Astral_FN

    sh /projects/tallis/kbanerj3/tools/compare_FN/compareTrees.missingBranch  astral_tree_${basic_index}  ${model_tree}  >> Astral_FP
   let r=r+1
done

let avg=total_runtime/num_replicates
echo " Average runtime ${avg}" > runtime_info
