import 'dart:collection';

class MaxPQ<T extends Comparable> {
  List<T> m_pq;
  int m_N = 0;
  
  MaxPQ(int maxN) {
    m_pq = new List<T>(maxN+1);
  }
  
  bool isEmpty() {
    return m_N == 0;
  }
  
  int size() => m_N;
  
  void insert(T item) {
    m_N++;
    m_pq[m_N] = item;
    swim(m_N);
  }
  
  T delMax() {
    T max = m_pq[1];
    exch(1, m_N--);
    m_pq[m_N+1] = null;
    sink(1);
    return max;
  }
  
  bool less(int i, int j) => m_pq[i].compareTo(m_pq[j]) < 0;
  
  void exch(int i, int j) {
    T t = m_pq[i];
    m_pq[i] = m_pq[j];
    m_pq[j] = t;
  }
  
  void swim(int k) {
    while(k > 1 && less((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k) {
    while(2*k <= m_N) {
      int j = 2*k;
      if(j < m_N && less(j, j+1)) 
        j++;
      if(!less(k,j)) 
        break;
      exch(k, j);
      k = j;
    }
  }
}

class MinPQ<T extends Comparable> {
  List<T> m_pq;
  int m_N = 0;
  
  MinPQ(int maxN) {
    m_pq = new List<T>(maxN+1);
  }
  
  bool isEmpty() {
    return m_N == 0;
  }
  
  int size() => m_N;
  
  void insert(T item) {
    m_N++;
    m_pq[m_N] = item;
    swim(m_N);
  }
  
  T delMin() {
    T min = m_pq[1];
    exch(1, m_N--);
    m_pq[m_N+1] = null;
    sink(1);
    return min;
  }
  
  bool less(int i, int j) => m_pq[i].compareTo(m_pq[j]) < 0;
  
  void exch(int i, int j) {
    T t = m_pq[i];
    m_pq[i] = m_pq[j];
    m_pq[j] = t;
  }
  
  void swim(int k) {
    while(k > 1 && !less((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k) {
    while(2*k <= m_N) {
      int j = 2*k;
      if(j < m_N && !less(j, j+1)) 
        j++;
      if(less(k,j)) 
        break;
      exch(k, j);
      k = j;
    }
  }
}

class IndexMinPQ<T extends Comparable> {
  List<int> m_pq;
  List<int> m_qp;
  List<T> m_keys;
  int m_N = 0;
  
  IndexMinPQ(int maxN) {
    this.m_pq = new List<int>(maxN+1);
    this.m_qp = new List<int>(maxN+1);
    this.m_keys = new List<T>(maxN+1);
    for(int i = 0; i < maxN + 1; i++)
      this.m_qp[i] = -1;
  }
  
  bool isEmpty() {
    return this.m_N == 0;
  }
  
  int size() => this.m_N;
  
  bool contains(int k) {
    return (this.m_qp[k] != -1);
  }

  void insert(int k, T item) {
    if(contains(k))
      throw new Exception('already contains the item!!!');
    m_N++;
    m_qp[k] = m_N;
    m_pq[m_N] = k;
    m_keys[k] = item;
    swim(m_N);
  }
  
  int delMin() {
    if(m_N == 0)
      throw new Exception('queue already empty');
    int minIdx = m_pq[1];
    exch(1, m_N--);
    sink(1);
    m_qp[minIdx] = -1;
    m_keys[m_pq[m_N+1]] = null;
    m_pq[m_N+1] = -1;
    return minIdx;
  }
  
  bool greater(int i, int j) => m_keys[m_pq[i]].compareTo(m_keys[m_pq[j]]) > 0;
  
  void exch(int i, int j){
    int t = m_pq[i];
    m_pq[i] = m_pq[j];
    m_pq[j] = t;
    m_qp[m_pq[i]] = i;
    m_qp[m_pq[j]] = j;
  }
  
  void swim(int k) {
    while(k > 1 && greater((k~/2), k)) {
      exch((k~/2), k);
      k = k~/2;
    } 
  }
  
  void sink(int k){
    while(2*k <= m_N){
      int j = 2*k;
      if(j < m_N && greater(j, j+1)) 
        j++;
      if(!greater(k,j)) 
        break;
      exch(k, j);
      k = j;
    }
  }
  
  void change(int k, T item){
    m_keys[k] = item;
    swim(m_qp[k]);
    sink(m_qp[k]);  
  }
}

class Edge implements Comparable
{
  int m_v;
  int m_w;
  int m_weight;
  
  Edge(this.m_v, this.m_w, this.m_weight){}
  
  int either() => this.m_v;
  
  int other(int vertex){
    if(vertex == m_v) return m_w;
    if(vertex == m_w) return m_v;
    throw new Exception('the edge doesnt contain vertex ${vertex}!');
  }
  
  int compareTo(Edge that){
    if(this.m_weight < that.m_weight) return -1;
    if(this.m_weight > that.m_weight) return 1;
    return 0;
  }
  
  String toString() => "${m_v.toString()} - ${m_w.toString()} | ${m_weight.toString()}";
}

class WeightedGraph
{
  int m_V;
  int m_E;
  List<List<Edge>> m_Adj;
  
  WeightedGraph(this.m_V){
    m_E = 0;
    m_Adj = new List<List<Edge>>(this.m_V);
    for(int i = 0; i < this.m_V; i++)
      m_Adj[i] = new List<Edge>();
  }
  
  void addEdge(Edge e){
    int v = e.either();
    int w = e.other(v);
    m_Adj[v].add(e);
    m_Adj[w].add(e);
    m_E++;  
  }
  
  List<Edge> adj(int v) => this.m_Adj[v];
  
  List<Edge> edges(){
    List<Edge> ret = new List<Edge>();
    for(int v = 0; v < m_V; v++)
      for(Edge e in m_Adj[v])
        if(e.other(v) > v)
          ret.add(e);
      
    return ret;
  }
  
  void print_graph(){
    String str = "Number of vertices : ${this.m_V.toString()}\n";
    str += "Number of edges : ${this.m_E.toString()}\n";
    for(int i = 0; i < this.m_V; i++){
      str += "${i.toStringAsFixed(0)} ->  ";
      for(Edge e in this.m_Adj[i]){
        str += "${e.toString()}, ";
      }
      str = str.substring(0, str.length - 2);
      str += "\n";
    }
    print(str);
  }
}

class PrimMST
{
  List<bool> m_marked;
  Queue<Edge> m_mst;
  MinPQ<Edge> m_pq;
  
  PrimMST(WeightedGraph g){
    m_pq = new MinPQ<Edge>(100);
    m_marked = new List<bool>(g.m_V);
    m_marked.forEach((e) => e = false);
    m_mst = new Queue<Edge>();
    
    visit(g, 0);
    while(!m_pq.isEmpty()){
      Edge e = m_pq.delMin();
      int v = e.either();
      int w = e.other(v);
      if(m_marked[v] && m_marked[w])
        continue;
      m_mst.add(e);
      if(!m_marked[v]) visit(g, v);
      if(!m_marked[w]) visit(g, w);
    }
  }
  
  void visit(WeightedGraph g, int v){
    m_marked[v] = true;
    for(Edge e in g.adj(v))
      if(!m_marked[e.other(v)])
        m_pq.insert(e);
  }
    
  print_mst(){
    String strEdges = "Prim Minimum Spanning Tree : ";
    for(Edge e in m_mst)
      strEdges += "${e.toString()}, "; 
    strEdges = strEdges.substring(0, strEdges.length - 2);
    print(strEdges);
  }
}

class Dijkstra
{
  List<Edge> m_edgeTo;
  List<int> m_distTo;
  IndexMinPQ<int> m_pq;
  
  Dijkstra(WeightedGraph g, int s){
    this.m_edgeTo = new List<Edge>(g.m_V);
    this.m_distTo = new List<int>(g.m_V);
    this.m_pq = new IndexMinPQ<int>(g.m_V);
    for(int i = 0; i < g.m_V; i++){
      this.m_distTo[i] = 1000;
      this.m_edgeTo[i] = new Edge(0, 0, 0);
    }
    this.m_distTo[s] = 0;
    
    this.m_pq.insert(s, 0);
    while(!this.m_pq.isEmpty()) {
      relax(g, this.m_pq.delMin());
    }
  }
  
  void relax(WeightedGraph g, int v) {
    for(Edge e in g.adj(v)) {
      int w = e.other(v);
      if(this.m_distTo[w] > (this.m_distTo[v] + e.m_weight)) {
        this.m_distTo[w] = this.m_distTo[v] + e.m_weight;
        this.m_edgeTo[w] = e;
        if(this.m_pq.contains(w)) {
          this.m_pq.change(w, m_distTo[w]);
        } else {
          this.m_pq.insert(w, m_distTo[w]);
        }
      }
    }
  }
  
  int distTo(int v) => this.m_distTo[v];
  
  bool hasPathTo(int v) => this.m_distTo[v] != 1000;
  
  List<Edge> pathTo(int v) {
    if(!hasPathTo(v)) 
      return null;
    List<Edge> path = new List<Edge>();
    Edge e = m_edgeTo[v];
    while(e.either() != e.other(e.either())) {
      path.add(e);
      v = e.other(v);
      e = m_edgeTo[v];
    }
    return path;
  }

  print_path(List<Edge> path){
    String strEdges = "Dijkstra path : ";
    for(int i = 0; i < path.length; i++){
      strEdges += path[i].toString();
      strEdges += "   ";
    }    
    print(strEdges);
  }
  
  print_dijkstra(){
    String strEdges = "Dijkstra : ";
    for(int i = 0; i < this.m_edgeTo.length; i++) {
      strEdges += this.m_edgeTo[i].toString();
      strEdges += "   ";
    }  
    print(strEdges);  
  }
}

void main() {
   
  WeightedGraph g = new WeightedGraph(6);
  g.addEdge(new Edge(0,1,5));
  g.addEdge(new Edge(0,3,7));
  //g.addEdge(new Edge(0,5,10));
  g.addEdge(new Edge(1,2,4));
  g.addEdge(new Edge(1,3,6));
  g.addEdge(new Edge(1,4,8));
  g.addEdge(new Edge(2,4,9));
  g.addEdge(new Edge(2,5,3));
  g.addEdge(new Edge(3,4,2));
  g.addEdge(new Edge(4,5,2));
  
  g.print_graph();  
  
  PrimMST p = new PrimMST(g);
  p.print_mst();
  
  int from = 0;
  int to = 5;
  Dijkstra dk = new Dijkstra(g, from);
  if(dk.hasPathTo(to)){
    List<Edge> path = dk.pathTo(to);
    dk.print_path(path);
    print("distance : ${dk.distTo(to).toString()}");
  }
  else
    print("no path from ${from.toString()} to ${to.toString()}");
}
