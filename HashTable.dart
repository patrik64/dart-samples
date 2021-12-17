class NodeT<Key, Value> {
  late Key mKey;
  late Value mVal;
  late NodeT<Key, Value>? mNext;
  
  NodeT(k, v, n) {
    mKey = k;
    mVal = v;
    mNext = n;
  }
}

class SymbolTable<Key extends Comparable, Value> {
    NodeT<Key, Value>? mFirst;
    
    Value? fetch(Key key) {
      for(NodeT<Key, Value>? x = mFirst; x != null; x = x.mNext) {
        if(key.compareTo(x.mKey) == 0) {
          return x.mVal;
        }
      }
      return null;
    }
    
    void put(Key key, Value val) {
      for(NodeT<Key, Value>? x = mFirst; x != null; x = x.mNext){
        if(key.compareTo(x.mKey) == 0) {
          x.mVal = val;
          return;
        }
      }
      mFirst = NodeT(key, val, mFirst);
    }
    
    List<Key> keys() {
      List<Key> ret = [];
      for(NodeT<Key, Value>? x = mFirst; x != null; x = x.mNext){
        ret.add(x.mKey);
      }
      return ret;
    }
}

//Hash Table implementation with separate chaining
class HashTableSC<Key extends Comparable, Value> {
  int mN = 0;
  int mM = 0;
  late List<SymbolTable<Key, Value>?> mST;
  
  HashTableSC(mM) {
    mST = List<SymbolTable<Key, Value>?>.filled(mM, null);
    for(int i = 0; i < mST.length; i++) {
      SymbolTable<Key, Value> st = SymbolTable<Key, Value>();
      mST[i] = st;
    } 
  }
    
  int hash(Key key) {
    int ret = key.hashCode % mM;
    return ret;
  }
  
  Value? fetch(Key key) {
    SymbolTable<Key, Value>? test = mST[hash(key)];
    if(test != null) {
      return test.fetch(key);
    }
  }
  
  void put(Key key, Value val) {
    SymbolTable<Key, Value>? test = mST[hash(key)];
    if(test != null) {
      test.put(key, val);
    }
    mN++;
  }
  
  List<Key> keys() {
    List<Key> ret = [];
    for( SymbolTable<Key, Value>? st in mST){
      if(st != null) {
        for( Key k in st.keys()) {
          ret.add(k);
        }
      }
    }
    return ret;
  }
  
  void printHashtable() {
    String str = "Hash Table with separate chaining : /n";
    for(Key k in keys()){
      Value? val = fetch(k);
      str += k.toString();
      str += " - ";
      str += val.toString();
      str += "/n";
    }
    print(str);
  }
}

//Hash Table implementation with linear probing
class HashTableLP<Key extends Comparable, Value> {
  
  int mN = 0; //number of elements in the table
  int mM = 16; //initial table size
  late List<Key?> mKeys;
  late List<Value?> mVals;
  
  HashTableLP(mM) {
    mKeys = List<Key?>.filled(mM, null);
    mVals = List<Value?>.filled(mM, null);
  }
  
  int hash(Key? key) {
    return (key.hashCode % mM);
  }
  
  void put(Key? key, Value? val) {
    if(mN >= (mM~/2)) {
      resize(2*mM);
    }
    
    int i = hash(key);
    while(mKeys[i] != null){
      Key? test = mKeys[i];
      if(test != null) {
        if(test.compareTo(key) == 0) {
          mVals[i] = val;
          return;
        }
      }
      i = (i+1) % mM; 
    }
    mKeys[i] = key;
    mVals[i] = val;
    mN++;
  }
  
  Value? fetch(Key key) {
    for(int i = hash(key); mKeys[i] != null; i = (i+1) % mM) {
      Key? test = mKeys[i];
      if(test != null) {
        if(test.compareTo(key) == 0) {
          return mVals[i];
        }
      }
    }
    return null;
  }
  
  void delete(Key key) {
    if(fetch(key) == null) return;
    int i = hash(key);
    while(key.compareTo(mKeys[i]) != 0) {
      i = (i+1) % mM;
    }
    mKeys[i] = null;
    mVals[i] = null;
    i = (i+1) % mM;
    while(mKeys[i] != null){
      Key? _k = mKeys[i];
      Value? _v = mVals[i];
      mKeys[i] = null;
      mVals[i] = null;
      mN--;
      put(_k, _v);
      i = (i+1) % mM;
    }
    mN--;
    if((mN > 0) && (mN <= (mM~/8))){
      resize(mM~/2);
    }
  }
  
  void resize(int cap) {
    HashTableLP<Key, Value> ht;
    ht = HashTableLP<Key, Value>(cap);
    for(int i = 0; i < mM; i++){
      if(mKeys[i] != null){
        ht.put(mKeys[i], mVals[i]);
      }
    }
    
    mKeys = ht.mKeys;
    mVals = ht.mVals;
    mM = ht.mM;
  }
  
  void printHashtable() {
    String str = "Hash Table with linear probing : \n";
    for(Key? k in mKeys){
      if(k != null){
        Value? val = fetch(k);
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
  HashTableLP<String, int> ht = HashTableLP<String, int>(16);
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
  ht.printHashtable();
  
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

  print("\nafter delete:\n");  
  ht.printHashtable();
}