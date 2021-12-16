class NodeT<Key extends Comparable, Value> {
  late Key mkey;
  late Value mval;
  NodeT<Key, Value>? mleft;
  NodeT<Key, Value>? mright;
  int mN = 0;
  bool mcolor = false;

  NodeT(mk, mv, n, mc) {
    mkey = mk;
    mval = mv;
    mN = n;
    mcolor = mc;
  }
    
  @override String toString() => "$mkey : $mval : $mcolor";
}

class RedBlackBST<Key extends Comparable, Value> {
  NodeT<Key, Value>? mroot;
  static const bool red = true;
  static const bool black = false;

  bool isRed(NodeT<Key, Value>? x) {
    if(x == null) {
      return false;
    }
    return x.mcolor == red;
  }
  
  NodeT<Key, Value>? rotateLeft(NodeT<Key, Value>? h) {
    if(h != null) {
      NodeT<Key, Value>? x = h.mright;
      if(x != null) {
        h.mright = x.mleft;
        x.mleft = h;
        x.mcolor = h.mcolor;
        h.mcolor = red;
        x.mN = h.mN;
        h.mN = 1 + sizeN(h.mleft) + sizeN(h.mright);
        return x;
      }
    }
    return null;
  }

  NodeT<Key, Value>? rotateRight(NodeT<Key, Value>? h) {
    if(h != null) {
      NodeT<Key, Value>? x = h.mleft;
      if(x != null) {
        h.mleft = x.mright;
        x.mright = h;
        x.mcolor = h.mcolor;
        h.mcolor = red;
        x.mN = h.mN;
        h.mN = 1 + sizeN(h.mleft) + sizeN(h.mright);
        return x;
      }
    }
    return null;
  }

  void flipColors(NodeT<Key,Value>? h) {
    if(h != null) {
      h.mcolor = red;
      NodeT<Key, Value>? ll = h.mleft;
      if(ll != null) {
        ll.mcolor = black;
      }
      NodeT<Key, Value>? rr = h.mright;
      if(rr != null) {
        rr.mcolor = black;
      }
    }
  }
  
  int size() => sizeN(mroot);

  int sizeN(NodeT<Key, Value>? x) {
    if(x == null) {
      return 0;  
    }
    else {
      return x.mN;
    }
  }
  
  void put(Key key, Value val) {
    NodeT<Key, Value>? mr = putN(mroot, key, val);
    if(mr != null) {
      mr.mcolor = black;
      mroot = mr;
    }
  }

  NodeT<Key, Value>? putN(NodeT<Key, Value>? h, Key key, Value val) {
    
    if(h == null) {
      NodeT<Key, Value> test = NodeT(key, val, 1, red);
      print(test.toString());
      return test;
    }
    
    int cmp = key.compareTo(h.mkey);
    
    if(cmp < 0) {
      h.mleft = putN(h.mleft, key, val);
    } else if(cmp > 0) {
      h.mright = putN(h.mright, key, val);
    } else {
      h.mval = val;
    }

    if(isRed(h.mright) && !isRed(h.mleft)) {
      h = rotateLeft(h);
    }
    
    if(h != null) {
      NodeT<Key, Value>? ll = h.mleft;
      if(ll != null) {
        NodeT<Key, Value>? lll = ll.mleft;
        if(lll != null) {
          if(isRed(ll) && isRed(lll)) {
            h = rotateRight(h);
          }
        }
        NodeT<Key, Value>? rrr = ll.mright;
        if(rrr != null) {
          if(isRed(ll) && isRed(rrr)) {
            flipColors(h);
          }
        }
      }
    }
       
    if(h != null) {
      h.mN = sizeN(h.mleft) + sizeN(h.mright) + 1;
    }
    return h;
  }

  Value? fetch(Key key) => fetchN(mroot, key);

  Value? fetchN(NodeT<Key, Value>? x, Key key) {
    if(x == null) {
      return null;
    }
    int cmp = key.compareTo(x.mkey);
    if(cmp < 0) {
      return fetchN(x.mleft, key);
    } else if (cmp > 0) {
      return fetchN(x.mright, key);
    } else {
      return x.mval;
    }
  }

  void printbst() => printbstN(mroot);
  
  void printbstN(NodeT<Key, Value>? x) {
    if(x != null) {
      print(x.toString());
      if(x.mleft != null) {
        print(x.mleft.toString());
      } else {
        print("null");
      }
      if(x.mright != null) {
        print(x.mright.toString());
      } else {
        print("null");
      }
      print("--");
      printbstN(x.mleft);      
      printbstN(x.mright);  
    }
  }
}

void main() {
  print("red black");
  RedBlackBST<String, int> bst = RedBlackBST<String, int>();
  bst.put("a", 0);
  bst.put("b", 1);
  bst.put("c", 2);
  bst.put("d", 3);
  bst.put("e", 4);
  bst.put("f", 5);
  bst.put("g", 6);
  
  bst.printbst();
}