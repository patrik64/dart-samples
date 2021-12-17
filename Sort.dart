import 'dart:math';

class Sort {

  Sort();
   
  void sort(List<int> a) {}
    
  bool less(Comparable v, Comparable w) { 
    return v.compareTo(w) < 0;
  }
  
  void exch(List<int> a, int i, int j) { 
    int t = a[i]; 
    a[i] = a[j]; 
    a[j] = t; 
  }
  
  String showList(List<int> a) {
    String s = "";
    for (int i = 0; i < a.length; i++)
    {
      s = s + a[i].toStringAsFixed(0);
      s = s + " ";
    }
    
    return s;
  }
  
  void run() {
    List<int> a = [];
    a.add(5);
    a.add(2);
    a.add(1);
    a.add(4);
    a.add(3);
    
    for(int i = 1; i < 20; i++) {
      a.add(i);
    }
    
    a.add(3);
    a.add(3);
    a.add(3);
    a.add(1);
    a.add(1);
    
    print(showList(a));

    Stopwatch w = Stopwatch();
    w.reset();
    w.start();
    sort(a);
    w.stop();
    int nTime = w.elapsedMilliseconds;
    print(showList(a));
    print("Time : ${nTime.toString()} ms");
  }
}

class QuickSort extends Sort {
  
  @override void sort(List<int> a) {
    quicksort(a, 0, a.length - 1);
  }
  
  void quicksort(List<int> a, int lo, int hi) {
    if (hi <= lo) return; 
    int j = partition(a, lo, hi);  
    quicksort(a, lo, j-1);  // Sort left part a[lo .. j-1]. 
    quicksort(a, j+1, hi);  // Sort right part a[j+1 .. hi].
  }
  
  int partition(List<int> a, int lo, int hi) { 
    int i = lo, j = hi+1; // left and right scan indices 
    Comparable v = a[lo];  
    // partitioning item 
    while (true) { 
      // Scan right, scan left, check for scan complete, and exchange.
      while (less(a[++i], v)) {
        if (i == hi) {
          break; 
        }
      }
      while (less(v, a[--j])) {
        if (j == lo) { break; }
      }
      if (i >= j) { break; }
      
      exch(a, i, j);
    } 
    exch(a, lo, j); 
    return j;
  }
}

class QuickSort3 extends Sort {
  
  @override void sort(List<int> a) {
    quicksort(a, 0, a.length - 1);
  }
  
  void quicksort(List<int> a, int lo, int hi) {
    if (hi <= lo) return; 
    int lt = lo;
    int i = lo+1;
    int gt = hi;
    int v = a[lo];
    while( i <= gt )
    {
      int cmp = a[i].compareTo(v);
      if(cmp < 0) {
        exch(a, lt++, i++);
      } else if(cmp > 0) {
        exch(a, i, gt--);
      } else {
        i++;
      }
    }
    quicksort(a, lo, lt - 1);
    quicksort(a, gt + 1, hi);
  }
}

class MergeSort extends Sort{
  List<int> maux = [];
  
  @override void sort(List<int> a){
    maux = List<int>.filled(a.length, 0);
    mergesort(a, 0, a.length - 1);
  }

  void mergesort(List<int> a, int lo, int hi){
    if(hi <= lo) return;
    int mid = lo + ((hi - lo)~/2);
    mergesort(a, lo, mid);
    mergesort(a, mid+1, hi);
    merge(a, lo, mid, hi);
  }

   void merge(List<int> a, int lo, int mid, int hi){
    int i = lo;
    int j = mid+1;
    for(int k = lo; k <=hi; k++){
      maux[k] = a[k];
    }

    for(int k = lo; k <= hi; k++){
      if(i > mid) {
        a[k] = maux[j++];
      } else if(j > hi) {
        a[k] = maux[i++];
      } else if(less(maux[j], maux[i])) {
        a[k] = maux[j++];
      } else {
        a[k] = maux[i++];
      }
    }
  }
}

class MergeSortBottomUp extends Sort {
  List<int> maux = [];
  
  @override void sort(List<int> a){
    int n = a.length;
    maux = List<int>.filled(a.length,0);
    for(int sz = 1; sz < n; sz = sz + sz) {
      for(int lo = 0; lo < (n - sz); lo = lo + sz + sz) {
        merge(a, lo, lo + sz - 1, min(lo + sz + sz - 1, n - 1));
      }
    }
  }

  void merge(List<int> a, int lo, int mid, int hi){
    int i = lo;
    int j = mid+1;
    for(int k = lo; k <=hi; k++) {
      maux[k] = a[k];
    }

    for(int k = lo; k <= hi; k++){
      if(i > mid) {
        a[k] = maux[j++];
      } else if(j > hi) {
        a[k] = maux[i++];
      } else if(less(maux[j], maux[i])) {
        a[k] = maux[j++];
      } else {
        a[k] = maux[i++];
      }
    }
  }
}

class SelectionSort extends Sort {
  
  @override void sort(List<int> a){
    int n = a.length;
    for(int i = 0; i < n; i++){
      int nMin = i;
      for(int j = i + 1; j < n; j++) {
        if(less(a[j], a[nMin])) { nMin = j; }
      }
      exch(a, i, nMin);  
    }
  }
}

class InsertionSort extends Sort {
  
  @override void sort(List<int> a){
    int n = a.length;
    for(int i = 0; i < n; i++){
      for(int j = i; j > 0 && less(a[j], a[j-1]); j--) {
        exch(a, j, j-1);
      }
    }
  }
}

class ShellSort extends Sort {
  
  @override void sort(List<int> a){
    int n = a.length;
    int h = 1;
    while(h < (n~/3)) {
      h = 3*h + 1;
    }

    while(h >= 1)
    {
      for(int i = h; i < n; i++) {
        for(int j = i; j >= h && less(a[j], a[j-h]); j = j - h) {
          exch(a, j, j-h);
        }
      }
      h = h~/3;
    }
  }
}


void main() {
  print("Quicksort");
  QuickSort().run();
  print("---------------------");
  print("Quicksort 3-way");
  QuickSort3().run();
  print("---------------------");
  print("Mergesort");
  MergeSort().run();
  print("---------------------");
  print("Mergesort Bottom Up");
  MergeSortBottomUp().run();
  print("---------------------");
  print("Selectionsort");
  SelectionSort().run();
  print("---------------------");
  print("InsertionSort");
  InsertionSort().run();
  print("---------------------");
  print("ShellSort");
  ShellSort().run();
}