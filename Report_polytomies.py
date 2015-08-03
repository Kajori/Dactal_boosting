import dendropy,sys


filename=sys.argv[1]
basic_index=sys.argv[2]
T = dendropy.Tree.get_from_path(filename,'newick')
nodes_T=[ len(n.child_nodes()) for  n in T.postorder_internal_node_iter()]

flag=0
for n in nodes_T:
    if (n >2 ):
        flag=1
        print " model tree has polymoties "

if (flag == 1 ):
    print " model tree has polytomies "
    f_w=open("Report_polytpmies_"+basic_index,"w")
    f_w.write(" Starting tree "+basic_index+" has ploytomies ");
    f_w.close();
