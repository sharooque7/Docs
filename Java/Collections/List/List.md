# **Complete Java List Implementations - Interview Preparation Guide** 📋

*A comprehensive summary of all List implementations with code examples, use cases, and interview questions*

---

## **📊 QUICK REFERENCE TABLE**

| List | Internal | Thread-Safe | Random Access | Insert/Delete | Nulls | Best For |
|------|----------|-------------|---------------|----------------|-------|----------|
| **ArrayList** | Dynamic Array | ❌ | O(1) | O(n) at middle | ✅ | General purpose, fast iteration |
| **LinkedList** | Doubly Linked List | ❌ | O(n) | O(1) at ends | ✅ | Frequent insert/delete at ends |
| **Vector** | Dynamic Array | ✅ (synchronized) | O(1) | O(n) | ✅ | Legacy thread-safe code |
| **Stack** | Dynamic Array | ✅ (synchronized) | O(1) | O(1) at top | ✅ | Legacy LIFO (use ArrayDeque) |
| **CopyOnWriteArrayList** | Dynamic Array | ✅ (immutable snapshots) | O(1) | O(n) copy | ✅ | Read-heavy concurrent access |
| **Arrays.asList()** | Fixed-size Array | ❌ | O(1) | ❌ (fixed size) | ✅ | Array to List view |
| **List.of()** | Immutable Array | ✅ | O(1) | ❌ (immutable) | ❌ | Immutable collections |
| **ArrayList.subList()** | View of ArrayList | ❌ | O(1) | Modifies parent | ✅ | View of portion |

---

## **📋 LIST HIERARCHY**

```
                    Collection
                        ↑
                     List Interface
                    ╱      ╱   ╲     ╲
            ArrayList  LinkedList  Vector  CopyOnWriteArrayList
                                       ↑
                                     Stack
```

---

## **1. ARRAYLIST - The Workhorse** 🚀

```java
// Creation
List<String> list = new ArrayList<>();              // Default size 10
List<String> list2 = new ArrayList<>(100);          // Initial capacity
List<String> list3 = new ArrayList<>(existingList); // Copy constructor

// Basic operations
list.add("A");                    // Add to end
list.add(0, "First");              // Insert at index
list.get(2);                       // Random access
list.set(1, "New");                // Update
list.remove("A");                  // Remove by object
list.remove(0);                    // Remove by index
list.indexOf("B");                  // Find index
list.contains("C");                 // Check existence

// Bulk operations
list.addAll(otherList);
list.removeAll(toRemove);
list.retainAll(toKeep);
list.clear();

// Iteration
for (String s : list) { }
list.forEach(System.out::println);
Iterator<String> it = list.iterator();
ListIterator<String> lit = list.listIterator(); // Bidirectional
```

### **Internal Structure:**
- Dynamic array (Object[] elementData)
- Default capacity: 10
- Growth: `newCapacity = oldCapacity + (oldCapacity >> 1)` (50% growth)
- Maintains `size` variable for actual element count

### **Key Features:**
- ✅ O(1) random access (get/set by index)
- ✅ O(1) amortized add to end
- ✅ Fast iteration (cache-friendly)
- ✅ Allows null elements
- ✅ Duplicates allowed
- ❌ O(n) insert/remove at middle or beginning
- ❌ Not thread-safe

### **Performance:**
```
Operation          | Time Complexity
-------------------|----------------
get(int index)     | O(1)
add(E element)     | O(1) amortized
add(int index, E)  | O(n)
remove(int index)  | O(n)
remove(Object)     | O(n) (requires search)
indexOf(Object)    | O(n)
contains(Object)   | O(n)
iterator.next()    | O(1)
```

### **Interview Questions:**

**Q: How does ArrayList grow internally?**
> Creates new array of size `oldCapacity + (oldCapacity >> 1)` (50% growth), copies elements using `Arrays.copyOf()`.

