import 'dart:collection';

class Digraph {
  late int mV;
  late int mE;
  List<List<int>> mAdj = [];

  Digraph(v) {
    mV = v;
    mE = 0;
    mAdj = List.generate(mV, (i) => []);
  }

  void addEdge(int v, int w) {
    mAdj[v].add(w);
    mE++;
  }

  List<int> adj(int v) {
    return mAdj[v];
  }

  Digraph reverse() {
    Digraph r = Digraph(mV);
    for(int v = 0; v < mV; v++){
      for(int w in mAdj[v]){
        r.addEdge(w, v);
      }
    }
    return r;
 }

  void printGraph() {
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

class DirectedDFS {

  late List<bool> mMarked;

  DirectedDFS(Digraph g, int s) {
    mMarked = List<bool>.filled(g.mV, false);
    dfs(g, s);
  }

  void dfs(Digraph g, int v) {
    mMarked[v] = true;
    for(int i in g.adj(v)) {
      if(!mMarked[i]) {
        dfs(g, i);
      }
    }
  }

  void printReachable(int v) {
    String str = "Reach from vertex ${v.toString()}  : ";
    for(int i  = 0; i < mMarked.length; i++){
      if(mMarked[i]){
        str += i.toStringAsFixed(0);
        str += " - ";
      }
    }
    str = str.substring(0, str.length - 3);
    print(str);
  }
}

class DirectedCycle {
  
  late List<bool> mMarked;
  late List<int> mEdgeTo;
  late Queue<int> mCycle;
  late List<bool> mOnStack;

  DirectedCycle(Digraph g) {
    mOnStack = List<bool>.filled(g.mV, false);
    mMarked = List<bool>.filled(g.mV, false);
    mEdgeTo = List<int>.filled(g.mV, -1);
    mCycle = Queue<int>();
    for(int v = 0; v < g.mV; v++){
      if(!mMarked[v]) {
        dfs(g, v);
      }
    }
  }

  void dfs(Digraph g, int v) {
    mOnStack[v] = true;
    mMarked[v] = true;
    for( int w in g.adj(v)){
      if(hasCycle()) {
        return;
      }
      else if(mMarked[w]){
        mEdgeTo[w] = v;
        dfs(g, w);
      }
      else if(mOnStack[w]){
        for( int x = v; x!= w; x = mEdgeTo[x] ) {
          mCycle.add(x);
        }
        mCycle.add(w);
        mCycle.add(v);
      }
    }
    mOnStack[v] = false;
  }

  bool hasCycle() => (mCycle.isNotEmpty);

  void printCycles() {
    String str = "Cycles : ";
    if(hasCycle()){
      while(mCycle.isNotEmpty){
        int i = mCycle.removeLast();
        str += "${i.toString()} - ";
      }
      str = str.substring(0, str.length - 3);
    }else{
      str = "no cycles";
    }
    print(str);
  }
}


class DirectedDepthFirstPaths {
  
  late List<bool> mMarked; 
  late List<int> mEdgeTo; //list of indices to connected vertices
  late int mSource;       //source vertex

  DirectedDepthFirstPaths(Digraph g, s){
    mSource = s;
    mMarked = List<bool>.filled(g.mV, false);
    mEdgeTo = List<int>.filled(g.mV, -1);  
    dfs(g, mSource);
  }

  void dfs(Digraph g, int v){
    mMarked[v] = true;
    for (int w in g.adj(v)){
      if(!mMarked[w]){
        mEdgeTo[w] = v;
        dfs(g, w);
      }
    }
  }

  bool hasPathTo(int v){
    return mMarked[v];
  }

  List<int>? pathTo(int v){
    if(!hasPathTo(v)) return null;
    List<int> path = [];
    for(int x = v; x != mSource; x = mEdgeTo[x]){
      path.add(x);
    }
    path.add(mSource);
    return path;
  }
  
  void printPathTo(int v){
    String str = "Depth first path from vertex ${mSource.toString()} : ";
    if(hasPathTo(v)){
      List<int>? x = pathTo(v);
      if(x != null) {
        for(int i in x){
          str += "${i.toString()} - ";  
        }
        str = str.substring(0, str.length - 3);
      }
    }else{
      str += "no path to vertex ${v.toString()}";  
    }  
    print(str);
  }
}

class DirectedBreadthFirstPaths {
  
  late List<bool> mMarked;
  late List<int> mEdgeTo;
  late int mSource;

  DirectedBreadthFirstPaths(Digraph g, s) {
    mSource = s;
    mMarked = List<bool>.filled(g.mV, false);
    mEdgeTo = List<int>.filled(g.mV, -1);
    bfs(g, mSource);
  }

  void bfs(Digraph g, int s) {
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

  bool hasPathTo(int v) {
    return mMarked[v];
  }

  List<int>? pathTo(int v) {
    if(!hasPathTo(v)) return null;
    List<int> path = [];
    for(int x = v; x != mSource; x = mEdgeTo[x]){
      path.add(x);
    }
    path.add(mSource);
    return path;
  }
  
  void printPathTo(int v) {
    String str = "Breadth first path from vertex ${mSource.toString()} : ";
    if(hasPathTo(v)){
      List<int>? x = pathTo(v);
      if(x != null) {
        for(int i in x){
          str += "${i.toString()} - ";  
        }
        str = str.substring(0, str.length - 3);
      }
    }else{
      str += "no path to vertex ${v.toString()}";  
    }  
    print(str);
  }
}

class DepthFirstOrder {

  late List<bool> mMarked;
  late Queue<int> mPre;
  late Queue<int> mPost;
  late Queue<int> mReversePost;

  DepthFirstOrder(Digraph g){
    mPre = Queue<int>();
    mPost = Queue<int>();
    mReversePost = Queue<int>();
    mMarked = List<bool>.filled(g.mV, false);
    
    for(int v = 0; v < g.mV; v++){
      if(!mMarked[v]) {
        dfs(g, v);
      }
    }
  }
  
  void dfs(Digraph g, int v) {
    mPre.add(v);
    mMarked[v] = true;
    for(int w in g.adj(v)){
      if(!mMarked[w]) {
        dfs(g, w);
      }
    }
    
    mPost.add(v);
    mReversePost.addLast(v);
  }
  
  void printOrder() {
    String str = "Pre : ";
    while(mPre.isNotEmpty){
      int i = mPre.removeFirst();
      str += "${i.toString()} ";
    }
    print(str);
    
    str = "Post : ";
    while(mPost.isNotEmpty){
      int i = mPost.removeFirst();
      str += "${i.toString()} ";
    }
    print(str);
    
    str = "PostReverse : ";
    while(mReversePost.isNotEmpty){
      int i = mReversePost.removeLast();
      str += "${i.toString()} ";
    }
    print(str);
  }
}

class TopologicalOrder {
  Queue<int> mOrder = Queue<int>();
  
  TopologicalOrder(Digraph g){
    DirectedCycle cyclefinder = DirectedCycle(g);
    if(!cyclefinder.hasCycle()){
      DepthFirstOrder dfs = DepthFirstOrder(g);
      mOrder = dfs.mReversePost;
    }
  }
  
  bool isDAG() => mOrder.isNotEmpty;
}

void main() {
  Digraph g = Digraph(13);
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
    
  g.printGraph();

  //g.reverse().printGraph();

  DirectedDFS dfs = DirectedDFS(g, 0);
  dfs.printReachable(0);
  
  DirectedDepthFirstPaths ddfp = DirectedDepthFirstPaths(g, 8);
  ddfp.printPathTo(4);
  
  DirectedBreadthFirstPaths dbfp = DirectedBreadthFirstPaths(g, 8);
  dbfp.printPathTo(4);
  
  DirectedCycle c = DirectedCycle(g);
  c.printCycles();
  
  DepthFirstOrder order = DepthFirstOrder(g);
  order.printOrder();
  
  TopologicalOrder topo = TopologicalOrder(g);
  if(topo.isDAG()) {
    print("topo : true");
  } else {
    print("topo : false");
  }
}