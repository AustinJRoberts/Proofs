import networkx as nx
import copy
import itertools

#######################################
##Standard Dual Equivalence Functions##
#######################################

###Elementary Dual Equivalence###
        #####only defined for permutations####
def DualEq(x, i):
    '''Takes a permutation x and an integer i. Returns d_i(x)'''
    
    y=copy.copy(x)                                      
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

def DualEq_D(x, i, content):
    '''Takes a permutation x, an integer i, and a content (from a diagram) and performs a single involutin D_i(x).'''
    
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


def Graph_From_Function(Edge, Vertex, Label=copy, Degree=3):
    '''Takes an edge generating function and a vertex and returns a graph with colored edges.'''

    ## This function makes graphs. It takes a function to define edges and a vertex. 
    ## The options provided are not needed for this proof, but allow for more flexibility, should the reader want to test related ideas.  
    ## Label can be used to change how the graph records vertices (could add signature or write as tableaux).
    ## Degree allows for subgraphs of bounded degree to be created.
    
    ##With Doubled Edges. Starts from a single Vertex##
    G= nx.Graph(multiedges= True); G.add_node(Label(Vertex))
    New_Vertices=[Vertex]
    while len(New_Vertices) > 0:
        Length = len(New_Vertices)
        for X in New_Vertices:
            for i in range(2,Degree):
                u=Edge(X, i)
                v=Label(u)
                w=Label(X)
                if v not in G.nodes():
                    New_Vertices.append(u)
                    G.add_edge(v,w,color = i)
                if (w, v) not in G.edges() and (v, w) not in G.edges():
                    G.add_edge(v,w, color=i)
        for i in range(1,Length+1):
            del(New_Vertices[0])
    return G
   
            
#####################
#Graphing Functions##
#####################

def DEG(x):
    '''Takes a permutation and returns its dual equivalence graph with colored edges'''
    return Graph_From_Function(DualEq,Vertex=x,Label=tuple,Degree=len(x))

def DEG_D(x, content):
    '''Takes a permutation and content (from a diagram) and returns an Assaf graph with colored edges'''
    def F(x,i):
        return DualEq_D(x,i,content)
    return Graph_From_Function(F,Vertex=x,Label=tuple,Degree=len(x))
         
         
######################################################################    
##Functions for creating representative words of equivalence classes##
######################################################################

def Partitions(n, bound = None):
    '''Generates all partitions of n  (written in decreasing order).'''
    if bound == None: bound = n
    
    allP=[[]]
    if n == 0:
        return allP

    for first in range(1, min(n+1, bound+1)):
        for last in Partitions(n-first, bound = first):
            allP.append([first]+last)
    del(allP[0])
    return allP


def Rep_Word(P):
    '''Input Partition, return reading word of U_\lambda for partion lambda.'''
      
    Word=[]; Size=sum(P); Length=len(P)
    for i in range(1, len(P)+1):   
        for k in range(Size-P[Length-i]+1, Size+1):
            Word.append(k)
        Size=Size-P[Length-i]
    return Word
    
def All_Rep_Words(n):
    '''Gives all representative reduced words for each partition on n.
    Specifically, creates the reading word of U_\lambda for partition lambda.'''
    Words=[]
    for x in Partitions(n):
        Words.append(Rep_Word(x))
    return Words


#############################
## Finding strict patterns ##
#############################

def has_strict_pattern(w, content):
    '''Given a permutation and the content (of a diagram), checks if it contains one of 4 strict patterns'''
    
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

#############################
### Verify the lemma ########
#############################

if __name__ == '__main__':
    print "Generating all degree 6 dual equivalence graphs. . ."

    DEGs6=[]
    for w in All_Rep_Words(6):
        G=DEG(w)
        DEGs6.append(G)

    print "Number of non-isomorphic dual equivalence graphs of size 6 =", len(DEGs6) 
    #Note: This is more than we actually need since the transposing diagrams gives an isomorphism up to multiplying signatures by -1. 

    print "Checking each Assaf graphs of size 6 that avoids list of strict patterns . . ."
    print "Looking for any that are not isomorphic to some graph in the list of dual equivalence graphs . . ." 
    Bad_perms=[]
    Checked = 0
    for p in itertools.permutations([1, 2, 3, 4, 5, 6]):
      p=list(p)
      for a in range(2,7): #generate all contents [a,b,c,d,6,6]
        for b in range(max(3,a),7):
            for c in range(max(4,b),7):
                for d in range(max(5,c),7):
                    if has_strict_pattern(p,[a,b,c,d,6,6]) == False:
                        Checked += 1
                        G=DEG(p)
                        Check=False
                        for H in DEGs6:
                            if nx.is_isomorphic(G, H)==True:
                                Check=True
                                break
                        if Check==False:
                            Bad_perms.append(p)
                            print "The lemma is false."
                            
    if Bad_perms==[]: 
        print "Checked", Checked, "such graphs, and all were dual equivalence graphs!"
        print " "
        print "--- The lemma is True. ---"



