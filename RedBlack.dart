class NodeT<Key extends Comparable, Value> {
  Key m_key;
  Value m_val;
  NodeT<Key, Value> m_left;
  NodeT<Key, Value> m_right;
  int m_N = 0;
  bool m_color = false;

  NodeT(this.m_key, this.m_val, this.m_N, this.m_color) {}
  
  String toString() => "${m_key} : ${m_val} : ${m_color}";
}

class RedBlackBST<Key extends Comparable, Value> {
  NodeT m_root;
  static final bool RED = true;
  static final bool BLACK = false;

  bool isRed(NodeT<Key, Value> x) {
    if(x == null)
      return false;
    return x.m_color == RED;
  }
  
  NodeT<Key, Value> rotateLeft(NodeT<Key, Value> h) {
    NodeT<Key, Value> x = h.m_right;
    h.m_right = x.m_left;
    x.m_left = h;
    x.m_color = h.m_color;
    h.m_color = RED;
    x.m_N = h.m_N;
    h.m_N = 1 + sizeN(h.m_left) + sizeN(h.m_right);
    return x;
  }

  NodeT<Key, Value> rotateRight(NodeT<Key, Value> h) {
    NodeT<Key, Value> x = h.m_left;
    h.m_left = x.m_right;
    x.m_right = h;
    x.m_color = h.m_color;
    h.m_color = RED;
    x.m_N = h.m_N;
    h.m_N = 1 + sizeN(h.m_left) + sizeN(h.m_right);
    return x;
  }

  void flipColors(NodeT<Key,Value> h) {
    h.m_color = RED;
    h.m_left.m_color = BLACK;
    h.m_right.m_color = BLACK;
  }
  
  int size() => sizeN(m_root);

  int sizeN(NodeT<Key, Value> x) {
    if(x == null) 
      return 0;  
    else
      return x.m_N;
  }
  
  void put(Key key, Value val) {
    m_root = putN(m_root, key, val);
    m_root.m_color = BLACK;
  }

  NodeT<Key, Value> putN(NodeT<Key, Value> h, Key key, Value val) {
    if(h == null)
      return new NodeT(key, val, 1, RED);
    int cmp = key.compareTo(h.m_key);
    if(cmp < 0)
      h.m_left = putN(h.m_left, key, val);
    else if(cmp > 0)
      h.m_right = putN(h.m_right, key, val);
    else
      h.m_val = val;

    if(isRed(h.m_right) && !isRed(h.m_left)) 
      h = rotateLeft(h);
    if(isRed(h.m_left) && isRed(h.m_left.m_left)) 
      h = rotateRight(h);
    if(isRed(h.m_left) && isRed(h.m_right))
      flipColors(h);
    
    h.m_N = sizeN(h.m_left) + sizeN(h.m_right) + 1;
    return h;
  }

  Value fetch(Key key) => fetchN(m_root, key);

  Value fetchN(NodeT<Key, Value> x, Key key) {
    if(x == null)
      return null;
    int cmp = key.compareTo(x.m_key);
    if(cmp < 0)
      return fetchN(x.m_left, key);
    else if (cmp > 0)
      return fetchN(x.m_right, key);
    else
      return x.m_val;
  }

  print_bst() => print_bstN(m_root);
  
  print_bstN(NodeT<Key, Value> x) {
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
      print("--");
      print_bstN(x.m_left);      
      print_bstN(x.m_right);  
    }
  }
}

void main() {
  print("red black");
  RedBlackBST<String, int> bst = new RedBlackBST<String, int>();
  bst.put("a", 0);
  bst.put("b", 1);
  bst.put("c", 2);
  bst.put("d", 3);
  bst.put("e", 4);
  bst.put("f", 5);
  bst.put("g", 6);
  
  bst.print_bst();
}

