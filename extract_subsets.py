#-------------------------------------------------------------------------------
# File : extract_subsets.py
# Description :  The pRecDCM3 decomposes the set of taxa into subsets and the output of pRecDCM3 is stored in ds_${index}. This file is the python version of extract_subsets.pl. This file is used to compute the the subsets from ds_${index} and write them as seperate files
# Author : Kajori
#-------------------------------------------------------------------------------
# Inputs : python extract_subsets.py output of pRecDCM3 subset_filename
#
# example : python extract_subsets.py ds_${index}
# the output if stored in subset_${index}_Ssubsetindex
#-------------------------------------------------------------------------------

import re,os,sys

filename=sys.argv[1]
f_r=open(filename,'r')
input=f_r.read()
f_r.close()

subsets=re.findall('subset\s+\d+: \[.*\]',input) #\s+ is for one for more blank space

for subs in subsets:
    #print ' subs =',subs
    mat=re.findall('subset\s+\d',subs)[0]
    #print 'mat=',mat
    index=subs[len(mat)-1:subs.index(':')] #extract the subset number
    #print ' index=',index

    taxa=subs[subs.index('[')+1:subs.index(']')]  #extract the taxa belonging to that subset, the taxa list is like [ 'S1', 'S2' ]
    #print ' all taxa',taxa
    taxa_list=taxa.split(',')
    f_w=open('subset_'+filename[3:]+'_S'+str(index),'w') #filename[3:] is the ${index} of inputfile ds_${index}
    for t in taxa_list:
        #print t,' , ',t[t.index("'")+1:-1]
        f_w.write(t[t.index("'")+1:-1]+'\n') #+1 and -1 is for removing the opening and ending inverted comma's from the taxa name
    f_w.close()
