ass Digraph
{
  int m_V;
  int m_E;
  List<List<int>> m_Adj;

  Digraph(this.m_V){
    this.m_E = 0;
    this.m_Adj = new List<List<int>>();
    for(int i = 0; i < this.m_V; i++){
      this.m_Adj.add(new List<int>());
    }
  }

  void addEdge(int v, int w){
    this.m_Adj[v].add(w);
    this.m_E++;
  }

  List<int> adj(int v){
    return this.m_Adj[v];
  }

  Digraph reverse(){
    Digraph r = new Digraph(this.m_V);
    for(int v = 0; v < this.m_V; v++){
      for(int w in this.m_Adj[v]){
        r.addEdge(w, v);
      }
    }
    return r;
 }

  void print_graph(){
    String str = "Number of vertices : ${this.m_V.toString()}\n";
    str += "Number of edges : ${this.m_E.toString()}\n";
    for(int i = 0; i < this.m_Adj.length; i++){
      str += "${i.toString()} ->  ";
      for(int v in this.m_Adj[i]){
        str += "${v.toString()}, ";
      }
      str = str.substring(0, str.length - 2);
      str += "\n";
    }
    print(str);
  }
}

class DirectedDFS
{
  List<bool> m_marked;

  DirectedDFS(Digraph g, int s){
    m_marked = new List<bool>(g.m_V);
    m_marked.forEach(f(e) => e = true);
    dfs(g, s);
  }

  void dfs(Digraph g, int v){
    this.m_marked[v] = true;
    for(int i in g.adj(v))
      if(!this.m_marked[i])
        dfs(g, i);
  }

  void print_reachable(int v){
    String str = "Reach from vertex ${v.toString()}  : ";
    for(int i  = 0; i < this.m_marked.length; i++){
      if(this.m_marked[i]){
        str += i.toStringAsFixed(0);
        str += " - ";
      }
    }
    str = str.substring(0, str.length - 3);
    print(str);
  }
}

class DirectedCycle
{
  List<bool> m_marked;
  List<int> m_edgeTo;
  Queue<int> m_cycle;
  List<bool> m_onStack;

  DirectedCycle(Digraph g){
    this.m_onStack = new List<bool>(g.m_V);
    this.m_onStack.forEach(f(e) => e = false);
    this.m_marked = new List<bool>(g.m_V);
    this.m_marked.forEach(f(e) => e = false);
    this.m_onStack.forEach(f(e) => e = false);
    this.m_edgeTo = new List<int>(g.m_V);
    this.m_edgeTo.forEach(f(e) => e = -1);
    this.m_cycle = new Queue<int>();
    for(int v = 0; v < g.m_V; v++){
      if(!this.m_marked[v])
        dfs(g, v);
    }
  }

  void dfs(Digraph g, int v){
    this.m_onStack[v] = true;
    this.m_marked[v] = true;
    for( int w in g.adj(v)){
      if(this.hasCycle())
        return;
      else if(!this.m_marked[w]){
        this.m_edgeTo[w] = v;
        dfs(g, w);
      }
      else if(this.m_onStack[w]){
        for( int x = v; x!= w; x = this.m_edgeTo[x] )
          this.m_cycle.add(x);
        this.m_cycle.add(w);
        this.m_cycle.add(v);
      }
    }
    this.m_onStack[v] = false;
  }

  bool hasCycle() => (this.m_cycle.length > 0);

  void print_cycles(){
    String str = "Cycles : ";
    if(this.hasCycle()){
      while(!this.m_cycle.isEmpty()){
        int i = this.m_cycle.removeLast();
        str += "${i.toString()} - ";
      }
      str = str.substring(0, str.length - 3);
    }else{
      str = "no cycles";
    }
    print(str);
  }
}


class DirectedDepthFirstPaths
{
  List<bool> m_marked; 
  List<int> m_edgeTo; //list of indices to connected vertices
  int m_source;       //source vertex

  DirectedDepthFirstPaths(Digraph g, this.m_source){
    this.m_marked = new List<bool>(g.m_V);
    this.m_edgeTo = new List<int>(g.m_V);  
    dfs(g, this.m_source);
  }

  void dfs(Digraph g, int v){
    this.m_marked[v] = true;
    for (int w in g.adj(v)){
       if( w != null ){ 
          if(!this.m_marked[w]){
            this.m_edgeTo[w] = v;
            dfs(g, w);
          }
       }
    }
  }

  bool hasPathTo(int v){
    return this.m_marked[v];
  }

  List<int> pathTo(int v){
    if(!hasPathTo(v)) return null;
    List<int> path = new List<int>();
    for(int x = v; x != this.m_source; x = this.m_edgeTo[x]){
      path.add(x);
    }
    path.add(this.m_source);
    return path;
  }
  
