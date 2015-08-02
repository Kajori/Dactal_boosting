#-------------------------------------------------------------------------------
# File :  compute gene tree list.py
# Description :  Used to collect the genes from  inside the folder sys.argv[1] and make a gene tree list and output file is sys.argv[2]
# It computes the gene tree list for each replicate
# of the simulated mammalian, avian dataset (except ILS 0.2X), 15 taxa dataset.
# It is called each time for each replicate
# Author :  Kajori Banerjee
#
#-------------------------------------------------------------------------------
# Inputs : python compute_gene_tree_list.py input_filename_path_upto_replicate output_filename
#
# example : python compute_gene_tree_list.py /projects/tallis/kbanerj3/dataset/simulated_mammalian/2X-200-500/R3 projects/tallis/kbanerj3/dataset/simulated_mammalian/2X-200-500/R3/gene_tree_3
#-------------------------------------------------------------------------------

import glob, os,sys

path=sys.argv[1]
f_w=open(sys.argv[2],'w')

#print "os.listdir(path): ",os.listdir(path)
for dir in os.listdir(path):
    if(dir.isdigit()):
	f_r=open(path+'/'+dir+'/raxmlboot.gtrgamma/RAxML_bipartitions.final.f200','r') #for simmulated mammalian,avian DATASET
	#f_r=open(path+'/'+dir+'/raxmlboot.gtrgamma/RAxML_bipartitions.final.f200','r') #for ILS 2X not for estimtaed gene tree
	#f_r=open(path+'/'+dir+'/raxmlboot.gtrgamma.unpart/RAxML_bestTree.best','r')#for 15 taxa
    #print dir
	f_w.write(f_r.read())
	f_r.close()
f_w.close()
