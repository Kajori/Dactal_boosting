#-------------------------------------------------------------------------------
# File :  remove_bootstrap_support_val.py
# Description :  Used to remove the bootstrap values from the gene trees in the grene tree list.
#                It is necessary because mpest cannot run if the gene trees have bootstrap values.
#
# Author :  Kajori Banerjee
#
#-------------------------------------------------------------------------------
# Inputs : python remove_bootstrap_support_val.py input_filename output_filename_path
#
# example : python remove_bootstrap_support_val.py gene_tree_tmp1_2X-200-500_R3 gene_tree_3
#-------------------------------------------------------------------------------
import dendropy
import regex as re
import sys

filename=sys.argv[1]
outfile=sys.argv[2]

tree_list = dendropy.TreeList.get_from_path(filename,'newick')

f_w = open(outfile,'w')
for T in tree_list:
    input=T.as_string('newick')
    for mat in re.findall(r'\)\d+:', input, overlapped=True):
        input=re.sub('\)'+mat[1:-1]+':',input)
    for mat in re.findall(r'\)\d+,', input, overlapped=True):
        input=re.sub('\)'+mat[1:-1]+',','),',input)
    for mat in re.findall(r'\)\d+\)', input, overlapped=True):
        input=re.sub('\)'+mat[1:-1]+'\)','))',input)


    #e_list=re.findall('e-\d+',input)
    #for b in e_list:
    #    input=re.sub(b,'',input)

    e_list=re.findall('  ',input)
    for b in e_list:
        input=re.sub(b,'',str(input))

    f_w.write(input+';')
f_w.close()