  void print_path_to(int v){
    String str = "Depth first path from vertex ${m_source.toString()} : ";
    if(this.hasPathTo(v)){
      for(int i in this.pathTo(v)){
        str += "${i.toString()} - ";  
      }
      str = str.substring(0, str.length - 3);
    }else{
      str += "no path to vertex ${v.toString()}";  
    }  
    print(str);
  }
}

class DirectedBreadthFirstPaths
{
  List<bool> m_marked;
  List<int> m_edgeTo;
  int m_source;

  DirectedBreadthFirstPaths(Digraph g, this.m_source){
    this.m_marked = new List<bool>(g.m_V);
    this.m_edgeTo = new List<int>(g.m_V);  
    bfs(g, m_source);
  }

  void bfs(Digraph g, int s){
    Queue<int> queue = new Queue<int>();
    this.m_marked[s] = true;
    queue.add(s);
    while(!queue.isEmpty()){
      int v = queue.removeFirst();
      for (int w in g.adj(v)){
        if( w != null ){ 
          if(!this.m_marked[w]){
            this.m_edgeTo[w] = v;
            this.m_marked[w] = true;
            queue.add(w);
          }
        }
      }
    }
  }

  bool hasPathTo(int v){
    return this.m_marked[v];
  }

  List<int> pathTo(int v){
    if(!hasPathTo(v)) return null;
    List<int> path = new List<int>();
    for(int x = v; x != this.m_source; x = this.m_edgeTo[x]){
      path.add(x);
    }
    path.add(this.m_source);
    return path;
  }
  
  void print_path_to(int v){
    String str = "Breadth first path from vertex ${m_source.toString()} : ";
    if(this.hasPathTo(v)){
      for(int i in this.pathTo(v)){
        str += "${i.toString()} - ";  
      }
      str = str.substring(0, str.length - 3);
    }else{
      str += "no path to vertex ${v.toString()}";  
    }  
    print(str);
  }
}

class DepthFirstOrder
{
  List<bool> m_marked;
  Queue<int> m_pre;
  Queue<int> m_post;
  Queue<int> m_reversePost;

  DepthFirstOrder(Digraph g){
    m_pre = new Queue<int>();
    m_post = new Queue<int>();
    m_reversePost = new Queue<int>();
    m_marked = new List<bool>(g.m_V);
    this.m_marked.forEach(f(e) => e = false);
    
    for(int v = 0; v < g.m_V; v++){
      if(!m_marked[v])
        dfs(g, v);
    }
  }
  
  void dfs(Digraph g, int v){
    m_pre.add(v);
    m_marked[v] = true;
    for(int w in g.adj(v))
      if(!m_marked[w])
        dfs(g, w);
    
    m_post.add(v);
    m_reversePost.addLast(v);
  }
  
  void print_order(){
    String str = "Pre : ";
    while(!m_pre.isEmpty()){
      int i = m_pre.removeFirst();
      str += "${i.toString()} ";
    }
    print(str);
    
    str = "Post : ";
    while(!m_post.isEmpty()){
      int i = m_post.removeFirst();
      str += "${i.toString()} ";
    }
    print(str);
    
    str = "PostReverse : ";
    while(!m_reversePost.isEmpty()){
      int i = m_reversePost.removeLast();
      str += "${i.toString()} ";
    }
    print(str);
  }
}

class TopologicalOrder{
  Queue<int> m_order = null;
  
  TopologicalOrder(Digraph g){
    DirectedCycle cyclefinder = new DirectedCycle(g);
    if(!cyclefinder.hasCycle()){
      DepthFirstOrder dfs = new DepthFirstOrder(g);
      m_order = dfs.m_reversePost;
    }
  }
  
  bool isDAG() => m_order != null;
}

void main()
{
  Digraph g = new Digraph(13);
  g.addEdge(0, 1);
  g.addEdge(0, 5); 
  g.addEdge(0, 6); 
  g.addEdge(2, 0);
  g.addEdge(2, 3);
  g.addEdge(3, 5);
  g.addEdge(5, 4);
  g.addEdge(6, 4);
  g.addEdge(6, 9);
  g.addEdge(7, 6);
  g.addEdge(8, 7);
  g.addEdge(9, 10);
  g.addEdge(9, 11);
  g.addEdge(9, 12);
  g.addEdge(11, 12);
  
  g.print_graph();

  //g.reverse().print_graph();

  DirectedDFS dfs = new DirectedDFS(g, 0);
  dfs.print_reachable(0);
  
  DirectedDepthFirstPaths ddfp = new DirectedDepthFirstPaths(g, 8);
  ddfp.print_path_to(4);
  
  DirectedBreadthFirstPaths dbfp = new DirectedBreadthFirstPaths(g, 8);
  dbfp.print_path_to(4);
  
  DirectedCycle c = new DirectedCycle(g);
  c.print_cycles();
  
  DepthFirstOrder order = new DepthFirstOrder(g);
  order.print_order();
  
  TopologicalOrder topo = new TopologicalOrder(g);
  if(topo.isDAG())
    print("topo : true");
  else
    print("topo : false");
}
