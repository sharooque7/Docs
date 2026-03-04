# **Complete Java Set Implementations - Interview Preparation Guide** 🎯

*A comprehensive summary of all Set implementations with code examples, use cases, and interview questions*

---

## **📊 QUICK REFERENCE TABLE**

| Set | Internal | Ordering | Thread-Safe | Nulls | Time Complexity | Best For |
|-----|----------|----------|-------------|-------|-----------------|----------|
| **HashSet** | HashMap | No order | ❌ | ✅ | O(1) avg | General purpose, fastest |
| **LinkedHashSet** | LinkedHashMap | Insertion order | ❌ | ✅ | O(1) avg | Maintain insertion order |
| **TreeSet** | TreeMap (Red-Black) | Sorted | ❌ | ❌ | O(log n) | Sorted unique elements |
| **EnumSet** | Bit vector | Enum order | ❌ | ❌ | O(1) | Enum constants only |
| **CopyOnWriteArraySet** | CopyOnWriteArrayList | Insertion order | ✅ | ✅ | O(n) | Read-heavy concurrent |
| **ConcurrentSkipListSet** | ConcurrentSkipListMap | Sorted | ✅ | ❌ | O(log n) | Sorted + concurrent |
| **HashSet (LinkedHashMap)** | LinkedHashMap | Access order | ❌ | ✅ | O(1) avg | LRU cache variant |

---

## **📋 SET HIERARCHY**

```
                    Collection
                        ↑
                     Set Interface
                    ╱      ╱   ╲      ╲
              HashSet  LinkedHashSet  TreeSet  CopyOnWriteArraySet
                 ↑
           LinkedHashSet

                    NavigableSet (extends SortedSet)
                         ↑
                    TreeSet, ConcurrentSkipListSet

                    SortedSet (extends Set)
                         ↑
                    TreeSet, ConcurrentSkipListSet
```

---

## **1. HASHSET - The Workhorse** 🔨

```java
// Creation
Set<String> set = new HashSet<>();              // Default capacity 16
Set<String> set2 = new HashSet<>(100);          // Initial capacity
Set<String> set3 = new HashSet<>(existingSet);  // Copy constructor
Set<String> set4 = new HashSet<>(100, 0.75f);   // Capacity + load factor

// Basic operations
set.add("A");                    // Returns true if added
set.add("A");                    // Returns false (duplicate)
boolean exists = set.contains("A");
boolean removed = set.remove("A");
int size = set.size();
boolean empty = set.isEmpty();
set.clear();

// Bulk operations
set.addAll(otherSet);
set.removeAll(toRemove);
set.retainAll(toKeep);
boolean containsAll = set.containsAll(otherSet);

// Iteration (no guaranteed order!)
for (String element : set) {
    System.out.println(element);
}

set.forEach(System.out::println);
Iterator<String> it = set.iterator();

// Convert to array
String[] array = set.toArray(new String[0]);

// Real-world use: Remove duplicates from List
List<String> list = Arrays.asList("A", "B", "A", "C", "B");
Set<String> unique = new HashSet<>(list);  // [A, B, C]
```

### **Internal Structure:**
- Backed by `HashMap<E, Object>`
- Uses dummy value `PRESENT` (static final Object)
- All operations delegate to HashMap

```java
// HashSet internal
private transient HashMap<E,Object> map;
private static final Object PRESENT = new Object();

public boolean add(E e) {
    return map.put(e, PRESENT) == null;
}

public boolean contains(Object o) {
    return map.containsKey(o);
}
```

### **Key Features:**
- ✅ O(1) average time for add, remove, contains
- ✅ No duplicates allowed
- ✅ Allows one null element
- ✅ Fastest general-purpose Set
- ❌ No ordering guarantees
- ❌ Not thread-safe
- ❌ Iteration order unpredictable

### **Performance:**
```
Operation          | Time Complexity
-------------------|----------------
add(E)             | O(1) avg
contains(Object)   | O(1) avg
remove(Object)     | O(1) avg
size()             | O(1)
iterator.next()    | O(1) per element
```

### **Interview Questions:**

