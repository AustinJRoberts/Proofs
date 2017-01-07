︠9eff6c74-c2cf-4bb7-95ea-2fa0beb684f6︠

︡a752d223-1a4a-4523-9dfc-f69af589eaf1︡
︠a07fe0cc-0534-404e-ad8a-6a2280acb047i︠
%html
We begin by introducing the key functions needed to generate the desired graphs.
︡6be194fc-11a2-4cd5-b19b-5ab9112e7a96︡︡{"done":true,"html":"We begin by introducing the key functions needed to generate the desired graphs."}
︠2a8dd00a-ef56-440d-9c7f-6ded8239863fs︠
%cython
from sage.all import Graph, copy, Partitions

#######################################
##Standard Dual Equivalence Functions##
#######################################

###Elementary Dual Equivalence###
        #####only defined for permutations####
def DualEq(list x, int i):   
    cdef list y,w
    
    y=copy(x)                                      
    a=y.index(i-1)
    b=y.index(i)
    c=y.index(i+1)    

    if a<b<c or a>b>c:
            return y
    
    elif b<c<a or b>c>a:
            del(y[b]); y.insert(b,i-1)
            del(y[a]); y.insert(a,i)
            return y
            
    else:    #y[i-1]<y[i-2]<y[i] or y[i-1]>y[i-2]>y[i]
            del(y[b]); y.insert(b,i+1)
            del(y[c]); y.insert(c,i)
            return y
            
    
        
#########################################################
#####D Version of Dual Equivalence for Assaf grapns######
#########################################################

##Common error: all inputs must be permutations, not just a words.
###Non-Standard Def!. 'content' defines when to use d^~, when all 3 entries are in a range [j,content[j]]###

def DualEq_D(list x,int i,list content):   
    cdef list y 
    
    y=copy(x)     
    a=y.index(i-1)
    b=y.index(i)
    c=y.index(i+1)    

    if a<b<c or a>b>c:
            return y
    
    elif b<c<a or b>c>a:
        if min(content[a],content[b]) <= max(a,b):        
            del(y[b]); y.insert(b,i-1)
            del(y[a]); y.insert(a,i)
            return y
        
        else:
            del(y[c]); y.insert(c,i-1)
            del(y[b]); y.insert(b,i+1)
            del(y[a]); y.insert(a,i) 
            return y
                
    else:    
        if min(content[b],content[c]) <= max(b,c):
            del(y[b]); y.insert(b,i+1)
            del(y[c]); y.insert(c,i)
            return y

        else:
            del(y[c]); y.insert(c,i)
            del(y[b]); y.insert(b,i-1)
            del(y[a]); y.insert(a,i+1) 
            return y
            


#####################################################
#######Graph from permutation and edge function######
#####################################################



def Graph_From_Function(Edge, Vertex, Label=copy, int Degree=3):

    ## This function makes graphs. It takes a function to define edges and a vertex. There are further options about how the graph is labeled and the degree of the graph.
    
    cdef list New_Vertices                                
    
    ##With Doubled Edges From a Vertex##
    G=Graph(multiedges= True); G.add_vertex(Label(Vertex))
    New_Vertices=[Vertex]
    while len(New_Vertices) > 0:
        Length = len(New_Vertices)
        for X in New_Vertices:
            for i in range(2,Degree):
                u=Edge(X,i)
                v=Label(u)
                w=Label(X)
                if v not in G.vertices():
                    New_Vertices.append(u)
                    G.add_edge(v,w,i)
                if (w, v, i) not in G.edges() and (v, w, i) not in G.edges():
                    G.add_edge(v,w,i)
        for i in range(1,Length+1):
            del(New_Vertices[0])
    return G
   
            
#####################
#Graphing Functions##
#####################

def DEG(list x):    
    return Graph_From_Function(DualEq,Vertex=x,Label=tuple,Degree=len(x))

def DEG_D(list x,list content):   
    def F(x,i):
        return DualEq_D(x,i,content)
    return Graph_From_Function(F,Vertex=x,Label=tuple,Degree=len(x))
         
         
