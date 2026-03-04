# **Complete Java Map Implementations - Interview Preparation Guide** 📚

*A comprehensive summary of all Map implementations with code examples, use cases, and interview questions*

---

## **📊 QUICK REFERENCE TABLE**

| Map | Ordering | Thread-Safe | Null Keys | Null Values | Time | Best For |
|-----|----------|-------------|-----------|-------------|------|----------|
| **HashMap** | No order | ❌ | ✅ | ✅ | O(1) avg | General purpose, fastest lookups |
| **LinkedHashMap** | Insertion/Access | ❌ | ✅ | ✅ | O(1) avg | LRU cache, ordered iteration |
| **TreeMap** | Sorted | ❌ | ❌ | ✅ | O(log n) | Range queries, navigation |
| **ConcurrentHashMap** | No order | ✅ | ❌ | ❌ | O(1) avg | High concurrency, thread-safe |
| **EnumMap** | Enum order | ❌ | ❌ | ✅ | O(1) | Enum keys, memory efficient |
| **WeakHashMap** | No order | ❌ | ✅ | ✅ | O(1) avg | Auto-cleanup caches |
| **IdentityHashMap** | No order | ❌ | ✅ | ✅ | O(1) avg | Object identity (==) |
| **Hashtable** | No order | ✅ | ❌ | ❌ | O(1) avg | Legacy systems |
| **ConcurrentSkipListMap** | Sorted | ✅ | ❌ | ❌ | O(log n) | Sorted + concurrent |
| **Immutable Maps** | Insertion | ✅ | ❌ | ❌ | O(1) | Configuration, constants |

---

## **1. HASHMAP - The Workhorse** 🔨

```java
Map<String, Integer> map = new HashMap<>();
map.put("Alice", 95);
map.put("Bob", 87);
map.get("Alice");  // 95
```

### **Internal Structure:**
- Array of buckets (default 16)
- Each bucket is linked list (Java 7) or tree (Java 8+)
- Converts to tree when bucket size > 8 (and total > 64)

### **Key Features:**
- ✅ O(1) average time for get/put
- ✅ Allows one null key, multiple null values
- ❌ No ordering guarantees
- ❌ Not thread-safe

### **Interview Questions:**
**Q: How does HashMap handle collisions?**
> Uses chaining - multiple entries in same bucket (linked list). Java 8+ converts to tree when bucket exceeds 8 for performance.

**Q: What happens during resize?**  
> Doubles capacity (to power of 2), rehashes all entries to new buckets - expensive O(n) operation.

**Q: When would HashMap perform poorly?**  
> Poor hashCode() implementation causing many collisions, or constant resizing without initial capacity.

---

## **2. LINKEDHASHMAP - Ordered HashMap** 🔗

```java
// Insertion order
Map<String, Integer> map = new LinkedHashMap<>();

// Access order (LRU cache)
Map<String, Integer> lru = new LinkedHashMap<>(16, 0.75f, true) {
    @Override
    protected boolean removeEldestEntry(Map.Entry eldest) {
        return size() > 100;  // Keep only 100 entries
    }
};
```

### **Internal Structure:**
- HashMap + doubly-linked list running through entries
- Each entry has `before` and `after` pointers

### **Key Features:**
- ✅ Maintains insertion order (default) or access order
- ✅ Perfect for LRU caches (access-order mode)
- ✅ Same performance as HashMap
- ❌ Slightly more memory (linked list overhead)

### **Interview Questions:**
**Q: How would you implement an LRU cache?**
> Use LinkedHashMap with accessOrder=true and override removeEldestEntry().

**Q: What's the difference between insertion and access order?**  
> Insertion: order entries were added. Access: entries move to end when accessed (get/put).

---

## **3. TREEMAP - Sorted Map** 🌳

```java
NavigableMap<Double, String> map = new TreeMap<>();
map.put(99.99, "iPhone");
map.put(49.99, "Book");
map.put(199.99, "Chair");

map.firstKey();           // 49.99
map.lastKey();            // 199.99
map.lowerKey(100.0);      // 99.99 (greatest < 100)
map.higherKey(50.0);      // 99.99 (least > 50)
map.subMap(50.0, 150.0);  // {99.99="iPhone"}
```

