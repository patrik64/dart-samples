class NodeT<Key extends Comparable, Value> {
  Key m_key;
  Value m_val;
  NodeT<Key, Value> m_left, m_right;
  int m_N;

  NodeT(this.m_key, this.m_val, this.m_N) {}

  String toString() => "${m_key} : ${m_val}";
}

class BST<Key extends Comparable, Value> {
  NodeT<Key, Value> m_root;
  
  int size(){
    return sizeNode(m_root);
  }

  int sizeNode(NodeT<Key, Value> x) {
    if(x == null) 
      return 0; 
    else
      return x.m_N;
  }

  Value fetch(Key key) => fetchNode(m_root, key);

  Value fetchNode(NodeT<Key, Value> x, Key key) {
    if(x == null)
      return null;
    int cmp = key.compareTo(x.m_key);
    if(cmp < 0) 
      return fetchNode(x.m_left, key);
    else if(cmp > 0)
      return fetchNode(x.m_right, key);
    else 
      return x.m_val;
  }

  void put(Key key, Value val){
    this.m_root = putNode(m_root, key, val);
  }

  NodeT<Key, Value> putNode(NodeT<Key, Value> x, Key key, Value val) {
    if(x == null) 
      return new NodeT<Key, Value>(key, val, 1);

    int cmp = key.compareTo(x.m_key);
    if(cmp < 0) 
      x.m_left = putNode(x.m_left, key, val);
    else if(cmp > 0)
      x.m_right = putNode(x.m_right, key, val);
    else
      x.m_val = val;

    x.m_N = sizeNode(x.m_left) + sizeNode(x.m_right) + 1;
    return x;
  }
  
  void print_bst() { 
    print_bstNode(m_root);
  }
    
  void print_bstNode(NodeT<Key, Value> x) {
    if(x != null) {
      print(x.toString());
      
      if(x.m_left != null)
        print(x.m_left.toString());
      else
        print("null");
      
      if(x.m_right != null)
        print(x.m_right.toString());
      else
        print("null");

      print("----");
      print_bstNode(x.m_left);
      print_bstNode(x.m_right);
    } 
  }
}

void main() {

  BST<String, int> bst = new BST<String, int>();
  bst.put("d", 3);
  bst.put("b", 1);
  bst.put("f", 5);
  bst.put("a", 0);
  bst.put("c", 2);
  bst.put("e", 4);
  bst.put("g", 6);

  bst.print_bst();
}

