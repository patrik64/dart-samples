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

  DirectedDFS.a(Digraph g, List<int> sources) {
    this.m_marked = new List<bool>(g.m_V);
    this.m_marked.forEach((e) => e = false);
    for(int s in sources) 
      if(!this.m_marked[s])
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

class NFA {
  Digraph m_g;
  String m_regexp;
  int m_M = 0;

  NFA(this.m_regexp) {
    m_M = this.m_regexp.length;
    Queue<int> ops = new Queue<int>();
    m_g = new Digraph(m_M+1);
    for(int i = 0; i < m_M; i++) {
      int lp = i;
      if(m_regexp[i] == '(' || m_regexp[i] == '|')
        ops.add(i);
      else if(m_regexp[i] == ')') {
        int or = ops.removeLast();
        if(m_regexp[or] == '|') {
          lp = ops.removeLast();
          m_g.addEdge(lp, or+1);
          m_g.addEdge(or, i);
        }
        else if (m_regexp[or] == '(')
          lp = or;
        else 
          throw new Exception("shouldnt came here!!!");
      }

      //lookahead
      if( i < (m_M - 1) && m_regexp[i+1] == '*') {
        m_g.addEdge(lp, i+1);
        m_g.addEdge(i+1, lp);
      }
      if(m_regexp[i] == '(' || 
         m_regexp[i] == '*' || 
         m_regexp[i] == '+' || 
         m_regexp[i] == ')')
        m_g.addEdge(i, i+1);
    }
  }

  bool match(String txt) {
    DirectedDFS dfs = new DirectedDFS(m_g, 0);
    List<int> pc = new List<int>();
    for(int v = 0; v < m_g.m_V; v++)
      if(dfs.m_marked[v])
        pc.add(v);

    //compute possible states for txt[i+1]
    for(int i = 0; i < txt.length; i++) {
      List<int> regexp_match = new List<int>();
      for(int v in pc) {
        if(v == m_M) 
          continue;
        if((m_regexp[v] == txt[i]) || m_regexp[v] == '.')
          regexp_match.add(v+1);
      }
      dfs = new DirectedDFS.a(m_g, regexp_match);
      pc = new List<int>();
      for(int v = 0; v < m_g.m_V; v++)
        if(dfs.m_marked[v])
          pc.add(v);
    }

    
    for(int v in pc) 
      if(v == m_M)
        return true;
    return false; 
  }
}

void main() {
  String regexp = "(A*B|AC)+D";
  String txt = "BD";
  NFA nfa = new NFA(regexp);
  

  print("regexp : ${regexp}");
  print("text : ${txt}");
  if(nfa.match(txt))
    print("text matched!!!");
  else
    print("No match!");
}

