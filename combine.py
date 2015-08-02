#-------------------------------------------------------------------------------
# File :  combine.py
# Description :  The DCM3 produces a subsetz from thr taxa set. The base methods runs on each of these
#subsets and produces a tree. These subsets are combined by combine.py
# and given as input to Superfine. combine.py is called each time separately for each subset.
# Author :  Kajori Banerjee
#It is compatible with dendropy 4.0.3
#-------------------------------------------------------------------------------
# Inputs : python combine.py inputfilename_for_Superfine species_tree_filename_on_each_subset
#
# example : python combine.py all_species_tree_2X-200-500_R3_L1 species_tree_2X-200-500_R3_L1_S0
#-------------------------------------------------------------------------------

import os,sys

#combine all the species tree into a single file

file_w = open(sys.argv[1],'a')
file_r = open(sys.argv[2],'r')

file_w.write(file_r.read())
file_w.write("\n")
file_w.close()
file_r.close()
