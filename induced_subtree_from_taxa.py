#-------------------------------------------------------------------------------
# File : induced_subtree_from_taxa.py
# Description :  The pRecDCM3 decomposes the set of taxa into subsets and this file is used to compute the gene tree list on the induced subset. The gene  tree list retains taxa which are in the subset
# The output is written to gene_tree_${basic_index}.subset_filename
# Author : Created on Jun 3, 2011  @author: smirarab, modified by Bayzid,Kajori
#-------------------------------------------------------------------------------
# Inputs : python induced_subtree_from_taxa.py gene_tree_${basic_index} subset_filename 
#
#-------------------------------------------------------------------------------


import dendropy
import sys
import os
import copy
import os.path

if __name__ == '__main__':
    count=1
    treeName = sys.argv[1]
    sample = open(sys.argv[2])

    included = [s[:-1] for s in sample.readlines()] #-1 is to remove the new lines
    sample.close()
    resultsFile="%s.%s" % (treeName, os.path.basename(sample.name))
    trees=dendropy.TreeList.get(path=treeName,schema="newick")
    #for tree in trees:
        #tree.is_rooted=True  #rooted = True, I changed it to as_rooted For MP_EST
    for tree in trees:
        #find the set of taxa which are preset in the gene tree but not in the subset
        nodes = list(set([t.taxon.label for t in tree.leaf_node_iter()]).difference(set(included)))

        tree.prune_taxa_with_labels(nodes)
        tree.is_rooted=False
        #else:
            #trees.remove(tree)
    print "writing results to " + resultsFile
    trees.write(file=open(resultsFile,'w'),schema='newick')
