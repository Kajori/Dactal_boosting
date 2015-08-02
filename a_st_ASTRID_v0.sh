#!/bin/bash 
# this script is used to RUN dactal boosted ASTRAL with ASTRID as the starting tree
#export superfine paths : superfine  uses Dendropy version 3.8 an python 2.7
export PYTHONPATH=/projects/tallis/kbanerj3/superfine_n/spruce-1.0:$PYTHONPATH
export PYTHONPATH=/projects/tallis/kbanerj3/superfine_n/reup-1.1/reup:$PYTHONPATH
export PYTHONPATH=/projects/tallis/kbanerj3/superfine_n/reup-1.1:$PYTHONPATH
export PYTHONPATH=/projects/tallis/kbanerj3/superfine_n/newick_modified-1.3.1:$PYTHONPATH
export FASTMRP=/projects/tallis/kbanerj3/tools/mrpmatrix-master

#export java for ASTRAL
export JAVA_HOME=/projects/tallis/kbanerj3/tools/jdk1.7.0_79
export PATH=/projects/tallis/kbanerj3/tools/jdk1.7.0_79/bin:$PATH

export LD_LIBRARY_PATH=/projects/tallis/kbanerj3/tools/libc/glibc-2.14/build:$LD_LIBRARY_PATH

AstralPATH=/projects/tallis/kbanerj3/astral/ASTRAL-master/Astral
AstridPATH=/projects/tallis/kbanerj3/dactal/ASTRID/src
ScriptsPATH=/projects/tallis/kbanerj3/dactal/dactal_scripts

#for Dendropy version 4
export PATH=/projects/tallis/kbanerj3/tools/Python_2.7_Dendropy_3.12/Python-2.7.10/build/bin:$PATH

set -x
oldpyhtonpath=$PATH





gene_tree=$1
basic_index=$2
end_loop=$3
ms=$4
p=$5

echo " Parameters are " 

echo " gene_tree= ${gene_tree}"
echo " basic_index=${basic_index}"
echo " end_loop=${end_loop}"
echo "ms=${ms}"
echo "p=${p}"


#preparing gene tree
cp ${gene_tree} gene_tree_${basic_index}

loop=0

index=${basic_index}_L${loop}


echo "Preparing gene trees  for ${basic_index} "
start_astrid=`date +%s`
python ${AstridPATH}/ASTRID.py -i $(pwd)/gene_tree_${basic_index}  -o $(pwd)/starting_tree_${index} &> xyz.txt
end_astrid=`date +%s`
runtime=$((end_astrid-start_astrid))
echo "$runtime" > runtime_st_astrid_${index}

	
oldpyhtonpath=$PATH	
loop=1
while [ ${loop} -lt ${end_loop} ]; do
    start_loop=`date +%s`
    prev_index=${index}
    index=${basic_index}_L${loop}
    
    rm gene_tree_${basic_index}.subset_${index}
	echo "  loop = ${loop} "
    rm subset_${index}*
   	
    echo "      Running DCM3 with starting_tree_${prev_index} "
    python ${ScriptsPATH}/resolve_polytomies.py $(pwd)/starting_tree_${prev_index}
    python ${ScriptsPATH}/remove_branch_length.py $(pwd)/starting_tree_${prev_index}
	
	#python ${ScriptsPATH}/prd_decomp_temp.py $(pwd)/starting_tree_${prev_index}  ${ms} ${p} 
	start_decom=`date +%s`
	python ${ScriptsPATH}/prd_decomp_temp.py $(pwd)/starting_tree_${prev_index}  ${ms} ${p} > ds_${index}
	end_decom=`date +%s`
    runtime=$((end_decom-start_decom))
    echo "$runtime" > runtime_decom_${index}
    
    
    
    python ${ScriptsPATH}/extract_subsets.py  ds_${index}

    sets=$(ls subset_${index}_S*)  
    echo "  sets ="${sets}
    j=0    
    for f in ${sets}
    do
        start_subset=`date +%s`
        echo "          Processing $f"
        python ${ScriptsPATH}/induced_subtree_from_taxa.py $(pwd)/gene_tree_${basic_index} ${f}
            
        #estimate a species tree  species_tree_i on subset_i (here we have used astral instead of MPEST
        java -jar ${AstralPATH}/astral.4.7.8.jar -i gene_tree_${basic_index}.${f} -o $(pwd)/species_tree_${index}_S${j}  &> xyz.txt
        
        python ${ScriptsPATH}/combine.py $(pwd)/all_species_tree_${index} $(pwd)/species_tree_${index}_S${j}
        echo "          j="$j
        let j=j+1
        end_subset=`date +%s`
        runtime=$((end_subset-start_subset))
        echo "$runtime" > runtime_subset_${index}_S${j}
    done #end of for j
        
        
        
    echo "      total j ="${j}
        
    start_superfine=`date +%s`
    echo "Running Superfine with all_species_tree_${index}"
    export PATH=/projects/tallis/kbanerj3/tools/Python-2.7.10/build/bin:$PATH
    python /projects/tallis/kbanerj3/superfine_n/runReup.py -r mrl all_species_tree_${index}  >  starting_tree_${index}
    PATH=${oldpyhtonpath}
    end_superfine=`date +%s`
    runtime=$((end_superfine-start_superfine))
    echo "$runtime" > runtime_superfine_${index}
       
   
    runtime=$((end_superfine-start_loop))
    echo "$runtime" > runtime_loop_${index}
    let loop=loop+1
done #end of loop