######################################################################    
##Functions for creating representative words of equivalence classes##
######################################################################

def Rep_Word(P):   #Input Partition, return maximal word (reading word of U_\lambda).
    cdef list Word
    cdef int Size, Length
      
    Word=[]; Size=sum(P); Length=len(P)
    for i in range(1, len(P)+1):   
        for k in range(Size-P[Length-i]+1, Size+1):
            Word.append(k)
        Size=Size-P[Length-i]
    return Word
    
def All_Rep_Words(int n):  ##Gives all representative reduced words for each partition on n
    cdef list Words    
    Words=[]
    for x in Partitions(n):
        Words.append(Rep_Word(x))
    return Words
︡b0ffc496-40e8-4754-a6c1-bd490f45d769︡︡{"html":"<a href='/68f4700c-ebc6-413b-9efd-f0cab668f9dc/raw/.sage/temp/compute2-us/31356/spyx/_projects_68f4700c_ebc6_413b_9efd_f0cab668f9dc__sage_temp_compute2_us_31356_dir_LxWCle_a_pyx/_projects_68f4700c_ebc6_413b_9efd_f0cab668f9dc__sage_temp_compute2_us_31356_dir_LxWCle_a_pyx_0.html' target='_new' class='btn btn-small' style='margin-top: 1ex'>Auto-generated code... &nbsp;<i class='fa fa-external-link'></i></a>","done":false}︡{"done":true}
︠9ec661e2-879c-487a-9545-4e8f441aacef︠

︡4bd7d649-d6d2-4238-83b7-51e0b8def018︡
︠369a2ac0-b635-41b9-aef7-d48ab4e04e35i︠
%html
Next we generate all standard dual equivalence graphs whose partition type has size 6. To do this, it suffices to generate the graphs including the reading words of U_\lambda. The function All_Rep_Words generates these reading words.
︡b70d5341-b975-464c-8263-a219c8176b55︡︡{"done":true,"html":"Next we generate all standard dual equivalence graphs whose partition type has size 6. To do this, it suffices to generate the graphs including the reading words of U_\\lambda. The function All_Rep_Words generates these reading words."}
︠3b493fc3-f015-4478-b0e1-f26fae342f79s︠
DEGs6=[]
for w in All_Rep_Words(6):
        G=DEG(w)
        DEGs6.append(G)

