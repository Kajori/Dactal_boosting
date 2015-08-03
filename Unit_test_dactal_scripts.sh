#!/bin/bash
# assert.sh

#######################################################################
assert ()                 #  If condition false,
{                         #+ exit from script
                          #+ with appropriate error message.
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99


  if [ -z "$2" ]          #  Not enough parameters passed
  then                    #+ to assert() function.
    return $E_PARAM_ERR   #  No damage done.
  fi

  lineno=$2

  if [ ! $1 ]
  then
    echo "Assertion failed:  \"$1\""
    echo "File \"$0\", line $lineno"    # Give name of file and line number.
    exit $E_ASSERT_FAILED
  # else
  #   return
  #   and continue executing the script.
  fi
} # Insert a similar assert() function into a script you need to debug.
#######################################################################

datasetPATH="Sample_inputs"
#sample_input_file_remove_branch_length.tr have branch lengths
#cp sample_input_file_remove_branch_length.tre temp
#python remove_branch_length.py temp
#S1=$(cat temp)
#S2=$(cat sample_output_file_remove_branch_length.tre)
#assert " X${S1}=X${S2}" $LINENO
#rm temp

#extract_subsets.py
cp ${datasetPATH}/ds_0.2X-200-500-R1_L2 tp_0.2X-200-500-R1_L2
python extract_subsets.py tp_0.2X-200-500-R1_L2
rm tp_0.2X-200-500-R1_L2
sets=$(ls subset_0.2X-200-500-R1_L2_S*)
assert "X${sets}=Xsubset_0.2X-200-500-R1_L2_S0 subset_0.2X-200-500-R1_L2_S1 subset_0.2X-200-500-R1_L2_S13 subset_0.2X-200-500-R1_L2_S2 subset_0.2X-200-500-R1_L2_S3"
mv subset_0.2X-200-500-R1_L2_S13 ${datasetPATH}/
rm subset_0.2X*



#remove_branch_length_from_TreeList.py remove_bootstrap_support_val.py
cp ${datasetPATH}/gene_tree_0.2X-200-500-R2 temp_branch_length_bootstrap
python remove_branch_length_from_TreeList.py temp_branch_length_bootstrap
python remove_bootstrap_support_val.py temp_branch_length_bootstrap temp
echo " temp "
cat temp
cp temp ${datasetPATH}/sample_tree_no_branch_length_no_bootstrap
S1=$(cat temp)
S2=$(cat ${datasetPATH}/sample_tree_no_branch_length_no_bootstrap)
assert "X${S1}=X${S2}" $LINENO
rm temp_branch_length_bootstrap temp

python induced_subtree_from_taxa.py ${datasetPATH}/sample_tree_no_branch_length_no_bootstrap  ${datasetPATH}/subset_0.2X-200-500-R1_L2_S13

cp ${datasetPATH}/sample_tree_no_branch_length_no_bootstrap temp
python reroot_v3.py temp GAL -nomrca
rm temp temp.rooted
#test resolve_polytomies.py
cp ${datasetPATH}/polytomy_1.tre temp_polytomy_1.tre
rm Report_polytpmies_0
python resolve_polytomies.py temp_polytomy_1.tre
python Report_polytomies.py temp_polytomy_1.tre 0 #0 is the basic index
flag=0
if [ ! -f Report_polytpmies_0 ]; then
    flag=1
    echo "resolve_polytomies.py and Report_polytomies.py"
fi
assert "X${flag}=X0" $LINENO
rm Report_polytpmies_0 temp_polytomy_1.tre