**Q: How does HashSet ensure no duplicates?**
> Uses HashMap keys. When adding, checks if key exists via `put()` - returns null if new, old value if exists.

**Q: What's the default initial capacity and load factor?**
> 16 initial capacity, 0.75 load factor (same as HashMap).

**Q: How is HashSet different from HashMap?**
> HashSet: Set implementation (values only). HashMap: Map implementation (key-value pairs). HashSet uses HashMap internally.

**Q: Can HashSet have null?**
> Yes, one null element allowed (HashMap allows one null key).

**Q: When would you use HashSet over other Sets?**
> When you need fast operations and don't care about ordering - default choice.

---

## **2. LINKEDHASHSET - Ordered HashSet** 🔗

```java
// Creation (maintains insertion order)
Set<String> set = new LinkedHashSet<>();
Set<String> set2 = new LinkedHashSet<>(100);
Set<String> set3 = new LinkedHashSet<>(existingSet);

// Same operations as HashSet
set.add("B");
set.add("A");
set.add("C");

// Iteration follows insertion order!
for (String s : set) {
    System.out.println(s);  // "B", "A", "C" (insertion order)
}

// Access order variant? No direct LinkedHashSet, but can do:
// (Not standard - would need custom implementation)
Map<String, Boolean> accessOrderMap = new LinkedHashMap<>(16, 0.75f, true);
// But use LinkedHashMap directly for LRU cache
```

### **Internal Structure:**
- Extends `HashSet`
- Backed by `LinkedHashMap` instead of `HashMap`
- Each entry has `before` and `after` pointers

```java
// LinkedHashSet uses LinkedHashMap
public class LinkedHashSet<E> extends HashSet<E> {
    public LinkedHashSet() {
        super(16, 0.75f, true);  // Calls HashSet constructor that creates LinkedHashMap
    }
}
```

### **Key Features:**
- ✅ Maintains insertion order
- ✅ Same performance as HashSet (slight overhead)
- ✅ Allows one null
- ✅ Predictable iteration order
- ❌ Slightly more memory than HashSet
- ❌ Not thread-safe

### **Performance:**
```
Operation          | Time Complexity | vs HashSet
-------------------|-----------------|-----------
add(E)             | O(1) avg        | Slightly slower (maintain list)
contains(Object)   | O(1) avg        | Same
remove(Object)     | O(1) avg        | Same
iteration          | O(n)            | Faster than HashSet (linked list)
```

### **Interview Questions:**

**Q: LinkedHashSet vs HashSet - differences?**
> LinkedHashSet maintains insertion order (doubly-linked list), slightly more memory. HashSet no order, slightly faster.

**Q: When to use LinkedHashSet?**
> When you need uniqueness + predictable iteration order (caching in order, preserving input order).

**Q: How does LinkedHashSet maintain order?**
> Uses LinkedHashMap internally - entries linked in insertion order.

**Q: Can LinkedHashSet have access order like LinkedHashMap?**
> No - LinkedHashSet only supports insertion order. For access order (LRU), use LinkedHashMap directly.

---

## **3. TREESET - Sorted Set** 🌳

```java
// Natural ordering
Set<String> set = new TreeSet<>();
set.add("Charlie");
set.add("Alice");
set.add("Bob");
// Sorted: "Alice", "Bob", "Charlie"

// Custom comparator (reverse order)
Set<String> reverse = new TreeSet<>(Comparator.reverseOrder());
reverse.addAll(set);  // "Charlie", "Bob", "Alice"

// With custom objects
Set<Person> people = new TreeSet<>(Comparator.comparing(Person::getAge));

// NavigableSet methods (TreeSet implements NavigableSet)
NavigableSet<Integer> numbers = new TreeSet<>();
numbers.add(5); numbers.add(2); numbers.add(8); numbers.add(1);

numbers.first();           // 1
numbers.last();            // 8
numbers.lower(5);          // 2 (greatest < 5)
numbers.higher(5);         // 8 (least > 5)
numbers.floor(4);          // 2 (greatest ≤ 4)
numbers.ceiling(4);        // 5 (least ≥ 4)
numbers.pollFirst();       // 1 (remove and return)
numbers.pollLast();        // 8 (remove and return)

// Range views
SortedSet<Integer> head = numbers.headSet(5);    // < 5
SortedSet<Integer> tail = numbers.tailSet(5);    // ≥ 5
SortedSet<Integer> sub = numbers.subSet(2, 8);   // 2 to 7

// Descending view
NavigableSet<Integer> desc = numbers.descendingSet();

// Check ordering
Comparator<? super Integer> comp = numbers.comparator(); // null if natural
```

