r=1
num_loop=2
ils=1X #DATASET
num_replicates=5
max_subset_size=35
p=1

#simulated mammalian - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/simulated_mammalian/${ils}-200-500
#model_tree=/projects/tallis/kbanerj3/dataset/simulated_mammalian/simmulated_mammalian_model.tree
#basic_index_string=${ils}-200-500

#Astral 2 - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/Astral-2/MC1-200-taxa-50gt
#model_tree=/projects/tallis/kbanerj3/dataset/Astral-2/true-specis-trees/MC1-model.200.500000.0.000001
#basic_index_string=${ils}-200-50gt #200 taxa

#avian - DATASET
genetreePATH=/projects/tallis/kbanerj3/dataset/avian/${ils}-200-500
model_tree=/projects/tallis/kbanerj3/dataset/avian/avian-model-species.tre
basic_index_string=${ils}-200-500

#15taxa - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/15-taxa/50gt-100bp
#model_tree=/projects/tallis/kbanerj3/dataset/15-taxa/15-taxa_mode_species_tree
#basic_index_string=50gt-500bp

#Astral2 - MC1 - DATASET
#genetreePATH=/projects/tallis/kbanerj3/dataset/Astral-2/MC1-200-taxa-50gt
#model_tree=/projects/tallis/kbanerj3/dataset/Astral-2/true-specis-trees/MC1-model.200.500000.0.000001
#basic_index_string=${ils}-200-50gt 

ScriptsPATH=/projects/tallis/kbanerj3/dactal/dactal_scripts
sh ${ScriptsPATH}/blank.sh
sh ${ScriptsPATH}/blank.sh


let end_loop=num_loop+1
let end_replicate=num_replicates+1

set -x
#simulated mammalian - DATASET
#python ${ScriptsPATH}/compute_gene_tree_0.2XILS.py ${genetreePATH}/
    
while [ $r -lt ${end_replicate} ];do
    #preparing gene tree
    echo " %%%%%%%%%%%%%%%%%%%%%% r= " ${r} " ************** "
    
    basic_index=${basic_index_string}-R${r} 
    rm gene_tree_${basic_index} #DO NOT this for the simulated mammalian - DATASET

    #DATASET dependent - change the file path inside compute_gene_tree_list.py depending on the dataset
    python ${ScriptsPATH}/compute_gene_tree_list.py ${genetreePATH}/R${r} gene_tree_${basic_index}
    #cp ${genetreePATH}/${r}/estimatedgenetre gene_tree_${basic_index} #for Astral 2 dataset
    
    sh ${ScriptsPATH}/a_st_ASTRID.sh gene_tree_${basic_index} ${basic_index} ${end_loop} ${max_subset_size} ${p} &> output_avian_${basic_index}
	
	#finds the tree with the best QST score and stores it as   best_QST_${index} where  index=${basic_index}_L${loop}
	sh ${ScriptsPATH}/a_find_best_QST.sh gene_tree_${basic_index} ${basic_index} ${end_loop}
	
	
	let r=r+1
done


#finds the QST score for each starting tree and plots them in the file -  st_ASTRID_QST_ms_${ms}_p_${p}_L${loop}
sh ${ScriptsPATH}/a_plot_QST.sh ${end_replicate} ${end_loop} ${max_subset_size} ${p} ${basic_index_string}



#finds the FN rate between the model tree and best_QST_${index} for each loop and plots the FN rate as-st_ASTRID_FN_ms_${ms}_p_${p}_L${loop}
sh ${ScriptsPATH}/a_run_compare_tree.sh ${end_replicate} ${end_loop} ${max_subset_size} ${p} ${basic_index_string} ${model_tree} #for simmulated mammalian, avian, 15 taxa - DATASET


#model_tree_path=${model_tree}
#sh ${ScriptsPATH}/a_run_compare_tree_seperate_model_tree.sh ${end_replicate} ${end_loop} ${max_subset_size} ${p} ${basic_index_string} ${model_tree_path} #for Astral 2 dataset


#compute running time
sh ${ScriptsPATH}/compute_avg_running_time.sh  ${end_replicate} ${end_loop} ${basic_index_string} runtime_info


#compute LL score
#sh ${ScriptsPATH}/a_plot_LL_score.sh ${end_replicate} ${end_loop} ${max_subset_size} ${p} ${ils} ${ScriptsPATH}

#sh ${ScriptsPATH}/a_plot_LL_score.sh 2 2 ${max_subset_size} ${p} ${ils} ${ScriptsPATH}

