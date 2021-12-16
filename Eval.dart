//eval - Dijkstra double stack

import 'dart:collection';

void main() {
  Queue<String> ops = Queue<String>();
  Queue<double> vals = Queue<double>();
  String str = "(1 + ( ( 5 * 6 ) + ( 2 * 4) ) )";
  for(int i = 0; i < str.length; i++) {
    String s = str[i];
    if(s == "(" || s == " ") { continue; }
    else if(s == "+") { ops.add("+"); }
    else if(s == "-") { ops.add("-"); }
    else if(s == "*") { ops.add("*"); }
    else if(s == "/") { ops.add("/"); }
    else if(s == ")") {
      String op = ops.removeLast();
      double v = vals.removeLast();
      if(op == "+") { v += vals.removeLast(); }
      else if(op == "-") { v = vals.removeLast() - v; }
      else if(op == "*") { v *= vals.removeLast(); }
      else if(op == "/") { v = vals.removeLast() / v; }
      vals.add(v);
    } else {
      vals.add((s.codeUnitAt(0) - 48).toDouble());
    }
  }
  str += " = " + vals.removeLast().toString();
  print(str);
}