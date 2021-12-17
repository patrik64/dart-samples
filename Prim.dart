import 'dart:collection';

class MaxPQ<T extends Comparable> {

  late List<T?> mPQ;
  int mN = 0;
  
  MaxPQ(int maxN) {
    mPQ = List<T?>.filled(maxN+1, null);
  }
  
  bool isEmpty() {
    return mN == 0;
  }
  
  int size() => mN;
  
  void insert(T item) {
    mN++;
    mPQ[mN] = item;
    swim(mN);
  }
  
  T? delMax() {
    T? max = mPQ[1];
    exch(1, mN--);
    mPQ[mN+1] = null;
    sink(1);
    return max;
  }
  
  bool less(int i, int j) {
    T? test1 = mPQ[i];
    T? test2 = mPQ[i];
    if(test1 != null && test2 != null) {
      return test1.compareTo(test2) < 0;
    }
    return false;
  }
  
  void exch(int i, int j) {
    T? t = mPQ[i];
    mPQ[i] = mPQ[j];
    mPQ[j] = t;
  }
  
  void swim(int k) {
    while(k > 1 && less((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k) {
    while(2*k <= mN) {
      int j = 2*k;
      if(j < mN && less(j, j+1)) {
        j++;
      }
      if(!less(k,j)) {
        break;
      }
      exch(k, j);
      k = j;
    }
  }
}

class MinPQ<T extends Comparable> {
  late List<T?> mPQ;
  int mN = 0;
  
  MinPQ(int maxN) {
    mPQ = List<T?>.filled(maxN+1, null);
  }
  
  bool isEmpty() {
    return mN == 0;
  }
  
  int size() => mN;
  
  void insert(T item) {
    mN++;
    mPQ[mN] = item;
    swim(mN);
  }
  
  T? delMin() {
    T? min = mPQ[1];
    exch(1, mN--);
    mPQ[mN+1] = null;
    sink(1);
    return min;
  }
  
  bool less(int i, int j) {
    T? test1 = mPQ[i];
    T? test2 = mPQ[i];
    if(test1 != null && test2 != null) {
      return test1.compareTo(test2) < 0;
    }
    return false;
  }
  
  void exch(int i, int j) {
    T? t = mPQ[i];
    mPQ[i] = mPQ[j];
    mPQ[j] = t;
  }
  
  void swim(int k) {
    while(k > 1 && !less((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k) {
    while(2*k <= mN) {
      int j = 2*k;
      if(j < mN && !less(j, j+1)) {
        j++;
      }
      if(less(k,j)) {
        break;
      }
      exch(k, j);
      k = j;
    }
  }
}

class IndexMinPQ<T extends Comparable> {
  late List<int> mPQ;
  late List<int> mQP;
  late List<T?> mKeys;
  int mN = 0;
  
  IndexMinPQ(int maxN) {
    mPQ = List<int>.filled(maxN+1, -1);
    mQP = List<int>.filled(maxN+1, -1);
    mKeys = List<T?>.filled(maxN+1, null);
  }
  
  bool isEmpty() {
    return mN == 0;
  }
  
  int size() => mN;
  
  bool contains(int k) {
    return (mQP[k] != -1);
  }

  void insert(int k, T item) {
    if(contains(k)) {
      throw Exception('already contains the item!!!');
    }
    mN++;
    mQP[k] = mN;
    mPQ[mN] = k;
    mKeys[k] = item;
    swim(mN);
  }
  
  int delMin() {
    if(mN == 0) {
      throw Exception('queue already empty');
    }
    int minIdx = mPQ[1];
    exch(1, mN--);
    sink(1);
    mQP[minIdx] = -1;
    mKeys[mPQ[mN+1]] = null;
    mPQ[mN+1] = -1;
    return minIdx;
  }
  
  //bool greater(int i, int j) {
  //  mKeys[mPQ[i]].compareTo(mKeys[mPQ[j]]) > 0;
  //}
  
  bool greater(int i, int j) {
    T? test1 = mKeys[mPQ[i]];
    T? test2 = mKeys[mPQ[j]];
    if(test1 != null && test2 != null) {
      return test1.compareTo(test2) > 0;
    }
    return false;
  }
  
  void exch(int i, int j) {
    int t = mPQ[i];
    mPQ[i] = mPQ[j];
    mPQ[j] = t;
    mQP[mPQ[i]] = i;
    mQP[mPQ[j]] = j;
  }
  
  void swim(int k) {
    while(k > 1 && greater((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k){
    while(2*k <= mN){
      int j = 2*k;
      if(j < mN && greater(j, j+1)) {
        j++;
      }
      if(!greater(k,j)) {
        break;
      }
      exch(k, j);
      k = j;
    }
  }
  
  void change(int k, T item) {
    mKeys[k] = item;
    swim(mQP[k]);
    sink(mQP[k]);  
  }
}

class Edge implements Comparable {
  
  late int mV;
  late int mW;
  late int mWeight;
  
  Edge(v, w, weight) {
    mV = v;
    mW = w;
    mWeight = weight;
  }
  
  int either() => mV;
  
  int other(int vertex) {
    if(vertex == mV) { return mW; }
    if(vertex == mW) { return mV; }
    throw Exception('the edge doesn\'t contain vertex $vertex!');
  }

  @override int compareTo(dynamic that) {
    Edge t = that as Edge;
    if(mWeight < t.mWeight) { return -1; }
    if(mWeight > t.mWeight) { return 1; }
    return 0;
  }
  
  @override String toString() => "${mV.toString()} - ${mW.toString()} | ${mWeight.toString()}";
}

class WeightedGraph {
  late int mV;
  late int mE;
  List<List<Edge>> mAdj = [];
  
  WeightedGraph(v) {
    mV = v;
    mE = 0;
    mAdj = List.generate(mV, (i) => []);
  }
  
  void addEdge(Edge e) {
    int v = e.either();
    int w = e.other(v);
    mAdj[v].add(e);
    mAdj[w].add(e);
    mE++;  
  }
  
  List<Edge> adj(int v) => mAdj[v];
  
  List<Edge> edges() {
    List<Edge> ret = [];
    for(int v = 0; v < mV; v++) {
      for(Edge e in mAdj[v]) {
        if(e.other(v) > v) {
          ret.add(e);
        }
      }
    }
    return ret;
  }
  
  void printGraph() {
    String str = "Number of vertices : ${mV.toString()}\n";
    str += "Number of edges : ${mE.toString()}\n";
    for(int i = 0; i < mV; i++){
      str += "${i.toStringAsFixed(0)} ->  ";
      for(Edge e in mAdj[i]){
        str += "${e.toString()}, ";
      }
      str = str.substring(0, str.length - 2);
      str += "\n";
    }
    print(str);
  }
}

class PrimMST {
  
  late List<bool> mMarked;
  late Queue<Edge> mMst;
  late MinPQ<Edge> mPQ;
  
  PrimMST(WeightedGraph g) {
    mPQ = MinPQ<Edge>(100);
    mMarked = List<bool>.filled(g.mV, false);
    mMst = Queue<Edge>();
    
    visit(g, 0);
    while(!mPQ.isEmpty()){
      Edge? e = mPQ.delMin();
      if(e != null) {
        int v = e.either();
        int w = e.other(v);
        if(mMarked[v] && mMarked[w]) {
          continue;
        }
        mMst.add(e);
        if(!mMarked[v]) { visit(g, v); }
        if(!mMarked[w]) { visit(g, w); }
      }
    }
  }
  
  void visit(WeightedGraph g, int v) {
    mMarked[v] = true;
    for(Edge e in g.adj(v)){
      if(!mMarked[e.other(v)]) {
        mPQ.insert(e);
      }
    }
  }
    
  void printMst() {
    String strEdges = "Prim Minimum Spanning Tree : ";
    for(Edge e in mMst) {
      strEdges += "${e.toString()}, "; 
    }
    strEdges = strEdges.substring(0, strEdges.length - 2);
    print(strEdges);
  }
}

class Dijkstra {
  late List<Edge> mEdgeTo;
  late List<int> mDistTo;
  late IndexMinPQ<int> mPQ;
  
  Dijkstra(WeightedGraph g, int s) {
    mEdgeTo = List<Edge>.filled(g.mV, Edge(0, 0, 0));
    mDistTo = List<int>.filled(g.mV, 1000);
    mPQ = IndexMinPQ<int>(g.mV);
    
    mDistTo[s] = 0;
    
    mPQ.insert(s, 0);
    while(!mPQ.isEmpty()) {
      relax(g, mPQ.delMin());
    }
  }
  
  void relax(WeightedGraph g, int v) {
    for(Edge e in g.adj(v)) {
      int w = e.other(v);
      if(mDistTo[w] > (mDistTo[v] + e.mWeight)) {
        mDistTo[w] = mDistTo[v] + e.mWeight;
        mEdgeTo[w] = e;
        if(mPQ.contains(w)) {
          mPQ.change(w, mDistTo[w]);
        } else {
          mPQ.insert(w, mDistTo[w]);
        }
      }
    }
  }
  
  int distTo(int v) => mDistTo[v];
  
  bool hasPathTo(int v) => mDistTo[v] != 1000;
  
  List<Edge>? pathTo(int v) {
    if(!hasPathTo(v)) {
      return null;
    }
    List<Edge> path = [];
    Edge e = mEdgeTo[v];
    while(e.either() != e.other(e.either())) {
      path.add(e);
      v = e.other(v);
      e = mEdgeTo[v];
    }
    return path;
  }

  printPath(List<Edge>? path) {
    if(path != null) {
      String strEdges = "Dijkstra path : ";
      for(int i = 0; i < path.length; i++){
        strEdges += path[i].toString();
        strEdges += "   ";
      }    
      print(strEdges);
    } else {
      print("path is null!");
    }
  }
  
  printDijkstra() {
    String strEdges = "Dijkstra : ";
    for(int i = 0; i < mEdgeTo.length; i++) {
      strEdges += mEdgeTo[i].toString();
      strEdges += "   ";
    }  
    print(strEdges);  
  }
}

void main() {
   
  WeightedGraph g = WeightedGraph(6);
  g.addEdge(Edge(0,1,5));
  g.addEdge(Edge(0,3,7));
  //g.addEdge(Edge(0,5,10));
  g.addEdge(Edge(1,2,4));
  g.addEdge(Edge(1,3,6));
  g.addEdge(Edge(1,4,8));
  g.addEdge(Edge(2,4,9));
  g.addEdge(Edge(2,5,3));
  g.addEdge(Edge(3,4,2));
  g.addEdge(Edge(4,5,2));
  
  g.printGraph();  
  
  PrimMST p = PrimMST(g);
  p.printMst();
  
  int from = 0;
  int to = 5;
  Dijkstra dk = Dijkstra(g, from);
  if(dk.hasPathTo(to)) {
    List<Edge>? path = dk.pathTo(to);
    dk.printPath(path);
    print("distance : ${dk.distTo(to).toString()}");
  }
  else {
    print("no path from ${from.toString()} to ${to.toString()}");
  }
}