**Q: What's the difference between size and capacity?**
> `size()` = actual element count. `capacity` = array length (internal). Capacity can be larger than size.

**Q: When does ArrayList shrink?**
> Doesn't automatically shrink. Use `trimToSize()` to reduce capacity to current size.

**Q: How to make ArrayList thread-safe?**
> 1. `Collections.synchronizedList(new ArrayList<>())`
> 2. `CopyOnWriteArrayList` for read-heavy scenarios
> 3. Use explicit synchronization

**Q: What's the initial capacity? Why 10?**
> Default is 10 (empirical balance between memory waste and resize frequency). Can set custom initial capacity.

**Q: What happens when adding beyond capacity?**
> Triggers `grow()` - new array created, all elements copied (O(n) operation).

---

## **2. LINKEDLIST - Double-Ended Operations** 🔗

```java
// As List
List<String> list = new LinkedList<>();
list.add("A");
list.add(1, "B");
list.get(0);  // O(n) - traverses from head!

// As Deque (Queue/Stack)
Deque<String> deque = new LinkedList<>();
deque.addFirst("First");
deque.addLast("Last");
deque.removeFirst();
deque.removeLast();

// As Queue
Queue<String> queue = new LinkedList<>();
queue.offer("A");
queue.poll();

// Stack operations (LIFO)
deque.push("Top");
String top = deque.pop();

// Special LinkedList methods
LinkedList<String> ll = new LinkedList<>();
ll.addFirst("Head");
ll.addLast("Tail");
String first = ll.getFirst();
String last = ll.getLast();
ll.removeFirst();
ll.removeLast();
```

### **Internal Structure:**
- Doubly-linked list of Node objects
- Each node: `item`, `next`, `prev` references
- Maintains `first` and `last` pointers
- `size` counter

```java
private static class Node<E> {
    E item;
    Node<E> next;
    Node<E> prev;
}
```

### **Key Features:**
- ✅ O(1) insert/remove at beginning and end
- ✅ O(1) queue operations (offer/poll)
- ✅ O(1) stack operations (push/pop)
- ✅ Implements List, Deque, and Queue
- ✅ Allows null elements
- ❌ O(n) random access (get(index))
- ❌ More memory overhead (node objects)
- ❌ Poor cache locality (scattered nodes)

### **Performance:**
```
Operation          | Time Complexity
-------------------|----------------
get(int index)     | O(n) - traverses list
add(E element)     | O(1) at end
add(int index, E)  | O(n) - find position
addFirst/addLast   | O(1)
remove(int index)  | O(n) - find + remove
remove(Object)     | O(n) - search
iterator.next()    | O(1)
```

### **Interview Questions:**

**Q: LinkedList vs ArrayList - when to use which?**
> ArrayList: frequent random access, iteration, add/remove at end.  
> LinkedList: frequent add/remove at ends, queue/stack operations, memory not a concern.

**Q: How does LinkedList find an element by index?**
> Traverses from nearest end: if index < size/2, from head; else from tail.

**Q: Memory comparison: ArrayList vs LinkedList?**
> ArrayList: single array overhead. LinkedList: per-node overhead (object headers, 3 references). LinkedList uses ~3-4x more memory.

**Q: Can LinkedList be used as Queue and Stack?**
> Yes! Implements Deque, so supports both FIFO (queue) and LIFO (stack) operations.

**Q: Why is LinkedList's get(index) slow?**
> Must traverse nodes sequentially - no direct index access like array.

---

## **3. VECTOR - Legacy Thread-Safe List** 📜

