//NFA GREP

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
  
  DirectedDFS.a(Digraph g, List<int> sources) {
    mMarked = List<bool>.filled(g.mV, false);
    for(int s in sources) {
      if(!mMarked[s]) {
        dfs(g, s);
      }
    }
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

class NFA {
  late Digraph mG;
  String mRegexp = '';
  int mM = 0;

  NFA(regexp) {
    mRegexp =regexp;
    mM = mRegexp.length;
    Queue<int> ops = Queue<int>();
    mG = Digraph(mM+1);
    for(int i = 0; i < mM; i++) {
      int lp = i;
      if(mRegexp[i] == '(' || mRegexp[i] == '|') {
        ops.add(i);
      } else if(mRegexp[i] == ')') {
        int or = ops.removeLast();
        if(mRegexp[or] == '|') {
          lp = ops.removeLast();
          mG.addEdge(lp, or+1);
          mG.addEdge(or, i);
        } else if (mRegexp[or] == '(') {
          lp = or;
        } else {
          throw Exception("shouldnt came here!!!");
        }
      }

      //lookahead
      if( i < (mM - 1) && mRegexp[i+1] == '*') {
        mG.addEdge(lp, i+1);
        mG.addEdge(i+1, lp);
      }
      if( i < (mM - 1) && mRegexp[i+1] == '+') {
        mG.addEdge(i+1, lp);
      }
      if(mRegexp[i] == '(' ||
         mRegexp[i] == '*' ||
         mRegexp[i] == '+' || 
         mRegexp[i] == ')') {
        mG.addEdge(i, i+1);
      }
    }
  }

  bool match(String txt) {
    DirectedDFS dfs = DirectedDFS(mG, 0);
    List<int> pc = [];
    for(int v = 0; v < mG.mV; v++) {
      if(dfs.mMarked[v]) {
        pc.add(v);
      }
    }

    //compute possible states for txt[i+1]
    for(int i = 0; i < txt.length; i++) {
      List<int> regexpMatch = [];
      for(int v in pc) {
        if(v == mM) { continue; }
        if((mRegexp[v] == txt[i]) || mRegexp[v] == '.') {
          regexpMatch.add(v+1);
        }
      }
      dfs = DirectedDFS.a(mG, regexpMatch);
      pc = [];
      for(int v = 0; v < mG.mV; v++) {
        if(dfs.mMarked[v]) {
          pc.add(v);
        }
      }
    }

    for(int v in pc) {
      if(v == mM) {
        return true;
      }
    }
    return false; 
  }
}

void main() {
  String regexp = "(A*B|AC)+D";
  String txt = "BD";
  NFA nfa = NFA(regexp);
  

  print("regexp : $regexp");
  print("text : $txt");
  if(nfa.match(txt)) {
    print("text matched!!!");
  } else {
    print("No match!");
  }
}