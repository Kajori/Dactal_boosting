#-------------------------------------------------------------------------------
# File :  resolve_polytomies.py
# Description : DCM3 does not work when the input tree has polytomies . resolve_polytomies.py resolves polytomies from the input tree.
#
# Author :  Kajori Banerjee
#-------------------------------------------------------------------------------

import dendropy,os,sys

def main(argv):
    input_tree_path = sys.argv[1]
    S=dendropy.Tree.get_from_path(input_tree_path,schema="newick")
    S.resolve_polytomies()
    os.remove(input_tree_path)
    f=open(input_tree_path,"w")
    tree_str = S.as_string('newick', suppress_rooting=True)
    f.write(tree_str)
    f.close()

if __name__ == "__main__":
    main(sys.argv)