### **Internal Structure:**
- Backed by `TreeMap` (Red-Black tree)
- Implements `NavigableSet` and `SortedSet`
- Elements must be Comparable or provide Comparator

### **Key Features:**
- ✅ Elements sorted (natural order or Comparator)
- ✅ Navigation methods (lower, higher, floor, ceiling)
- ✅ Range views (headSet, tailSet, subSet)
- ✅ O(log n) operations
- ❌ No null elements
- ❌ Slower than HashSet
- ❌ Not thread-safe

### **Performance:**
```
Operation          | Time Complexity
-------------------|----------------
add(E)             | O(log n)
contains(Object)   | O(log n)
remove(Object)     | O(log n)
first()            | O(1)
last()             | O(1)
lower/higher       | O(log n)
iteration          | O(n) (in-order)
```

### **Interview Questions:**

**Q: TreeSet vs HashSet - when to use which?**
> HashSet: faster O(1), no order. TreeSet: slower O(log n), sorted. Use TreeSet only when you need sorting.

**Q: How does TreeSet sort elements?**
> Natural ordering (Comparable) or custom Comparator provided at construction.

**Q: Can TreeSet have null?**
> No - throws NullPointerException. Elements must be comparable.

**Q: What's the difference between lower() and floor()?**
> lower(e): greatest element < e. floor(e): greatest element ≤ e.

**Q: How to get descending order view?**
> `treeSet.descendingSet()` returns view in reverse order.

**Q: What happens if elements are not Comparable?**
> Throws ClassCastException at runtime. Must provide Comparator.

---

## **4. ENUMSET - Specialized for Enums** 📋

```java
// Create EnumSet
enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

// All of the enum type
Set<Day> allDays = EnumSet.allOf(Day.class);

// Empty set of specified enum type
Set<Day> empty = EnumSet.noneOf(Day.class);

// Specific values
Set<Day> weekend = EnumSet.of(Day.SATURDAY, Day.SUNDAY);
Set<Day> weekdays = EnumSet.range(Day.MONDAY, Day.FRIDAY);

// Complement of another set
Set<Day> workWeek = EnumSet.complementOf(weekend);  // MON-FRI

// Copy from another EnumSet
Set<Day> copy = EnumSet.copyOf(weekend);

// Regular Set operations
weekend.add(Day.SATURDAY);      // Already there - no effect
weekend.contains(Day.MONDAY);   // false
weekend.remove(Day.SUNDAY);

// Iteration follows enum declaration order
for (Day day : weekend) {
    System.out.println(day);  // SATURDAY, SUNDAY (in enum order)
}

// Bulk operations
Set<Day> days = EnumSet.allOf(Day.class);
days.removeAll(weekend);  // Remove weekend
days.retainAll(weekdays); // Keep only weekdays

// Real-world use: flags, permissions, states
enum Permission { READ, WRITE, EXECUTE, DELETE }
Set<Permission> userPerms = EnumSet.of(Permission.READ, Permission.WRITE);

if (userPerms.contains(Permission.READ)) {
    // Allow read
}
```

### **Internal Structure:**
- Not backed by Map - uses bit vectors!
- RegularEnumSet: single long (up to 64 values)
- JumboEnumSet: long[] for >64 values
- Extremely compact and fast

```java
// Simplified internal (RegularEnumSet)
class RegularEnumSet<E extends Enum<E>> extends EnumSet<E> {
    private long elements = 0L;  // Bit mask
    
    public boolean add(E e) {
        long oldElements = elements;
        elements |= (1L << e.ordinal());
        return elements != oldElements;
    }
    
    public boolean contains(Object e) {
        return (elements & (1L << ((Enum<?>)e).ordinal())) != 0;
    }
}
```