### **Internal Structure:**
- Red-Black tree (self-balancing binary search tree)
- Implements `SortedMap` and `NavigableMap`

### **Key Features:**
- ✅ Keys sorted (natural order or Comparator)
- ✅ Navigation methods (lower, floor, higher, ceiling)
- ✅ Range views (subMap, headMap, tailMap)
- ❌ O(log n) operations (slower than HashMap)

### **Interview Questions:**
**Q: TreeMap vs HashMap performance?**
> HashMap O(1) avg for get/put, TreeMap O(log n). TreeMap provides sorting.

**Q: How does TreeMap sort keys?**  
> Uses natural ordering (Comparable) or custom Comparator. Keys must be mutually comparable.

**Q: What are NavigableMap methods?**  
> lowerKey(), floorKey(), higherKey(), ceilingKey(), pollFirstEntry(), descendingMap()

---

## **4. CONCURRENTHASHMAP - Thread-Safe HashMap** 🔒

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();

// Atomic operations
map.putIfAbsent("key", 100);
map.replace("key", 100, 200);
map.compute("key", (k, v) -> v == null ? 1 : v + 1);
map.merge("key", 5, Integer::sum);
```

### **Internal Structure:**
- Java 7: Segments array (each with own lock)
- Java 8+: Node array with CAS + synchronized for collisions
- Lock striping - multiple threads can modify concurrently

### **Key Features:**
- ✅ Thread-safe without full synchronization
- ✅ High concurrency (multiple threads can operate)
- ✅ Atomic operations (putIfAbsent, compute, merge)
- ❌ No null keys/values
- ❌ No ordering

### **Interview Questions:**
**Q: How does ConcurrentHashMap achieve better concurrency than Hashtable?**
> Hashtable uses single lock (method-level synchronized). CHM uses lock striping - multiple locks for different segments/buckets.

**Q: What happens during size() calculation?**  
> Uses baseCount + CounterCell array (striped counting) - approximate during concurrent updates.

**Q: Is CHM iteration fail-fast?**  
> No, it's weakly consistent - may not reflect latest updates but won't throw ConcurrentModificationException.

---

## **5. ENUMMAP - Efficient Enum Keys** 📋

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }

EnumMap<Day, String> schedule = new EnumMap<>(Day.class);
schedule.put(Day.MON, "Work");
schedule.put(Day.FRI, "Party");

// Iterates in enum order: MON, TUE, WED, THU, FRI, SAT, SUN
for (Map.Entry<Day, String> e : schedule.entrySet()) { }
```

### **Internal Structure:**
- Simple array `Object[] vals` sized to enum constants
- `vals[enum.ordinal()] = value` - direct array access

### **Key Features:**
- ✅ Most memory-efficient map for enum keys
- ✅ O(1) time (array access)
- ✅ Maintains enum declaration order
- ❌ Key type must be enum
- ❌ Not thread-safe

### **Interview Questions:**
**Q: Why is EnumMap more efficient than HashMap for enum keys?**
> Uses array indexing via ordinal() - no hash calculation, no collisions, less memory.

**Q: Can EnumMap have null keys?**  
> No - enum class is specified in constructor, keys must be enum constants.

---

## **6. WEAKHASHMAP - Auto-Cleaning Cache** 🧹

```java
WeakHashMap<Listener, String> listenerMap = new WeakHashMap<>();

Listener listener = new Listener();
listenerMap.put(listener, "registered");

listener = null;  // Remove strong reference
System.gc();      // Entry will be removed on next access
```

### **Internal Structure:**
- HashMap with weak references for keys
- ReferenceQueue tracks garbage collected keys
- Entries removed when keys are GC'd

### **Key Features:**
- ✅ Keys are weakly referenced
- ✅ Auto-cleanup when keys no longer used
- ✅ Prevents memory leaks in caches
- ❌ Unpredictable cleanup (GC dependent)
- ❌ Not for long-term caching

### **Interview Questions:**
**Q: When would you use WeakHashMap?**
> For caches where entries should be removed when keys are no longer referenced elsewhere (listener lists, temporary metadata).