```java
// Creation
Vector<String> vector = new Vector<>();           // Default size 10
Vector<String> vector2 = new Vector<>(100);       // Initial capacity
Vector<String> vector3 = new Vector<>(100, 5);    // Capacity increment

// Basic operations (synchronized)
vector.add("A");
vector.add(1, "B");
String s = vector.get(2);
vector.remove("A");
vector.remove(0);

// Legacy enumeration (pre-Iterator)
Enumeration<String> e = vector.elements();
while (e.hasMoreElements()) {
    System.out.println(e.nextElement());
}

// Capacity management
int capacity = vector.capacity();
vector.ensureCapacity(200);
vector.trimToSize();

// Thread-safe iteration (but still need sync for compound actions)
synchronized(vector) {
    for (int i = 0; i < vector.size(); i++) {
        // Safe from concurrent modification
    }
}
```

### **Internal Structure:**
- Dynamic array (like ArrayList)
- All methods synchronized (method-level lock)
- Can specify capacity increment (growth amount)

### **Key Features:**
- ✅ Thread-safe (synchronized methods)
- ✅ O(1) random access
- ✅ Legacy Enumeration support
- ✅ Can set capacity increment
- ❌ Poor performance under concurrency (single lock)
- ❌ Legacy class - prefer ArrayList + synchronization

### **Performance:**
```
Operation          | Time Complexity | Synchronization
-------------------|-----------------|----------------
get(int index)     | O(1)            | Method-level lock
add(E element)     | O(1) amortized  | Method-level lock
add(int index, E)  | O(n)            | Method-level lock
remove(int index)  | O(n)            | Method-level lock
iterator()         | Fail-fast       | Must synchronize manually
```

### **Interview Questions:**

**Q: Vector vs ArrayList - differences?**
> Vector: synchronized, legacy, capacity increment, Enumeration. ArrayList: not synchronized, modern, faster.

**Q: Why is Vector considered legacy?**
> Synchronized methods cause performance bottleneck. Prefer Collections.synchronizedList(new ArrayList<>()) for better control.

**Q: What's capacity increment in Vector?**
> Amount to grow when full. If <=0, doubles. ArrayList always doubles (no custom increment).

**Q: Is Vector truly thread-safe?**
> Individual operations are safe, but compound actions (iterate, check-then-act) need external synchronization.

---

## **4. STACK - Legacy LIFO Stack** 📚

```java
// Legacy Stack (extends Vector)
Stack<String> stack = new Stack<>();
stack.push("A");          // Add to top
stack.push("B");
String top = stack.pop(); // "B" - remove and return top
String peek = stack.peek(); // "A" - view top without removing
int position = stack.search("A"); // 2 (1-based from top)
boolean empty = stack.empty();

// DON'T USE! Prefer ArrayDeque instead
Deque<String> betterStack = new ArrayDeque<>();
betterStack.push("A");
betterStack.push("B");
betterStack.pop();
betterStack.peek();
```

### **Internal Structure:**
- Extends Vector (dynamic array)
- Adds stack-specific methods (push, pop, peek, search)
- All methods synchronized (inherited from Vector)

### **Key Features:**
- ✅ LIFO (Last-In-First-Out) operations
- ✅ Thread-safe (inherited from Vector)
- ✅ search() method (1-based from top)
- ❌ Legacy class - don't use in new code!
- ❌ Poor design (extends Vector, not composition)

### **Performance:**
```
Operation          | Time Complexity
-------------------|----------------
push(E)            | O(1) amortized
pop()              | O(1)
peek()             | E peek()
search(Object)     | O(n) - scans from top
empty()            | O(1)
```

### **Interview Questions:**

**Q: Why is Stack class considered bad?**
> 1. Extends Vector (inherits unrelated methods like get(index))
> 2. Synchronization overhead
> 3. Legacy - ArrayDeque is better choice

**Q: Stack vs ArrayDeque for LIFO?**
> ArrayDeque: faster, no synchronization overhead, designed for stack usage. Always prefer ArrayDeque.

**Q: How does search() work?**
> Returns 1-based position from top (top = 1). Returns -1 if not found.

---

## **5. COPYONWRITEARRAYLIST - Concurrent Read-Optimized** 📋🔒