### **Key Features:**
- ✅ Most memory-efficient Set implementation
- ✅ O(1) all operations (bitwise)
- ✅ Iterates in enum declaration order
- ✅ Type-safe (only enum constants allowed)
- ✅ No null elements
- ✅ Thread-safe if used in read-only mode
- ❌ Can only store enum constants
- ❌ Not for non-enum types

### **Performance:**
```
Operation          | Time Complexity | Implementation
-------------------|-----------------|----------------
add(E)             | O(1)            | Bitwise OR
contains(Object)   | O(1)            | Bitwise AND
remove(Object)     | O(1)            | Bitwise AND with complement
size()             | O(1)            | Long.bitCount()
iterator.next()    | O(1) per element | Scan bits
```

### **Interview Questions:**

**Q: Why is EnumSet so efficient?**
> Uses bit vectors (bitmask) internally - each enum constant represented by a bit. Operations are bitwise.

**Q: EnumSet vs HashSet for enum constants?**
> EnumSet is much faster and memory efficient (bit operations vs hash table). Always use EnumSet for enums.

**Q: Can EnumSet store null?**
> No - NullPointerException. EnumSet is for enum constants only.

**Q: What's the difference between EnumSet.allOf() and EnumSet.noneOf()?**
> allOf(): set containing all enum constants. noneOf(): empty set of specified enum type.

**Q: How does EnumSet handle enums with more than 64 values?**
> Uses JumboEnumSet with long[] array - still efficient, each long stores 64 values.

**Q: Is EnumSet thread-safe?**
> No - but because it's often used as constants, can be safely shared if never modified after creation.

---

## **5. COPYONWRITEARRAYSET - Thread-Safe Read-Optimized** 📋🔒

```java
// Creation
Set<String> set = new CopyOnWriteArraySet<>();
Set<String> set2 = new CopyOnWriteArraySet<>(existingCollection);

// Thread-safe operations
set.add("A");                    // Creates copy of array
set.add("B");                    // Creates copy again
boolean exists = set.contains("A");  // No copy, fast
boolean removed = set.remove("A");   // Creates copy

// Iteration (thread-safe snapshot)
for (String s : set) {
    System.out.println(s);
    set.add("X");  // Doesn't affect current iteration!
}

// Multiple readers, rare writers
Runnable reader = () -> {
    for (String s : set) {
        System.out.println(s);  // Never throws ConcurrentModificationException
    }
};

Runnable writer = () -> {
    set.add("C");  // Expensive but rare
};

// Real-world use: listener sets
Set<EventListener> listeners = new CopyOnWriteArraySet<>();

// Add/remove listeners (rare)
listeners.add(new MyListener());

// Notify all listeners (frequent - no synchronization needed)
for (EventListener listener : listeners) {
    listener.onEvent(event);
}
```

### **Internal Structure:**
- Backed by `CopyOnWriteArrayList`
- All mutators create new copy of underlying array
- Reads never synchronized
- Iterators use immutable snapshot

```java
// Simplified internal
public class CopyOnWriteArraySet<E> extends AbstractSet<E> {
    private final CopyOnWriteArrayList<E> al;
    
    public boolean add(E e) {
        return al.addIfAbsent(e);  // Creates copy if not present
    }
    
    public boolean contains(Object o) {
        return al.contains(o);  // No copy, fast
    }
}
```

### **Key Features:**
- ✅ Thread-safe (no synchronization for reads)
- ✅ No ConcurrentModificationException
- ✅ Iterator sees immutable snapshot
- ✅ Perfect for read-mostly scenarios
- ❌ Expensive writes (O(n) copy per modification)
- ❌ Not for write-heavy workloads
- ❌ add() is O(n) due to duplicate check + copy

### **Performance:**
```
Operation          | Time Complexity | Notes
-------------------|-----------------|------
add(E)             | O(n)            | Checks duplicates + copies array
contains(Object)   | O(n)            | No copy, linear scan
remove(Object)     | O(n)            | Creates new array
size()             | O(1)            |
iteration          | O(n)            | Snapshot, no ConcurrentModification
```

### **Interview Questions:**

