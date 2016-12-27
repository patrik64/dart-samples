import 'dart:collection';

class Graph {

  int m_V; //number of vertices in the graph
  int m_E; //number of edges in the graph
  List<List<int>> m_Adj; //list of connected vertices for each vertex
  
  Graph(this.m_V) {
    this.m_E = 0;
    this.m_Adj = new List<List<int>>(m_V);
    for( int v = 0; v < m_V; v++)
    {
      this.m_Adj[v] = new List<int>(m_V);
    }
  }
  
  int degree(int v)
  {
    int d = 0;
    var w = adj(v).iterator;
    while(w.moveNext())
      d++;
    return d;
  }
  
  //return the list of adjacent vertices for a given vertex
  List<int> adj(int v)
  {
    return this.m_Adj[v];  
  }
  
  //construct an edge between two vertices
  void addEdge(int v, int w)
  {
    for(int i = 0; i < m_Adj[v].length; i++){
      if( m_Adj[v][i] == null ){  
        m_Adj[v][i] = w;
        break;
      }
    }

    for(int j = 0; j < m_Adj[w].length; j++){
      if( m_Adj[w][j] == null ){  
        m_Adj[w][j] = v;
        break;
      }
    }
       
    this.m_E++;
  }

  void print_graph() {
    String str = "Number of vertices : "; 
    str += this.m_V.toStringAsFixed(0);
    str += "\nNumber of edges : ";
    str += this.m_E.toStringAsFixed(0);
    str += "\n";

    for (int i = 0; i < this.m_Adj.length; i++){
      if( this.m_Adj[i] != null){
        String str1 = i.toStringAsFixed(0);
        str1 += " -> ";
        for (int j = 0; j < this.m_Adj[i].length; j++){
          if(this.m_Adj[i][j] != null){
            str1 += this.m_Adj[i][j].toStringAsFixed(0);
            if(this.m_Adj[i][j+1] != null)
              str1 += ", ";
          }
        }
        str += str1;
        str += "\n";
      }    
    }
    
    print(str);
  }
}

class DepthFirstPaths
{
  List<bool> m_marked;
  List<int> m_edgeTo;
  int m_sourceV;

  DepthFirstPaths(Graph g, this.m_sourceV){
    this.m_marked = new List<bool>(g.m_V);
    this.m_edgeTo = new List<int>(g.m_V);  
    dfs(g, this.m_sourceV);
  }

  void dfs(Graph g, int v){
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
    for(int x = v; x != this.m_sourceV; x = this.m_edgeTo[x]){
      path.add(x);
    }
    path.add(this.m_sourceV);
    return path;
  }
}

class BreadthFirstPaths
{
  List<bool> m_marked;
  List<int> m_edgeTo;
  int m_sourceV;

  BreadthFirstPaths(Graph g, this.m_sourceV){
    this.m_marked = new List<bool>(g.m_V);
    this.m_edgeTo = new List<int>(g.m_V);  
    bfs(g, this.m_sourceV);
  }

  void bfs(Graph g, int s){
    Queue<int> queue = new Queue<int>();
    this.m_marked[s] = true;
    queue.add(s);
    while(!queue.isEmpty){
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
    for(int x = v; x != this.m_sourceV; x = this.m_edgeTo[x]){
      path.add(x);
    }
    path.add(this.m_sourceV);
    return path;
  }
}

class Bipartite
{
  List<bool> m_marked;
  List<bool> m_color;
  bool m_isBipartite = true;
  
  Bipartite(Graph g)
  {
    this.m_marked = new List<bool>(g.m_V);
    this.m_color = new List<bool>(g.m_V);
    for(int b = 0; b < g.m_V; b++){
      this.m_color[b] = true;
    }
    for(int s = 0; s < g.m_V; s++){
      if(!this.m_marked[s])
        dfs(g, s);
    }
  }
  
  void dfs(Graph g, int v)
  {
    this.m_marked[v] = true;
    for(int w in g.adj(v)){
      if( w != null ){ 
        if(!this.m_marked[w]){
          this.m_color[w] = !this.m_color[v];
          dfs(g, w);
        }
        else if( this.m_color[w] == this.m_color[v]){
          this.m_isBipartite = false;
          return;
        }
      }
    }
  }
  
  bool isBipartite() => this.m_isBipartite;
}

void main() {
  print("start");
  Graph g = new Graph(6);
  
  
  g.addEdge(0,1);
  //g.addEdge(0,2);
  g.addEdge(0,3);
  //g.addEdge(0,4);
  g.addEdge(0,5);
  
  g.addEdge(1,2);
  //g.addEdge(1,3);
  g.addEdge(1,4);
  //g.addEdge(1,5);

  g.addEdge(2,3);
  //g.addEdge(2,4);
  g.addEdge(2,5);

  g.addEdge(3,4);
  //g.addEdge(3,5);
  
  g.addEdge(4,5);
 
  g.print_graph();

  print("breadth first search from vertex 0 to 5");
  BreadthFirstPaths bfP = new BreadthFirstPaths(g, 0);
  List<int> pathB = bfP.pathTo(5);
  for(int i in pathB){
    print(i.toStringAsFixed(0));
  }

  print("depth first search from vertex 0 to 5");
  DepthFirstPaths dfP = new DepthFirstPaths(g, 0);
  List<int> pathD = dfP.pathTo(5);
  for(int i in pathD){
    print(i.toStringAsFixed(0));
  }

  Bipartite bip = new Bipartite(g);
  if(bip.isBipartite())
    print("bipartite : true");
  else
    print("bipartite : false");
  print("end");
}