**Q: What happens to values when keys are GC'd?**  
> Entries are removed during next map access (get/put/size). Values are strongly referenced until entry removed.

---

## **7. IDENTITYHASHMAP - Reference Equality** 🆔

```java
IdentityHashMap<Product, String> map = new IdentityHashMap<>();

Product p1 = new Product("P001", "iPhone");
Product p2 = new Product("P001", "iPhone");  // Same data, different object

map.put(p1, "Warehouse A");
map.put(p2, "Warehouse B");  // Different entry!

map.size();  // 2 (HashMap would be 1)
```

### **Internal Structure:**
- Uses `System.identityHashCode()` not `hashCode()`
- Compares keys with `==` not `equals()`
- Linear probing for collision resolution

### **Key Features:**
- ✅ Compares by object identity (reference equality)
- ✅ Uses identityHashCode (memory address based)
- ✅ Perfect for object instance tracking
- ❌ Not for "logical equality" comparisons

### **Interview Questions:**
**Q: IdentityHashMap vs HashMap difference?**
> HashMap uses equals() and hashCode(); IdentityHashMap uses == and System.identityHashCode().

**Q: Use case for IdentityHashMap?**  
> Object registries, serialization/deserialization, topology-preserving transformations, debugging.

---

## **8. HASHTABLE - Legacy Thread-Safe** 📜

```java
Hashtable<String, Integer> table = new Hashtable<>();
table.put("One", 1);
table.put("Two", 2);

// Legacy enumeration
Enumeration<String> keys = table.keys();
while (keys.hasMoreElements()) {
    System.out.println(keys.nextElement());
}
```

### **Internal Structure:**
- Similar to HashMap (array + linked lists)
- All methods synchronized (method-level lock)

### **Key Features:**
- ✅ Thread-safe (synchronized methods)
- ✅ No null keys/values
- ❌ Poor concurrency (single lock)
- ❌ Legacy class - prefer ConcurrentHashMap

### **Interview Questions:**
**Q: Hashtable vs ConcurrentHashMap?**
> Hashtable: single lock, poor scaling. ConcurrentHashMap: lock striping, better concurrency.

**Q: Why avoid Hashtable in new code?**  
> Performance bottleneck under concurrency. ConcurrentHashMap offers same thread-safety with better scalability.

---

## **9. CONCURRENTSKIPLISTMAP - Sorted + Thread-Safe** ⚡

```java
ConcurrentSkipListMap<Double, String> leaderboard = new ConcurrentSkipListMap<>();
leaderboard.put(999.99, "iPhone");
leaderboard.put(799.99, "Samsung");
leaderboard.put(1299.99, "MacBook");

// Sorted and thread-safe!
leaderboard.descendingMap();           // Most expensive first
leaderboard.subMap(800.0, 1000.0);     // Range query
leaderboard.ceilingKey(900.0);         // First key ≥ 900
```

### **Internal Structure:**
- Skip List (multi-level linked list)
- Probabilistic data structure (like binary search on linked list)
- Thread-safe without locks (using CAS)

### **Key Features:**
- ✅ Only sorted + thread-safe map
- ✅ O(log n) operations
- ✅ Concurrent navigation
- ❌ More memory than TreeMap
- ❌ Slower than ConcurrentHashMap for unsorted

### **Interview Questions:**
**Q: How does Skip List work?**
> Multi-level linked list where higher levels "skip" over nodes, enabling O(log n) search.

**Q: When to use ConcurrentSkipListMap?**
> When you need both sorted order AND thread-safety (real-time leaderboards, stock tickers).

---

## **10. IMMUTABLE MAPS - Java 9+ Factory Methods** 🔒

```java
// Up to 10 entries
Map<String, String> config = Map.of(
    "tax_rate", "7.5",
    "currency", "USD",
    "shipping", "5.99"
);

// More than 10 entries
Map<String, Object> rules = Map.ofEntries(
    Map.entry("max_items", 50),
    Map.entry("allow_coupons", true),
    Map.entry("min_free_shipping", 25.0)
);

// config.put("new", "value");  // ❌ UnsupportedOperationException!
```