```java
// Creation
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
CopyOnWriteArrayList<String> list2 = new CopyOnWriteArrayList<>(existingList);

// Read operations - never blocked, never synchronized
String s = list.get(0);
boolean contains = list.contains("A");
int size = list.size();
Iterator<String> it = list.iterator();  // Immutable snapshot!

// Write operations - creates new copy
list.add("A");           // Creates new array
list.add(1, "B");        // Creates new array
list.remove("A");        // Creates new array
list.set(0, "New");      // Creates new array

// Thread-safe iteration (no ConcurrentModificationException)
for (String item : list) {  // Uses snapshot iterator
    System.out.println(item);
    list.add("X");  // Doesn't affect current iteration!
}

// Bulk operations (also copy)
list.addAll(otherList);
list.removeAll(toRemove);
```

### **Internal Structure:**
- Dynamic array with ReentrantLock
- Copy-on-write: modifications create new array copy
- All mutators synchronized with lock
- Iterators use immutable snapshot

```java
private transient volatile Object[] array;
private final transient ReentrantLock lock = new ReentrantLock();

// Add operation
public boolean add(E e) {
    lock.lock();
    try {
        Object[] newArray = Arrays.copyOf(array, array.length + 1);
        newArray[newArray.length - 1] = e;
        array = newArray;  // Volatile publish
        return true;
    } finally {
        lock.unlock();
    }
}
```

### **Key Features:**
- ✅ Thread-safe without synchronization for reads
- ✅ No ConcurrentModificationException
- ✅ Iterator sees immutable snapshot
- ✅ Perfect for read-mostly scenarios
- ❌ Expensive writes (O(n) copy)
- ❌ Memory overhead (multiple array copies)
- ❌ Not for write-heavy workloads

### **Performance:**
```
Operation          | Time Complexity | Notes
-------------------|-----------------|------
get(int index)     | O(1)            | No synchronization
add(E element)     | O(n)            | Copies entire array
add(int index, E)  | O(n)            | Copies + shift
remove(Object)     | O(n)            | Copies + search
iterator()         | O(1)            | Snapshot, no ConcurrentModification
contains(Object)   | O(n)            | No synchronization
```

### **Interview Questions:**

**Q: When to use CopyOnWriteArrayList?**
> Read-heavy, write-rarely scenarios: listener lists, configuration, cache, subscription lists.

**Q: How does CopyOnWriteArrayList avoid ConcurrentModificationException?**
> Iterators work on immutable snapshot of array at creation time - modifications create new array.

**Q: What's the memory impact?**
> Each write creates new array copy while old array may still be in use by iterators. Can cause memory pressure.

**Q: Is CopyOnWriteArrayList suitable for write-heavy workloads?**
> No - each write copies entire array, O(n) cost. Use ConcurrentLinkedQueue or synchronized list instead.

**Q: How are iterators thread-safe?**
> Iterator holds reference to array at creation time. Subsequent modifications don't affect it.

---

## **6. ARRAYS.ASLIST() - Fixed-Size List View** 🔄

```java
// Create fixed-size list backed by array
String[] array = {"A", "B", "C"};
List<String> list = Arrays.asList(array);  // Returns java.util.Arrays.ArrayList

// OR directly
List<String> list = Arrays.asList("A", "B", "C", "D");

// Operations
list.set(0, "X");        // Modifies both list AND original array!
String s = list.get(1);   // O(1)
list.add("D");            // ❌ UnsupportedOperationException!
list.remove(0);           // ❌ UnsupportedOperationException!

// Array and list are linked
array[0] = "Y";           // Also changes list
System.out.println(list.get(0)); // "Y"

// Use for API that expects List but you have array
public void process(List<String> items) { ... }
process(Arrays.asList("A", "B", "C"));
```

### **Internal Structure:**
- Inner class `Arrays.ArrayList` (different from java.util.ArrayList)
- Fixed-size array reference (backed by original array)
- Cannot change size (no add/remove)

