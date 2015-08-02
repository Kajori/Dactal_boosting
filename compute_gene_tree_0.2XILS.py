#-------------------------------------------------------------------------------
# File :  compute_gene_tree_0.2XILS.py
# Description :  Used to collect the genes from  inside the folder sys.argv[1] and make a gene tree list and output file is sys.argv[2]
# It computes the gene tree list for ALL the replicates of the simulated mammalian dataset.
# It is modification of the compute_gene_tree_list.py and used for the ILS 0.2X
#For ILS 0.2X, 200gt the first 200 gene trees are part of replicate 1
#the second 200 i.e. 201-400 gene tree are part of replicate 2
# gene tree from 401-600 are part of replicate 3
# The program ompute_gene_tree_0.2XILS.py should it called at the beginning it computes the entire
# gene tree list for all the replicates together.
# Author :  Kajori Banerjee
#-------------------------------------------------------------------------------
# Inputs : python compute_gene_tree_0.2XILS.py input_filename_path
#
# example : python compute_gene_tree_0.2XILS.py /projects/tallis/kbanerj3/dataset/simulated_mammalian/0.2X-200-500/
#-------------------------------------------------------------------------------

import glob, os,sys
path=sys.argv[1]

r=0 #r is the replicate number for which the gene tree list is being computed
for dir in range(1,4000): # as there are total 40000 files
    # print str(dir)
    if ((dir%200)==1): # change this number depending on the number of gene trees in the model condition
        print " dir =",str(dir)," r= ",str(r)
        r=r+1
        if ( r>1):
            f_w.close() # to close the previous file
        f_w=open('gene_tree_0.2X-200-500-R'+str(r),'w')

    f_r=open(path+str(dir)+'.500-bp.BestML.tre','r') #for estimtaed gene tree
    f_w.write(f_r.read())
    f_r.close()
