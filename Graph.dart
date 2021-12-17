import 'dart:collection';

class Graph {

  late int mV; //number of vertices in the graph
  late int mE; //number of edges in the graph
  List<List<int>> mAdj = []; //list of connected vertices for each vertex
  
  Graph(v) {
    mV = v;
    mE = 0;
    mAdj = List.generate(mV, (i) => []);
  }
  
  int degree(int v)
  {
    int d = 0;
    var w = adj(v).iterator;
    while(w.moveNext()){
      d++;
    }
    return d;
  }
  
  //return the list of adjacent vertices for a given vertex
  List<int> adj(int v)
  {
    return mAdj[v];  
  }
  
  //construct an edge between two vertices
  void addEdge(int v, int w)
  {
    mAdj[v].add(w);
    mAdj[w].add(v);
    mE++;
  }

  void printGraph(){
    String str = "Number of vertices : ${mV.toString()}\n";
    str += "Number of edges : ${mE.toString()}\n";
    for(int i = 0; i < mAdj.length; i++){
      str += "${i.toString()} ->  ";
      for(int v in mAdj[i]){
        str += "${v.toString()}, ";
      }
      str = str.substring(0, str.length - 2);
      str += "\n";
    }
    print(str);
  }
}

class DepthFirstPaths
{
  late List<bool> mMarked;
  late List<int> mEdgeTo;
  late int mSourceV;

  DepthFirstPaths(Graph g, s){
    mSourceV = s;
    mMarked = List<bool>.filled(g.mV, false);
    mEdgeTo = List<int>.filled(g.mV, -1);
    dfs(g, mSourceV);
  }

  void dfs(Graph g, int v){
    mMarked[v] = true;
    for (int w in g.adj(v)){
       //if( w != null ){ 
          if(!mMarked[w]){
            mEdgeTo[w] = v;
            dfs(g, w);
          }
       //}
    }
  }

  bool hasPathTo(int v){
    return mMarked[v];
  }

  List<int>? pathTo(int v){
    if(!hasPathTo(v)) return null;
    List<int> path = [];
    for(int x = v; x != mSourceV; x = mEdgeTo[x]){
      path.add(x);
    }
    path.add(mSourceV);
    return path;
  }
}

class BreadthFirstPaths
{
  late List<bool> mMarked;
  late List<int> mEdgeTo;
  late int mSourceV;

  BreadthFirstPaths(Graph g, s){
    mSourceV = s;
    mMarked = List<bool>.filled(g.mV, false);
    mEdgeTo = List<int>.filled(g.mV, -1);
    bfs(g, mSourceV);
  }

  void bfs(Graph g, int s){
    Queue<int> queue = Queue<int>();
    mMarked[s] = true;
    queue.add(s);
    while(queue.isNotEmpty){
      int v = queue.removeFirst();
      for (int w in g.adj(v)){
        if(!mMarked[w]){
          mEdgeTo[w] = v;
          mMarked[w] = true;
          queue.add(w);
        }
      }
    }
  }

  bool hasPathTo(int v){
    return mMarked[v];
  }

  List<int>? pathTo(int v){
    if(!hasPathTo(v)) return null;
    List<int> path = [];
    for(int x = v; x != mSourceV; x = mEdgeTo[x]){
      path.add(x);
    }
    path.add(mSourceV);
    return path;
  }
}

class Bipartite
{
  late List<bool> mMarked;
  late List<bool> mColor;
  bool mIsBipartite = true;
  
  Bipartite(Graph g)
  {
    mMarked = List<bool>.filled(g.mV, false);
    mColor = List<bool>.filled(g.mV, true);
    
    for(int s = 0; s < g.mV; s++){
      if(!mMarked[s]){
        dfs(g, s);
      }
    }
  }
  
  void dfs(Graph g, int v)
  {
    mMarked[v] = true;
    for(int w in g.adj(v)){
      if(!mMarked[w]){
        mColor[w] = !mColor[v];
        dfs(g, w);
      }
      else if(mColor[w] == mColor[v]){
        mIsBipartite = false;
        return;
      }
    }
  }
  
  bool isBipartite() => mIsBipartite;
}

void main() {
  print("start");
  Graph g = Graph(6);
  
  
  g.addEdge(0,1);
  //g.addEdge(0,2);
  g.addEdge(0,3);
  //g.addEdge(0,4);
  g.addEdge(0,5);
  
  //g.addEdge(1,2);
  g.addEdge(1,3);
  g.addEdge(1,4);
  //g.addEdge(1,5);

  g.addEdge(2,3);
  //g.addEdge(2,4);
  g.addEdge(2,5);

  g.addEdge(3,4);
  //g.addEdge(3,5);
  
  g.addEdge(4,5);
 
  g.printGraph();

  print("breadth first search from vertex 0 to 5");
  BreadthFirstPaths bfP = BreadthFirstPaths(g, 0);
  List<int>? pathB = bfP.pathTo(5);
  if(pathB != null) {
    for(int i in pathB){
      print(i.toStringAsFixed(0));
    }
  }

  print("depth first search from vertex 0 to 5");
  DepthFirstPaths dfP = DepthFirstPaths(g, 0);
  List<int>? pathD = dfP.pathTo(5);
  if(pathD != null) {
    for(int i in pathD){
      print(i.toStringAsFixed(0));
    }
  }

  Bipartite bip = Bipartite(g);
  if(bip.isBipartite()){
    print("bipartite : true");
  } else {
    print("bipartite : false");
  }
  print("end");
}