### **Key Features:**
- ✅ Bridge between arrays and collections
- ✅ Fixed-size view of array
- ✅ O(1) get/set operations
- ✅ Serializable
- ❌ Cannot add or remove elements
- ❌ Changes reflect in both directions

### **Interview Questions:**

**Q: Arrays.asList() vs ArrayList - differences?**
> Arrays.asList(): fixed-size, backed by array, no add/remove. ArrayList: dynamic size, full List operations.

**Q: What happens if you try to add to Arrays.asList() result?**
> Throws UnsupportedOperationException - underlying array can't change size.

**Q: Does Arrays.asList() create a new ArrayList?**
> No - returns inner class `Arrays.ArrayList` (different from java.util.ArrayList) that wraps the array.

**Q: How to create modifiable list from array?**
> `new ArrayList<>(Arrays.asList(array))` creates independent, modifiable copy.

---

## **7. LIST.OF() - Immutable Lists (Java 9+)** 🔒

```java
// Factory methods - immutable lists
List<String> list1 = List.of();                 // Empty list
List<String> list2 = List.of("A");              // Single element
List<String> list3 = List.of("A", "B");         // Two elements
List<String> list4 = List.of("A", "B", "C");    // Three elements
// ... up to 10 elements

// More than 10 elements
List<String> list5 = List.of("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K");

// OR using ofEntries (varargs)
List<String> list6 = List.of(someArray);  // array of elements

// All operations that modify throw exception!
list5.add("X");           // ❌ UnsupportedOperationException
list5.set(0, "Z");        // ❌ UnsupportedOperationException
list5.remove(0);          // ❌ UnsupportedOperationException

// Null not allowed!
List.of("A", null);       // ❌ NullPointerException!

// But can still read
String first = list5.get(0);
boolean contains = list5.contains("A");
int size = list5.size();

// Thread-safe without synchronization
// Perfect for constants and configuration
public static final List<String> SUPPORTED_COUNTRIES = List.of("US", "UK", "CA");
```

### **Internal Structure:**
- JVM-optimized immutable implementations
- Different internal classes for different sizes
- No backing mutable array

### **Key Features:**
- ✅ Truly immutable (cannot modify)
- ✅ Thread-safe (no synchronization needed)
- ✅ Memory efficient (JVM optimizations)
- ✅ Null elements not allowed
- ✅ Fixed-time creation
- ❌ No modification operations
- ❌ Not for dynamic data

### **Interview Questions:**

**Q: List.of() vs Arrays.asList() differences?**
> List.of(): immutable, no nulls. Arrays.asList(): fixed-size but mutable (set allowed), allows nulls.

**Q: Can you modify List.of() result?**
> No - all mutator methods throw UnsupportedOperationException. Truly immutable.

**Q: When to use List.of()?**
> Constants, configuration, immutable data, returning read-only collections from APIs.

**Q: List.of() vs Collections.unmodifiableList()?**
> List.of(): truly immutable, JVM-optimized. unmodifiableList: wrapper on mutable list (can change if backing list changes).

---

## **8. SUBLIST - View of ArrayList Portion** 🔍

```java
List<String> list = new ArrayList<>();
list.add("A"); list.add("B"); list.add("C"); list.add("D"); list.add("E");

// Create sublist view
List<String> sub = list.subList(1, 4);  // [B, C, D] - index 1 to 3

// Sublist operations affect original list!
sub.set(0, "X");           // Original list becomes [A, X, C, D, E]
sub.add(1, "Y");           // Original: [A, X, Y, C, D, E]
sub.remove(2);             // Original: [A, X, Y, D, E]

// Clear sublist (removes range from original)
sub.clear();               // Original becomes [A, E]

// WARNING: Original list cannot be modified structurally
// after creating sublist without re-creating sublist
List<String> sub2 = list.subList(1, 3);
list.add("F");              // ❌ ConcurrentModificationException on sub2 operations!

// Getting sublist as independent list
List<String> independent = new ArrayList<>(list.subList(1, 4));
```

