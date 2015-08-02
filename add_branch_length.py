#-------------------------------------------------------------------------------
# File : add_branch_length.py
# Description :  Used to add branch length 1 to a tree given as input
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs : python add_branch_length.py input_filename
# Here input_filename == output_filename
#-------------------------------------------------------------------------------

import dendropy
import re
import os,sys

filename=sys.argv[1]
f_r = open(filename,'r')
input=f_r.read()
f_r.close()
T = dendropy.Tree.get_from_path(filename,'newick')
for e in T.postorder_edge_iter():
    e.length=1
print str(T)+';'

f_w = open(filename,'w')
f_w.write(str(T)+';')
f_w.close()