︡26c3e082-6b3a-4e6f-a1a2-918d77f983ae︡︡{"done":true}
︠acfa9754-10a4-476a-a3aa-2e730bae2ba2i︠
%html
These standard dual equivalence graphs are shown below.
︡336e6230-af36-472d-ac11-9049a255fbc5︡︡{"done":true,"html":"These standard dual equivalence graphs are shown below."}
︠225b52e1-0bf8-48b8-a204-8524cd50ee3ds︠
graphs_list.show_graphs(DEGs6, color_by_label=true, edge_labels=true, layout='spring', vertex_size=6)
︡73df3c38-cecc-415d-b60c-15d34e58a005︡︡{"once":false,"done":false,"file":{"show":true,"uuid":"1ebd94a3-2210-463b-9a74-c99f87168d45","filename":"/projects/68f4700c-ebc6-413b-9efd-f0cab668f9dc/.sage/temp/compute2-us/31356/tmp_pEkYxY.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠f8f20827-f197-443d-a985-9eca97c44d00i︠
%html
Next, we need to create a function to detect if a permutation contains a strict pattern. To do this, we again allow 'content' to encode which entries share a pistol.
︡d1317186-3518-4708-88f7-2f5186ac90ef︡︡{"done":true,"html":"Next, we need to create a function to detect if a permutation contains a strict pattern. To do this, we again allow 'content' to encode which entries share a pistol."}
︠fc4136b0-e640-4f56-ad7b-f6e0478317d6︠
︡dedb563c-8206-4888-ab2b-f213cce1addb︡
︠7a0c0556-326d-4beb-aeb2-9db463e62f56︠
%cython
def has_strict_pattern(list w, list content):
    cdef list pat
    
    #Check two shorter patterns 1342, 2341
    for i in range(1,4):
        pat=[w.index(i), w.index(i+2), w.index(i+3), w.index(i+1)]
        if pat[0]<pat[1]<pat[2]<pat[3]:
            if content[pat[0]] >= pat[3]:
                return True
        pat=[w.index(i+1), w.index(i+3), w.index(i+2), w.index(i)]
        if pat[0]<pat[1]<pat[2]<pat[3]:
            if content[pat[0]] >= pat[3]:
                return True
    
    #Check second pattern 12543, 34521
    for i in range(1,3):
        pat=[w.index(i),w.index(i+1),w.index(i+4),w.index(i+3),w.index(i+2)]
        if pat[0]<pat[1]<pat[2]<pat[3]<pat[4]:
            if content[pat[0]]>=pat[3] and content[pat[1]]>=pat[4] and content[pat[0]]<pat[4]:
                return True
        pat=[w.index(i+2),w.index(i+3),w.index(i+4),w.index(i+1),w.index(i)]
        if pat[0]<pat[1]<pat[2]<pat[3]<pat[4]:
            if content[pat[0]]>=pat[3] and content[pat[1]]>=pat[4] and content[pat[0]]<pat[4]:
                return True
    
    return False
︡5aa0b6bc-ab03-4574-8e3e-b4210ac5fe42︡︡{"html":"<a href='/68f4700c-ebc6-413b-9efd-f0cab668f9dc/raw/.sage/temp/compute2-us/20659/spyx/_projects_68f4700c_ebc6_413b_9efd_f0cab668f9dc__sage_temp_compute2_us_20659_dir_rjxvAz_a_pyx/_projects_68f4700c_ebc6_413b_9efd_f0cab668f9dc__sage_temp_compute2_us_20659_dir_rjxvAz_a_pyx_0.html' target='_new' class='btn btn-small' style='margin-top: 1ex'>Auto-generated code... &nbsp;<i class='fa fa-external-link'></i></a>","done":false}︡{"done":true}
︠5cef120d-731a-44ce-8543-70a69279b16ci︠
%html
Finally, we may go through all all possible permutations of size 6 and 'content' to check if they contain any of our strict patterns. If they do not, we may generate the graph and ensure that it is a dual equivlalence graph by checking it against the list we made above. Notice that, without loss of generality, we have assumed pistols contain at least two cells.
︡978db862-dbd8-4428-a1b9-4754f2998149︡︡{"done":true,"html":"Finally, we may go through all all possible permutations of size 6 and 'content' to check if they contain any of our strict patterns. If they do not, we may generate the graph and ensure that it is a dual equivlalence graph by checking it against the list we made above. Notice that, without loss of generality, we have assumed pistols contain at least two cells."}
︠2bbd584e-a50c-4423-952f-402c4b1c2763︠
for i in range(1,6):
    if i==4:
        break
    p
︡781e702c-b8ae-4f1d-a081-a82c38478cc6︡
︠2d09cb0c-886e-4e68-b0b4-66d119a113a3︠
Bad_perms=[]
for p in Permutations(6):
    p=list(p)
    for a in range(2,7): #generate all contents [a,b,c,d,6,6]
        for b in range(max(3,a),7):
            for c in range(max(4,b),7):
                for d in range(max(5,c),7):
                    if has_strict_pattern(p,[a,b,c,d,6,6])==False:
                        G=DEG(p)
                        Check=False
                        for H in DEGs6:
                            if G.is_isomorphic(H)==True:
                                Check=True
                                break
                        if Check==False:
                            Bad_perms.append(p)    
                            print "The lemma is false."
                            
if Bad_perms==[]: print "The lemma is True."
︡8b0979c6-fc71-4cb8-bc14-c1d59b035af6︡︡{"stdout":"The lemma is True.\n","done":false}︡{"done":true}
︠467cf0a5-210f-4dd6-be23-403e1f941208︠