### **Internal Structure:**
- View into parent ArrayList (not a copy)
- Maintains reference to parent list and offset
- All operations delegate to parent with bounds checking

### **Key Features:**
- ✅ No copying - efficient view
- ✅ Changes reflected in parent
- ✅ O(1) creation time
- ✅ Supports all List operations
- ❌ Parent can't be modified structurally while sublist in use
- ❌ Short-lived views only

### **Interview Questions:**

**Q: What happens when you modify original list after creating sublist?**
> Any structural modification (add/remove) to original invalidates sublist - subsequent sublist operations throw ConcurrentModificationException.

**Q: Is sublist a copy?**
> No - it's a view backed by original list. Changes in either affect the other.

**Q: How to get independent sublist copy?**
> `new ArrayList<>(original.subList(from, to))` creates independent copy.

**Q: Use case for sublist?**
> Processing ranges, pagination, removing range of elements (subList.clear()).

---

## **📊 PERFORMANCE COMPARISON**

| Operation | ArrayList | LinkedList | Vector | CopyOnWriteArrayList |
|-----------|-----------|------------|--------|---------------------|
| **get(index)** | O(1) ⚡ | O(n) 🐢 | O(1) ⚡ | O(1) ⚡ |
| **add(end)** | O(1)* ⚡ | O(1) ⚡ | O(1)* ⚡ | O(n) 🐢 |
| **add(index)** | O(n) | O(n) | O(n) | O(n) 🐢 |
| **remove(index)** | O(n) | O(n) | O(n) | O(n) 🐢 |
| **remove(object)** | O(n) | O(n) | O(n) | O(n) 🐢 |
| **iterator** | O(1) ⚡ | O(1) ⚡ | O(1) ⚡ | O(1) ⚡ |
| **memory** | Low | High (nodes) | Low | Very High (copies) |
| **thread-safety** | ❌ | ❌ | ✅ | ✅ |

* *Amortized O(1) - occasional resize*

---

## **🎯 WHEN TO USE WHICH LIST**

### **Single-threaded applications:**
| Scenario | Recommendation |
|----------|---------------|
| **General purpose** | `ArrayList` (default choice) |
| **Frequent add/remove at ends** | `LinkedList` |
| **Queue/Stack operations** | `ArrayDeque` (not List) |
| **Fixed-size array wrapper** | `Arrays.asList()` |
| **Immutable constants** | `List.of()` |
| **Range view of list** | `subList()` |

### **Multi-threaded applications:**
| Scenario | Recommendation |
|----------|---------------|
| **Read-mostly, writes rare** | `CopyOnWriteArrayList` |
| **Need thread-safety** | `Collections.synchronizedList(new ArrayList<>())` |
| **Legacy code** | `Vector` (but migrate!) |
| **Immutable shared data** | `List.of()` |

### **Special purposes:**
| Scenario | Recommendation |
|----------|---------------|
| **LIFO Stack** | `ArrayDeque` (not Stack) |
| **Need Enumeration** | `Vector` (legacy only) |
| **Large data, random access** | `ArrayList` with initial capacity |
| **Frequent insertion in middle** | Consider `LinkedList` or different data structure |

---

## **📝 COMMON INTERVIEW QUESTIONS**

### **Q1: ArrayList vs LinkedList - when to use which?**
> **ArrayList**: Random access, iteration, add/remove at end.  
> **LinkedList**: Frequent add/remove at ends, queue/stack operations, memory not a concern.

### **Q2: How does ArrayList grow?**
> Creates new array of `oldCapacity + (oldCapacity >> 1)` (50% growth), copies elements.

### **Q3: How to make ArrayList thread-safe?**
> 1. `Collections.synchronizedList(new ArrayList<>())`
> 2. `CopyOnWriteArrayList` for read-heavy
> 3. Explicit synchronization