**Q: When to use CopyOnWriteArraySet?**
> Read-heavy, write-rarely scenarios: listener lists, event handlers, subscription sets.

**Q: How does CopyOnWriteArraySet avoid duplicates?**
> Uses `CopyOnWriteArrayList.addIfAbsent()` - checks existence before adding.

**Q: What's the memory impact?**
> Each write creates new array copy. Old array may persist if iterators are active.

**Q: CopyOnWriteArraySet vs ConcurrentSkipListSet?**
> COWAS: no order, faster reads, O(n) writes. CSLS: sorted, O(log n) operations.

**Q: Why is add() O(n) even for unique elements?**
> Must scan entire array to check for duplicates before adding.

---

## **6. CONCURRENTSKIPLISTSET - Sorted + Thread-Safe** ⚡

```java
// Creation
NavigableSet<String> set = new ConcurrentSkipListSet<>();
NavigableSet<String> set2 = new ConcurrentSkipListSet<>(Comparator.reverseOrder());
NavigableSet<String> set3 = new ConcurrentSkipListSet<>(existingCollection);

// Thread-safe sorted operations
set.add("Charlie");
set.add("Alice");
set.add("Bob");

// Sorted order guaranteed
System.out.println(set);  // [Alice, Bob, Charlie]

// NavigableSet methods (thread-safe!)
String first = set.first();           // "Alice"
String last = set.last();             // "Charlie"
String lower = set.lower("Bob");      // "Alice" (< Bob)
String higher = set.higher("Bob");    // "Charlie" (> Bob)
String floor = set.floor("Bob");      // "Bob" (≤ Bob)
String ceiling = set.ceiling("Bb");   // "Alice" (≥ Bb)

// Range views (thread-safe)
NavigableSet<String> head = set.headSet("Bob", true);   // ≤ Bob
NavigableSet<String> tail = set.tailSet("Bob", false);  // > Bob
NavigableSet<String> sub = set.subSet("Alice", true, "Charlie", true);

// Poll operations (atomic)
String firstRemoved = set.pollFirst();  // Remove and return first
String lastRemoved = set.pollLast();    // Remove and return last

// Descending view
NavigableSet<String> desc = set.descendingSet();

// Multiple threads can safely iterate and modify
Runnable modifier = () -> {
    set.add("Thread-" + Thread.currentThread().getId());
};

Runnable reader = () -> {
    for (String s : set) {  // Weakly consistent
        System.out.println(s);
    }
};

// Real-world: real-time leaderboards, sorted concurrent data
```

### **Internal Structure:**
- Backed by `ConcurrentSkipListMap`
- Skip List data structure (multi-level linked list)
- Thread-safe using CAS operations
- Implements `NavigableSet` and `SortedSet`

### **Key Features:**
- ✅ Thread-safe (CAS-based, no locks)
- ✅ Sorted order maintained
- ✅ Navigation methods (lower, higher, floor, ceiling)
- ✅ Range views (headSet, tailSet, subSet)
- ✅ O(log n) operations
- ❌ No null elements
- ❌ Higher memory than TreeSet

### **Performance:**
```
Operation          | Time Complexity | Concurrency
-------------------|-----------------|------------
add(E)             | O(log n)        | CAS operations
contains(Object)   | O(log n)        | Lock-free
remove(Object)     | O(log n)        | CAS-based
first()            | O(1)            |
last()             | O(1)            |
iteration          | O(n)            | Weakly consistent
```

### **Interview Questions:**

**Q: ConcurrentSkipListSet vs CopyOnWriteArraySet?**
> CSLS: sorted, O(log n) operations, good for writes. COWAS: no order, O(n) writes, faster reads.

**Q: When to use ConcurrentSkipListSet?**
> When you need sorted, thread-safe Set with good write performance.

**Q: How does it achieve thread-safety without locks?**
> Uses CAS (Compare-And-Swap) operations and immutable node structures.

**Q: ConcurrentSkipListSet vs Collections.synchronizedSet(new TreeSet<>())?**
> CSLS: truly concurrent, scales better. Synchronized wrapper: single lock, poor concurrency.

**Q: Can it have null?**
> No - ConcurrentSkipListSet doesn't allow null elements.

---

