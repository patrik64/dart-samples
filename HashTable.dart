ass NodeT<Key, Value>
{
  Key m_key;
  Value m_val;
  NodeT m_next;
  
  NodeT(this.m_key, this.m_val, this.m_next){}
}

class SymbolTable<Key extends Comparable, Value>
{
    NodeT<Key, Value> m_first;
    
    Value fetch(Key key){
      for(NodeT<Key, Value> x = this.m_first; x != null; x = x.m_next)
        if(key.compareTo(x.m_key) == 0)
          return x.m_val;
      return null;
    }
    
    void put(Key key, Value val){
      for(NodeT<Key, Value> x = this.m_first; x != null; x = x.m_next){
        if(key.compareTo(x.m_key) == 0){
          x.m_val = val;
          return;
        }
      }
      m_first = new NodeT(key, val, this.m_first);
    }
    
    List<Key> keys(){
      List<Key> ret = new List<Key>();
      for(NodeT<Key, Value> x = this.m_first; x != null; x = x.m_next){
        ret.add(x.m_key);
      }
      return ret;
    }
}

//Hash Table implementation with separate chaining
class HashTableSC<Key extends Comparable, Value> 
{
  int m_N = 0;
  int m_M = 0;
  List<SymbolTable<Key, Value>> m_st;
  
  HashTableSC(this.m_M) {
    this.m_st = new List<SymbolTable<Key, Value>>(this.m_M);
    for(int i = 0; i < this.m_st.length; i++) {
      SymbolTable<Key, Value> st = new SymbolTable<Key, Value>();
      m_st[i] = st;
    } 
  }
    
  int hash(Key key) {
    int ret = key.hashCode() % this.m_M;
    return ret;
  }
  
  Value fetch(Key key){
    return this.m_st[hash(key)].fetch(key);
  }
  
  void put(Key key, Value val){
    this.m_st[hash(key)].put(key, val);
    m_N++;
  }
  
  List<Key> keys(){
    List<Key> ret = new List<Key>();
    for( SymbolTable<Key, Value> st in this.m_st)
      for( Key k in st.keys())
        ret.add(k);
    return ret;
  }
  
  void print_hashtable() {
    String str = "Hash Table with separate chaining : /n";
    for(Key k in this.keys()){
      Value val = this.fetch(k);
      str += k.toString();
      str += " - ";
      str += val.toString();
      str += "/n";
    }
    print(str);
  }
}

//Hash Table implementation with linear probing
class HashTableLP<Key extends Comparable, Value>
{
  int m_N = 0; //number of elements in the table
  int m_M = 16; //initial table size
  List<Key> m_keys;
  List<Value> m_vals;
  
  HashTableLP(this.m_M){
    this.m_keys = new List<Key>(this.m_M);
    for(int i = 0; i < this.m_M; i++)
      m_keys[i] = null;
    this.m_vals = new List<Value>(this.m_M);
  }
  
  int hash(Key key){
    return key.hashCode() % this.m_M;
  }
  
  void put(Key key, Value val){
    if(m_N >= (m_M/2).toInt())
      resize(2*m_M);
    
    int i = hash(key);
    while(this.m_keys[i] != null){
      if(m_keys[i].compareTo(key) == 0){
        m_vals[i] = val;
        return;
      }
      i = (i+1) % this.m_M; 
    }
    m_keys[i] = key;
    m_vals[i] = val;
    m_N++;
  }
  
  Value fetch(Key key){
    for(int i = hash(key); m_keys[i] != null; i = (i+1) % m_M)
      if(m_keys[i].compareTo(key) == 0)
        return m_vals[i];
    
    return null;
  }
  
  void delete(Key key){
    if(fetch(key) == null) return;
    int i = hash(key);
    while(key.compareTo(this.m_keys[i]) != 0)
      i = (i+1) % m_M;
    this.m_keys[i] = null;
    this.m_vals[i] = null;
    i = (i+1) % m_M;
    while(this.m_keys[i] != null){
      Key _k = this.m_keys[i];
      Value _v = this.m_vals[i];
      m_keys[i] = null;
      m_vals[i] = null;
      m_N--;
      put(_k, _v);
      i = (i+1) % m_M;
    }
    m_N--;
    if((m_N > 0) && (m_N <= (m_M/8).toInt()))
      resize((m_M/2).toInt());
  }
  
  void resize(int cap){
    HashTableLP<Key, Value> ht;
    ht = new HashTableLP<Key, Value>(cap);
    for(int i = 0; i < m_M; i++)
      if(m_keys[i] != null)
        ht.put(m_keys[i], m_vals[i]);
    
    m_keys = ht.m_keys;
    m_vals = ht.m_vals;
    m_M = ht.m_M;
  }
  
  void print_hashtable() {
    String str = "Hash Table with linear probing : \n";
    for(Key k in this.m_keys){
      if(k != null){
        Value val = this.fetch(k);
        str += k.toString();
        str += " - ";
        str += val.toString();
        str += "\n";
      }
    }
    print(str);
  }
}

void main() {
  HashTableLP<String, int> ht = new HashTableLP<String, int>(16);
  ht.put("a", 1);
  ht.put("b", 2);
  ht.put("c", 3);
  ht.put("d", 4);
  ht.put("e", 5);
  ht.put("f", 6);
  ht.put("v", 7);
  ht.put("z", 8);
  ht.put("g", 9);
  ht.put("h", 10);
  ht.put("i", 11);
  ht.put("j", 12);
  ht.put("k", 13);
  ht.put("l", 14);
  ht.put("m", 15);
  ht.put("o", 16);
  ht.put("p", 17);
  ht.put("r", 18);
  ht.put("s", 19);
  ht.put("t", 20);
  ht.put("u", 21);
  
  print("\nbefore delete:\n");
  ht.print_hashtable();
  
  ht.delete("a");
  ht.delete("b");
  ht.delete("c");
  ht.delete("d");
  ht.delete("e");
  ht.delete("f");
  ht.delete("g");
  ht.delete("h");
  ht.delete("i");
  ht.delete("j");
  ht.delete("k");
  ht.delete("l");
  ht.delete("m");
  ht.delete("n");
  ht.delete("o");
  ht.delete("p");
  ht.delete("r");
  ht.delete("s");
  ht.delete("t");
  ht.delete("u");
  ht.delete("v");

  print("\after delete:\n");  
  ht.print_hashtable();
}