### **Q4: Difference between size and capacity in ArrayList?**
> `size()` = actual element count. `capacity` = internal array length.

### **Q5: Why is LinkedList's get(index) slow?**
> Must traverse nodes from nearest end - no direct index access.

### **Q6: Vector vs ArrayList?**
> Vector: synchronized, legacy, capacity increment. ArrayList: not synchronized, modern, faster.

### **Q7: Why not use Stack class?**
> Extends Vector (inherits unrelated methods), synchronized overhead. Use ArrayDeque instead.

### **Q8: When to use CopyOnWriteArrayList?**
> Read-heavy, write-rarely scenarios (listener lists, configuration). Each write copies entire array.

### **Q9: Arrays.asList() vs List.of()?**
> Arrays.asList(): fixed-size, mutable (set allowed), allows nulls. List.of(): immutable, no nulls.

### **Q10: What happens when modifying original list after creating sublist?**
> Structural modifications to original invalidate sublist - throws ConcurrentModificationException.

### **Q11: How to remove range of elements efficiently?**
> `list.subList(from, to).clear()` - O(n) but efficient (single operation).

### **Q12: What's fail-fast behavior?**
> Iterators throw ConcurrentModificationException if list modified structurally during iteration.

### **Q13: How does CopyOnWriteArrayList avoid ConcurrentModificationException?**
> Iterators work on immutable snapshot - modifications create new array copy.

### **Q14: What's the default initial capacity of ArrayList?**
> 10. Can set custom: `new ArrayList<>(100)`

### **Q15: How to convert array to List and vice versa?**
> ```java
> // Array → List
> List<String> list = Arrays.asList(array);
> List<String> modifiable = new ArrayList<>(Arrays.asList(array));
> List<String> immutable = List.of(array);
> 
> // List → Array
> String[] array = list.toArray(new String[0]);
> String[] array2 = list.toArray(new String[list.size()]);
> ```

---

## **💡 KEY TAKEAWAYS**

1. **Default choice**: `ArrayList` (fast random access, iteration)
2. **Need queue/stack operations**: `LinkedList` or `ArrayDeque`
3. **Thread-safe, read-heavy**: `CopyOnWriteArrayList`
4. **Thread-safe general**: `Collections.synchronizedList()`
5. **Immutable data**: `List.of()` (Java 9+)
6. **Fixed-size array wrapper**: `Arrays.asList()`
7. **Range operations**: `subList()`
8. **Legacy code**: `Vector` and `Stack` (avoid in new code)
9. **Memory efficiency**: `ArrayList` over `LinkedList`
10. **Concurrent modification**: Use `CopyOnWriteArrayList` or synchronize manually

---

## **🚀 QUICK CODE SNIPPETS**

```java
// Default - ArrayList
List<String> list = new ArrayList<>();
list.add("A");
String s = list.get(0);

// LinkedList as Queue/Deque
Deque<String> deque = new LinkedList<>();
deque.addFirst("A");
deque.addLast("B");
String first = deque.removeFirst();

// Thread-safe read-heavy
CopyOnWriteArrayList<String> cow = new CopyOnWriteArrayList<>();
cow.add("A");  // Expensive
String val = cow.get(0);  // Fast, no sync

// Fixed-size array view
List<String> fixed = Arrays.asList("A", "B", "C");
fixed.set(0, "X");  // OK
// fixed.add("D");  // ❌ Exception

// Immutable list (Java 9+)
List<String> immutable = List.of("A", "B", "C");
// immutable.add("D");  // ❌ Exception

// Sublist view
List<String> sub = list.subList(1, 3);
sub.clear();  // Removes range from original

// Synchronized wrapper
List<String> sync = Collections.synchronizedList(new ArrayList<>());
synchronized(sync) {
    for (String item : sync) {  // Must synchronize iteration
        // process
    }
}
```

---

*Happy Interview Prep! 🎉*