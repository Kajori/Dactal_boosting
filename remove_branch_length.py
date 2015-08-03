#-------------------------------------------------------------------------------
# File :  remove_branch_length.py
# Description :  It removes branch length from the tree given as input and writes it to the same file. It is compatible with
# dendropy 4.0.3. Here inout filename = output filename
# Author :  Kajori Banerjee
#
#-------------------------------------------------------------------------------
# Inputs : python remove_branch_length.py input_filename
#
# example : python remove_branch_length.py startting_tree_LO
#-------------------------------------------------------------------------------


import dendropy
import re
import os,sys

filename=sys.argv[1]
f_r = open(filename,'r')
input=f_r.read()
f_r.close()


#set branch length as 1
T = dendropy.Tree.get_from_path(filename,'newick')
edges=[ e for e in T.postorder_edge_iter()]
for i in range(len(edges)-1):
    edges[i].length=1

#remove branch length
input=re.sub(':1.0','',str(T))

#print input

f_w = open(filename,'w')
f_w.write(input+';')
f_w.close()
