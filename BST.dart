class NodeT<Key extends Comparable, Value> {
  Key mkey;
  Value mval;
  NodeT<Key, Value>? mleft, mright;
  int mN;

  NodeT(this.mkey, this.mval, this.mN);

  @override String toString() => "$mkey : $mval";
}

class BST<Key extends Comparable, Value> {
  NodeT<Key, Value>? mroot;
  
  int size(){
    return sizeNode(mroot);
  }

  int sizeNode(NodeT<Key, Value>? x) {
    if(x != null) {
      return x.mN;
    }
    return 0;
  }

  Value fetch(Key key) => fetchNode(mroot, key);

  Value fetchNode(NodeT<Key, Value>? x, Key key) {
    if(x != null) {
      int cmp = key.compareTo(x.mkey);
      if(cmp < 0){ 
        return fetchNode(x.mleft, key);
      } else if(cmp > 0) {
        return fetchNode(x.mright, key);
      } else {
        return x.mval;
      }
    }
    return null as Value;
  }

  void put(Key key, Value val){
    mroot = putNode(mroot, key, val);
  }

  NodeT<Key, Value> putNode(NodeT<Key, Value>? x, Key key, Value val) {
    if(x == null) {
      return NodeT<Key, Value>(key, val, 1);
    }

    int cmp = key.compareTo(x.mkey);
    if(cmp < 0) {
      x.mleft = putNode(x.mleft, key, val);
    }
    else if(cmp > 0) {
      x.mright = putNode(x.mright, key, val);
    } else {
      x.mval = val;
    }

    x.mN = sizeNode(x.mleft) + sizeNode(x.mright) + 1;
    return x;
  }
  
  void printbst() { 
    printbstNode(mroot);
  }
    
  void printbstNode(NodeT<Key, Value>? x) {
    if(x != null) {
      print(x.toString());
      
      print(x.mleft.toString());
            
      print(x.mright.toString());
      
      print("----");
      printbstNode(x.mleft);
      printbstNode(x.mright);
    } 
  }
}

void main() {

  BST<String, int> bst = BST<String, int>();
  bst.put("d", 3);
  bst.put("b", 1);
  bst.put("f", 5);
  bst.put("a", 0);
  bst.put("c", 2);
  bst.put("e", 4);
  bst.put("g", 6);

  bst.printbst();
}