## **7. SPECIALIZED SET VARIANTS**

### **A. BitSet - For Flags and Bits**
```java
// Not a Set implementation but similar concept
BitSet bits = new BitSet(16);  // 16 bits initially
bits.set(5);                    // Set bit 5
bits.set(10, true);             // Set bit 10
boolean isSet = bits.get(5);    // true
bits.clear(5);                  // Clear bit 5

// Bit operations
bits.and(otherBits);
bits.or(otherBits);
bits.xor(otherBits);

// Cardinality (number of set bits)
int count = bits.cardinality();

// Real-world: permission flags, bloom filters
```

### **B. ConcurrentHashMap.newKeySet()**
```java
// Thread-safe Set backed by ConcurrentHashMap
Set<String> set = ConcurrentHashMap.newKeySet();
Set<String> set2 = ConcurrentHashMap.newKeySet(100);  // Initial capacity

// All operations thread-safe
set.add("A");
set.contains("A");
set.remove("A");

// More efficient than CopyOnWriteArraySet for general use
// Better than Collections.synchronizedSet(new HashSet<>())
```

### **C. Collections.synchronizedSet()**
```java
Set<String> set = Collections.synchronizedSet(new HashSet<>());

// Must synchronize on iteration
synchronized(set) {
    for (String s : set) {
        // process
    }
}
```

---

## **📊 COMPARISON TABLE**

| Feature | HashSet | LinkedHashSet | TreeSet | EnumSet | CopyOnWriteArraySet | ConcurrentSkipListSet |
|---------|---------|---------------|---------|---------|---------------------|----------------------|
| **Ordering** | None | Insertion | Sorted | Enum order | Insertion | Sorted |
| **Nulls** | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ |
| **Thread-Safe** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Performance (add)** | O(1) ⚡ | O(1) ⚡ | O(log n) | O(1) ⚡ | O(n) 🐢 | O(log n) |
| **Performance (contains)** | O(1) ⚡ | O(1) ⚡ | O(log n) | O(1) ⚡ | O(n) | O(log n) |
| **Memory** | Medium | Medium+ | High | Low 🎯 | High (copies) | High |
| **Use for enums?** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Range queries** | ❌ | ❌ | ✅ | ✅ (range()) | ❌ | ✅ |

---

## **🎯 WHEN TO USE WHICH SET**

### **Single-threaded applications:**

| Scenario | Recommendation |
|----------|---------------|
| **Default choice** | `HashSet` (fastest) |
| **Need insertion order** | `LinkedHashSet` |
| **Need sorted elements** | `TreeSet` |
| **Enum constants only** | `EnumSet` (most efficient) |
| **LRU cache variant** | `LinkedHashMap` (not Set) |

### **Multi-threaded applications:**

| Scenario | Recommendation |
|----------|---------------|
| **Read-mostly, writes rare** | `CopyOnWriteArraySet` |
| **Need sorted + concurrent** | `ConcurrentSkipListSet` |
| **General concurrent** | `ConcurrentHashMap.newKeySet()` |
| **Simple thread-safe** | `Collections.synchronizedSet()` |

### **Special purposes:**

| Scenario | Recommendation |
|----------|---------------|
| **Bit flags, permissions** | `EnumSet` |
| **Large enum sets (>64)** | `EnumSet` (JumboEnumSet) |
| **Real-time leaderboards** | `ConcurrentSkipListSet` |
| **Listener lists** | `CopyOnWriteArraySet` |
| **Deduplication** | Any Set (usually HashSet) |

---

## **📝 COMMON INTERVIEW QUESTIONS**

### **Q1: HashSet vs TreeSet vs LinkedHashSet?**
> - HashSet: fastest, no order
> - LinkedHashSet: insertion order, slightly slower
> - TreeSet: sorted order, O(log n)

### **Q2: How does HashSet check for duplicates?**
> Uses `hashCode()` to find bucket, then `equals()` to compare with existing elements.

### **Q3: What's the contract between hashCode() and equals()?**
> If `a.equals(b)` is true, then `a.hashCode() == b.hashCode()` must be true. Not vice versa.