### **Internal Structure:**
- JVM-optimized immutable implementations
- Different internal classes for different sizes

### **Key Features:**
- ✅ Truly immutable (cannot modify)
- ✅ Thread-safe (no synchronization needed)
- ✅ Memory efficient (JVM optimizations)
- ✅ Null keys/values not allowed

### **Interview Questions:**
**Q: Map.of() vs Collections.unmodifiableMap()?**
> unmodifiableMap is a wrapper - backing map can still change. Map.of() creates truly immutable map.

**Q: Can you modify immutable maps?**  
> No - put, remove, clear throw UnsupportedOperationException.

---

## **🎯 INTERVIEW QUICK REFERENCE**

### **When to use which Map:**

| Scenario | Map Choice |
|----------|------------|
| Fastest general purpose | `HashMap` |
| Need ordering (insertion) | `LinkedHashMap` |
| Need sorting (by keys) | `TreeMap` |
| Thread-safe, high concurrency | `ConcurrentHashMap` |
| Thread-safe + sorted | `ConcurrentSkipListMap` |
| Enum keys | `EnumMap` (most efficient) |
| Auto-cleanup cache | `WeakHashMap` |
| Object identity tracking | `IdentityHashMap` |
| Immutable configuration | `Map.of()` / `Map.ofEntries()` |
| Legacy code maintenance | `Hashtable` |

---

## **📝 COMMON INTERVIEW QUESTIONS**

### **Q1: HashMap internal working?**
> Array of buckets → hash code → index → store Entry (key, value, next). Collisions handled by chaining (linked list/tree).

### **Q2: How does ConcurrentHashMap achieve thread-safety?**
> Java 8+: CAS for put, synchronized only for collisions. Lock striping - multiple threads can modify different buckets.

### **Q3: Difference between fail-fast and weakly consistent iterators?**
> Fail-fast (HashMap): throws ConcurrentModificationException if map modified during iteration. Weakly consistent (CHM): may not reflect latest changes but won't throw exception.

### **Q4: TreeMap vs HashMap performance tradeoffs?**
> HashMap O(1) avg, no order. TreeMap O(log n), sorted. Choose TreeMap only when you need sorted iteration/navigation.

### **Q5: How to make HashMap thread-safe?**
> 1. Collections.synchronizedMap() 2. ConcurrentHashMap (preferred) 3. Hashtable (legacy)

### **Q6: What happens if hashCode() returns constant?**
> All entries go to same bucket → HashMap degrades to linked list O(n) performance.

### **Q7: Why String is good HashMap key?**
> Immutable, final, properly overrides equals/hashCode, cached hash code for performance.

---

## **💡 KEY TAKEAWAYS**

1. **HashMap** - Default choice, fastest O(1)
2. **TreeMap** - Need sorting/navigation
3. **ConcurrentHashMap** - Need thread-safety
4. **EnumMap** - Enum keys (most efficient)
5. **WeakHashMap** - Auto-cleanup caches
6. **LinkedHashMap** - LRU caches, ordered iteration
7. **IdentityHashMap** - Object reference tracking
8. **ConcurrentSkipListMap** - Sorted + thread-safe
9. **Immutable Maps** - Configuration, constants

---

## **🚀 QUICK CODE SNIPPETS**

```java
// HashMap
Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
map.getOrDefault("B", 0);
map.computeIfAbsent("C", k -> 2);

// TreeMap - Navigation
NavigableMap<Double, String> tree = new TreeMap<>();
tree.lowerKey(100.0);
tree.higherKey(50.0);
tree.subMap(25.0, 75.0);

// ConcurrentHashMap - Atomic ops
ConcurrentHashMap<String, Integer> chm = new ConcurrentHashMap<>();
chm.putIfAbsent("key", 1);
chm.merge("key", 5, Integer::sum);
chm.compute("key", (k, v) -> v == null ? 1 : v + 1);

// EnumMap
EnumMap<Day, String> enumMap = new EnumMap<>(Day.class);
enumMap.put(Day.MON, "Work");

// Immutable Map
Map<String, String> config = Map.of("timeout", "30", "retry", "3");
```

---

*Happy Interview Prep! 🎉*