### **Q4: Can Set have duplicate elements?**
> No - Set guarantees no duplicates. Adding duplicate returns false.

### **Q5: How to make Set thread-safe?**
> 1. `CopyOnWriteArraySet` (read-heavy)
> 2. `ConcurrentSkipListSet` (sorted)
> 3. `ConcurrentHashMap.newKeySet()`
> 4. `Collections.synchronizedSet()`

### **Q6: Why is EnumSet so efficient?**
> Bit vectors - each enum constant represented by a single bit. Operations are bitwise.

### **Q7: TreeSet vs PriorityQueue?**
> TreeSet: unique elements, sorted, O(log n) all operations. PriorityQueue: duplicates allowed, only head accessible.

### **Q8: How to get synchronized Set from HashSet?**
> `Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());`

### **Q9: What's the difference between SortedSet and NavigableSet?**
> NavigableSet extends SortedSet with navigation methods: lower(), higher(), floor(), ceiling(), pollFirst/Last().

### **Q10: Can TreeSet store different types?**
> No - all elements must be mutually comparable (same type or subclasses). Otherwise ClassCastException.

### **Q11: How does CopyOnWriteArraySet iteration work?**
> Iterator uses snapshot of array at creation - modifications after don't affect iteration.

### **Q12: What happens when adding null to TreeSet?**
> NullPointerException - TreeSet doesn't allow null (can't compare null).

### **Q13: How to get reverse order view of TreeSet?**
> `treeSet.descendingSet()` returns view in descending order.

### **Q14: What's the initial capacity of HashSet?**
> Default 16, load factor 0.75. Resizes when size > capacity * load factor.

### **Q15: How to create immutable Set?**
> Java 9+: `Set.of("A", "B", "C")`  
> Java 8: `Collections.unmodifiableSet(new HashSet<>(...))`

---

## **💡 KEY TAKEAWAYS**

1. **Default choice**: `HashSet` (fastest O(1))
2. **Need insertion order**: `LinkedHashSet`
3. **Need sorted order**: `TreeSet` (single-threaded)
4. **Enum constants**: `EnumSet` (most efficient)
5. **Thread-safe, read-heavy**: `CopyOnWriteArraySet`
6. **Thread-safe, sorted**: `ConcurrentSkipListSet`
7. **General concurrent**: `ConcurrentHashMap.newKeySet()`
8. **Immutable**: `Set.of()` (Java 9+)
9. **Never use**: Raw Set implementations without considering requirements

---

## **🚀 QUICK CODE SNIPPETS**

```java
// 1. HashSet - fastest
Set<String> set1 = new HashSet<>();
set1.add("A");
set1.contains("A");

// 2. LinkedHashSet - insertion order
Set<String> set2 = new LinkedHashSet<>();
set2.add("B"); set2.add("A");  // Iterates: B, A

// 3. TreeSet - sorted
Set<String> set3 = new TreeSet<>();
set3.add("Charlie"); set3.add("Alice");  // Sorted: Alice, Charlie

// 4. EnumSet - for enums
enum Color { RED, GREEN, BLUE }
Set<Color> set4 = EnumSet.of(Color.RED, Color.BLUE);

// 5. CopyOnWriteArraySet - thread-safe read-heavy
Set<String> set5 = new CopyOnWriteArraySet<>();
set5.add("A");  // Expensive

// 6. ConcurrentSkipListSet - sorted + thread-safe
NavigableSet<String> set6 = new ConcurrentSkipListSet<>();
set6.add("X"); set6.add("A");  // Sorted: A, X

// 7. Immutable Set (Java 9+)
Set<String> set7 = Set.of("A", "B", "C");

// 8. Synchronized wrapper
Set<String> set8 = Collections.synchronizedSet(new HashSet<>());
synchronized(set8) {
    for (String s : set8) { }  // Must synchronize iteration
}

// 9. Remove duplicates from List
List<String> list = Arrays.asList("A", "B", "A", "C");
Set<String> unique = new HashSet<>(list);  // [A, B, C]

// 10. Check if two collections share elements
Set<String> setA = new HashSet<>(listA);
boolean disjoint = Collections.disjoint(setA, listB);
```

---

*Happy Interview Prep! 🎉*