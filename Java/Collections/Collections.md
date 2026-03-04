# **Complete Collections Utility Class Guide** 🛠️

_A comprehensive guide to all java.util.Collections methods with examples and use cases_

---

## **📋 OVERVIEW**

`java.util.Collections` is a utility class containing **static methods** that operate on or return collections. It provides:

- **Sorting and searching**
- **Synchronization wrappers**
- **Unmodifiable wrappers**
- **Empty/singleton collections**
- **Algorithms** (shuffle, reverse, rotate, etc.)

---

## **1. SORTING AND ORDERING** 📊

### **sort() - Sort List Elements**

```java
List<Integer> numbers = new ArrayList<>(Arrays.asList(5, 2, 8, 1, 9));

// Natural order
Collections.sort(numbers);  // [1, 2, 5, 8, 9]

// With comparator
Collections.sort(numbers, Collections.reverseOrder());  // [9, 8, 5, 2, 1]

// Custom comparator
List<Person> people = getPeople();
Collections.sort(people, Comparator.comparing(Person::getAge));

// Java 8+ alternative: list.sort()
numbers.sort(Comparator.naturalOrder());
```

### **reverse() - Reverse List Order**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C", "D"));
Collections.reverse(list);  // [D, C, B, A]
```

### **shuffle() - Randomly Permute List**

```java
List<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
Collections.shuffle(list);  // Random order e.g., [3, 1, 5, 2, 4]
Collections.shuffle(list, new Random(42));  // With seeded random
```

### **rotate() - Rotate List Elements**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C", "D", "E"));

// Positive distance = shift right
Collections.rotate(list, 2);  // [D, E, A, B, C]

// Negative distance = shift left
Collections.rotate(list, -1);  // [B, C, D, E, A]

// Useful for circular buffers
```

### **swap() - Swap Two Elements**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C", "D"));
Collections.swap(list, 1, 3);  // [A, D, C, B]
```

### **replaceAll() - Replace All Occurrences**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "A", "C", "A"));
Collections.replaceAll(list, "A", "X");  // [X, B, X, C, X]
```

---

## **2. SEARCHING AND BOUNDARIES** 🔍

### **binarySearch() - Fast Search in Sorted List**

```java
List<Integer> list = new ArrayList<>(Arrays.asList(1, 3, 5, 7, 9, 11));

// Must be sorted first!
int index = Collections.binarySearch(list, 5);  // Returns 2 (found)
int index = Collections.binarySearch(list, 6);  // Returns -4 (insertion point = 3)

// With comparator
List<String> words = Arrays.asList("apple", "banana", "cherry");
int pos = Collections.binarySearch(words, "BANANA", String.CASE_INSENSITIVE_ORDER);

// Binary search returns:
// - Positive index if found
// - Negative: -(insertion point) - 1 if not found
```

### **min() / max() - Find Extremes**

```java
Collection<Integer> numbers = Arrays.asList(42, 17, 89, 3, 56);

Integer min = Collections.min(numbers);  // 3
Integer max = Collections.max(numbers);  // 89

// With custom comparator
Person youngest = Collections.min(people, Comparator.comparing(Person::getAge));
Person oldest = Collections.max(people, Comparator.comparing(Person::getAge));

// For empty collections:
Integer safeMin = numbers.isEmpty() ? null : Collections.min(numbers);
```

### **frequency() - Count Occurrences**

```java
List<String> list = Arrays.asList("A", "B", "A", "C", "A", "B");
int count = Collections.frequency(list, "A");  // 3
int countB = Collections.frequency(list, "B");  // 2

// Useful for finding duplicates
boolean hasDuplicates = Collections.frequency(list, "A") > 1;
```

### **disjoint() - Check No Common Elements**

```java
Collection<String> c1 = Arrays.asList("A", "B", "C");
Collection<String> c2 = Arrays.asList("D", "E", "F");
Collection<String> c3 = Arrays.asList("C", "D", "E");

boolean noCommon = Collections.disjoint(c1, c2);  // true
boolean noCommon2 = Collections.disjoint(c1, c3);  // false (both have "C")

// Efficient for large collections - stops at first common
```

---

## **3. SYNCHRONIZATION WRAPPERS (THREAD-SAFE)** 🔒

### **synchronizedCollection() - Thread-Safe View**

```java
Collection<String> original = new ArrayList<>();
Collection<String> syncCollection = Collections.synchronizedCollection(original);

// All operations are synchronized
syncCollection.add("A");
syncCollection.add("B");

// Must synchronize on iteration!
synchronized(syncCollection) {
    for (String s : syncCollection) {
        System.out.println(s);
    }
}
```

### **synchronizedList() - Thread-Safe List**

```java
List<String> list = new ArrayList<>();
List<String> syncList = Collections.synchronizedList(list);

// Use for thread-safe operations
syncList.add("A");
String s = syncList.get(0);

// Iteration requires external sync
synchronized(syncList) {
    for (String item : syncList) {
        // process
    }
}

// Better alternative: CopyOnWriteArrayList for read-heavy
// Better: ConcurrentLinkedDeque for high concurrency
```

### **synchronizedSet() - Thread-Safe Set**

```java
Set<String> set = new HashSet<>();
Set<String> syncSet = Collections.synchronizedSet(set);

syncSet.add("A");
syncSet.contains("A");

synchronized(syncSet) {
    for (String s : syncSet) {
        // process
    }
}

// Better alternative: CopyOnWriteArraySet for read-heavy
// Better: ConcurrentSkipListSet for sorted
```

### **synchronizedMap() - Thread-Safe Map**

```java
Map<String, Integer> map = new HashMap<>();
Map<String, Integer> syncMap = Collections.synchronizedMap(map);

syncMap.put("A", 1);
Integer val = syncMap.get("A");

synchronized(syncMap) {
    for (Map.Entry<String, Integer> entry : syncMap.entrySet()) {
        // process
    }
}

// Better alternative: ConcurrentHashMap (preferred!)
```

### **synchronizedSortedSet() / synchronizedSortedMap()**

```java
SortedSet<String> sortedSet = new TreeSet<>();
SortedSet<String> syncSortedSet = Collections.synchronizedSortedSet(sortedSet);

SortedMap<String, Integer> sortedMap = new TreeMap<>();
SortedMap<String, Integer> syncSortedMap = Collections.synchronizedSortedMap(sortedMap);
```

---

## **4. UNMODIFIABLE WRAPPERS (READ-ONLY)** 🔐

### **unmodifiableCollection() - Read-Only View**

```java
Collection<String> original = new ArrayList<>();
original.add("A");
original.add("B");

Collection<String> unmod = Collections.unmodifiableCollection(original);

// Read operations OK
System.out.println(unmod.size());  // 2
System.out.println(unmod.contains("A"));  // true

// Write operations throw UnsupportedOperationException
unmod.add("C");  // ❌ Exception!

// Original changes still reflect in view
original.add("C");
System.out.println(unmod.size());  // 3 (view sees changes!)
```

### **unmodifiableList() / unmodifiableSet() / unmodifiableMap()**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C"));
List<String> unmodList = Collections.unmodifiableList(list);
// unmodList.add("D");  // Exception!

Set<String> set = new HashSet<>(Arrays.asList("A", "B", "C"));
Set<String> unmodSet = Collections.unmodifiableSet(set);
// unmodSet.add("D");  // Exception!

Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
Map<String, Integer> unmodMap = Collections.unmodifiableMap(map);
// unmodMap.put("B", 2);  // Exception!

// For sorted versions
SortedSet<String> unmodSortedSet = Collections.unmodifiableSortedSet(sortedSet);
SortedMap<String, Integer> unmodSortedMap = Collections.unmodifiableSortedMap(sortedMap);

// Java 9+ alternative (truly immutable)
List<String> immutable = List.of("A", "B", "C");
```

### **Important: Unmodifiable vs Immutable**

```java
// unmodifiable - backed by original, can change!
List<String> original = new ArrayList<>();
List<String> unmod = Collections.unmodifiableList(original);

original.add("A");  // Changes reflect in unmod!
System.out.println(unmod);  // [A]

// immutable - truly fixed
List<String> immutable = List.of("A", "B");
// immutable.add("C");  // Exception, and no backing collection
```

---

## **5. EMPTY AND SINGLETON COLLECTIONS** 📦

### **emptyList() / emptySet() / emptyMap()**

```java
// Type-safe empty collections (Java 5+)
List<String> emptyList = Collections.emptyList();
Set<String> emptySet = Collections.emptySet();
Map<String, String> emptyMap = Collections.emptyMap();

// Use to avoid null returns
public List<String> getNames() {
    return names.isEmpty() ? Collections.emptyList() : names;
}

// Immutable - cannot add elements
// emptyList.add("A");  // Exception!

// Java 9+ also has List.of(), Set.of(), Map.of() for empty
List<String> alsoEmpty = List.of();  // Same thing
```

### **singletonList() / singleton() / singletonMap()**

```java
// Single-element immutable collections
List<String> singleList = Collections.singletonList("A");
Set<String> singleSet = Collections.singleton("A");
Map<String, Integer> singleMap = Collections.singletonMap("key", 42);

// Cannot add more elements
// singleList.add("B");  // Exception!

// Useful for APIs expecting Collection
processItems(Collections.singletonList(item));

// Java 9+ alternatives
List.of("A");
Set.of("A");
Map.of("key", 42);
```

### **nCopies() - List with Repeated Elements**

```java
// Creates list with n copies of object
List<String> copies = Collections.nCopies(5, "Hello");
// ["Hello", "Hello", "Hello", "Hello", "Hello"]

// Immutable - cannot modify
// copies.set(0, "Changed");  // Exception!

// Memory efficient - single object reference repeated
List<Integer> tens = Collections.nCopies(10, 10);
System.out.println(tens);  // [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

// Useful for initialization
List<Boolean> defaultList = Collections.nCopies(100, false);
```

---

## **6. COLLECTION ALGORITHMS** ⚙️

### **fill() - Replace All Elements**

```java
List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C", "D"));
Collections.fill(list, "X");  // [X, X, X, X]

// Useful for resetting collections
List<Integer> scores = new ArrayList<>(Arrays.asList(95, 87, 92));
Collections.fill(scores, 0);  // Reset to zero
```

### **copy() - Copy Between Lists**

```java
List<String> dest = new ArrayList<>(Arrays.asList("", "", "", ""));
List<String> src = Arrays.asList("A", "B", "C", "D");

Collections.copy(dest, src);  // dest now ["A", "B", "C", "D"]

// dest must have size >= src.size()
List<String> dest2 = new ArrayList<>(Collections.nCopies(4, null));
Collections.copy(dest2, src);  // Works

// Java 8+ alternative: dest2 = new ArrayList<>(src);
```

### **addAll() - Add Multiple Elements**

```java
Collection<String> collection = new ArrayList<>();

// Varargs version
Collections.addAll(collection, "A", "B", "C", "D");

// With array
String[] array = {"X", "Y", "Z"};
Collections.addAll(collection, array);

// More efficient than repeated add()
// Returns true if collection changed
```

### **indexOfSubList() / lastIndexOfSubList() - Find Sublists**

```java
List<String> list = Arrays.asList("A", "B", "C", "D", "B", "C", "E");
List<String> target = Arrays.asList("B", "C");

int first = Collections.indexOfSubList(list, target);   // 1
int last = Collections.lastIndexOfSubList(list, target); // 4

// Returns -1 if not found
```

---

## **7. CHECKED COLLECTIONS (TYPE-SAFE)** ✅

### **checkedList() / checkedSet() / checkedMap()**

```java
// Create type-checked wrappers
List<String> checkedList = Collections.checkedList(
    new ArrayList<>(), String.class
);

// Prevents heap pollution (mixing types)
List rawList = checkedList;
rawList.add(123);  // ❌ ClassCastException at runtime!

// Useful for public APIs to ensure type safety
public List<String> getNames() {
    return Collections.checkedList(new ArrayList<>(), String.class);
}

// Checked set and map
Set<Integer> checkedSet = Collections.checkedSet(
    new HashSet<>(), Integer.class
);

Map<String, Date> checkedMap = Collections.checkedMap(
    new HashMap<>(), String.class, Date.class
);
```

---

## **8. ENUMERATION UTILITIES** 📜

### **enumeration() - Iterator to Enumeration**

```java
List<String> list = Arrays.asList("A", "B", "C");
Enumeration<String> enumeration = Collections.enumeration(list);

// For legacy APIs expecting Enumeration
while (enumeration.hasMoreElements()) {
    String s = enumeration.nextElement();
    System.out.println(s);
}
```

### **list() - Enumeration to ArrayList**

```java
Vector<String> vector = new Vector<>();
vector.add("A"); vector.add("B"); vector.add("C");

Enumeration<String> enumeration = vector.elements();
ArrayList<String> list = Collections.list(enumeration);
// list = ["A", "B", "C"]
```

---

## **9. COMPARATOR UTILITIES** ⚖️

### **reverseOrder() - Reverse Comparator**

```java
// Get reverse natural order comparator
Comparator<String> reverse = Collections.reverseOrder();

// For specific comparator
Comparator<String> myComp = String.CASE_INSENSITIVE_ORDER;
Comparator<String> reverseMyComp = Collections.reverseOrder(myComp);

// Usage
List<String> list = Arrays.asList("A", "C", "B");
Collections.sort(list, Collections.reverseOrder());  // [C, B, A]
```

---

## **10. MISCELLANEOUS METHODS** 🎲

### **newSetFromMap() - Set from Map**

```java
// Create concurrent set from ConcurrentHashMap
Set<String> concurrentSet = Collections.newSetFromMap(
    new ConcurrentHashMap<String, Boolean>()
);

// Create weak set from WeakHashMap
Set<String> weakSet = Collections.newSetFromMap(
    new WeakHashMap<String, Boolean>()
);

// All map operations delegated to set
concurrentSet.add("A");
concurrentSet.contains("A");

// Useful for creating specialized Set implementations
```

### **asLifoQueue() - LIFO Queue from Deque**

```java
Deque<String> deque = new ArrayDeque<>();
Queue<String> lifoQueue = Collections.asLifoQueue(deque);

// Behaves as LIFO queue (stack)
lifoQueue.add("A");
lifoQueue.add("B");
lifoQueue.add("C");

String top = lifoQueue.remove();  // "C" (last in)
String next = lifoQueue.remove(); // "B"
```

---

## **📊 QUICK REFERENCE TABLE**

| Category         | Method               | Description                  |
| ---------------- | -------------------- | ---------------------------- |
| **Sorting**      | `sort()`             | Sort list                    |
|                  | `reverse()`          | Reverse list                 |
|                  | `shuffle()`          | Randomize list               |
|                  | `rotate()`           | Rotate list                  |
|                  | `swap()`             | Swap elements                |
|                  | `replaceAll()`       | Replace all occurrences      |
| **Searching**    | `binarySearch()`     | Binary search in sorted list |
|                  | `min()`/`max()`      | Find extremes                |
|                  | `frequency()`        | Count occurrences            |
|                  | `disjoint()`         | Check common elements        |
| **Synchronized** | `synchronizedList()` | Thread-safe List             |
|                  | `synchronizedSet()`  | Thread-safe Set              |
|                  | `synchronizedMap()`  | Thread-safe Map              |
| **Unmodifiable** | `unmodifiableList()` | Read-only List               |
|                  | `unmodifiableSet()`  | Read-only Set                |
|                  | `unmodifiableMap()`  | Read-only Map                |
| **Empty**        | `emptyList()`        | Empty immutable List         |
|                  | `emptySet()`         | Empty immutable Set          |
|                  | `emptyMap()`         | Empty immutable Map          |
| **Singleton**    | `singletonList()`    | Single-element List          |
|                  | `singleton()`        | Single-element Set           |
|                  | `singletonMap()`     | Single-element Map           |
| **Algorithms**   | `fill()`             | Fill with value              |
|                  | `copy()`             | Copy between lists           |
|                  | `addAll()`           | Add multiple elements        |
|                  | `indexOfSubList()`   | Find sublist position        |
| **Checked**      | `checkedList()`      | Type-safe wrapper            |
| **Enumeration**  | `enumeration()`      | Iterator to Enumeration      |
|                  | `list()`             | Enumeration to ArrayList     |
| **Comparator**   | `reverseOrder()`     | Reverse comparator           |
| **Misc**         | `newSetFromMap()`    | Set from Map                 |
|                  | `asLifoQueue()`      | Deque as LIFO queue          |

---

## **🎯 USE CASE EXAMPLES**

### **1. Thread-Safe List with Iteration**

```java
List<String> list = Collections.synchronizedList(new ArrayList<>());

// Correct iteration pattern
synchronized(list) {
    Iterator<String> it = list.iterator();
    while (it.hasNext()) {
        process(it.next());
    }
}
```

### **2. Return Empty Collection Instead of Null**

```java
public List<Customer> getCustomers() {
    List<Customer> customers = fetchCustomers();
    return customers != null ? customers : Collections.emptyList();
}

// Caller never checks null
for (Customer c : getCustomers()) {
    // Safe even if empty
}
```

### **3. Initialize Collection with Default Values**

```java
List<Boolean> flags = new ArrayList<>(Collections.nCopies(10, false));
List<String> placeholders = new ArrayList<>(Collections.nCopies(5, "TODO"));
```

### **4. Find Most Frequent Element**

```java
List<String> list = Arrays.asList("A", "B", "A", "C", "A", "B");
String mostFrequent = list.stream()
    .max(Comparator.comparing(s -> Collections.frequency(list, s)))
    .orElse(null);  // "A"
```

### **5. Check if Two Collections Overlap**

```java
List<Integer> list1 = Arrays.asList(1, 2, 3, 4, 5);
List<Integer> list2 = Arrays.asList(6, 7, 8, 9, 10);
List<Integer> list3 = Arrays.asList(5, 6, 7, 8);

boolean noOverlap = Collections.disjoint(list1, list2);  // true
boolean hasOverlap = Collections.disjoint(list1, list3); // false (5 common)
```

### **6. Create Immutable Configuration**

```java
public static final Set<String> SUPPORTED_COUNTRIES =
    Collections.unmodifiableSet(new HashSet<>(Arrays.asList("US", "UK", "CA")));

public static final Map<String, Integer> DEFAULTS =
    Collections.unmodifiableMap(new HashMap<String, Integer>() {{
        put("timeout", 30);
        put("retries", 3);
    }});
```

### **7. Safe Type Casting in Generic Code**

```java
public <T> List<T> getTypedList(Class<T> type) {
    @SuppressWarnings("unchecked")
    List<T> list = (List<T>) rawList;
    return Collections.checkedList(list, type);
}
```

### **8. Rotating Queue (Circular Buffer)**

```java
List<String> buffer = new ArrayList<>(Arrays.asList("", "", ""));
int index = 0;

// Add and rotate
buffer.set(index, newValue);
index = (index + 1) % buffer.size();

// Alternative using Collections.rotate
Collections.rotate(buffer, 1);  // Shift right
```

---

## **⚠️ IMPORTANT NOTES**

1. **Synchronized wrappers** require external sync for iteration
2. **Unmodifiable wrappers** are views - backing changes reflect!
3. **Empty collections** are immutable - cannot add elements
4. **Binary search** requires list to be sorted first
5. **Checked collections** prevent heap pollution at runtime
6. **Java 9+ alternatives** (List.of, Set.of) are often preferred
7. **Concurrent collections** (java.util.concurrent) better than synchronized wrappers for high concurrency

---

## **🚀 QUICK CHEAT SHEET**

```java
// Sorting
Collections.sort(list);
Collections.sort(list, Comparator.reverseOrder());
Collections.reverse(list);
Collections.shuffle(list);
Collections.rotate(list, 2);
Collections.swap(list, 0, 1);

// Searching
int idx = Collections.binarySearch(sortedList, key);
T min = Collections.min(collection);
T max = Collections.max(collection);
int freq = Collections.frequency(collection, obj);
boolean disjoint = Collections.disjoint(c1, c2);

// Thread-safe wrappers
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());

// Read-only wrappers
List<String> unmodList = Collections.unmodifiableList(list);
Set<String> unmodSet = Collections.unmodifiableSet(set);
Map<String, String> unmodMap = Collections.unmodifiableMap(map);

// Empty collections
List<String> emptyList = Collections.emptyList();
Set<String> emptySet = Collections.emptySet();
Map<String, String> emptyMap = Collections.emptyMap();

// Singleton collections
List<String> singleList = Collections.singletonList("A");
Set<String> singleSet = Collections.singleton("A");
Map<String, Integer> singleMap = Collections.singletonMap("key", 1);

// Algorithms
Collections.fill(list, "default");
Collections.copy(dest, src);
Collections.addAll(collection, "A", "B", "C");
int pos = Collections.indexOfSubList(list, target);

// Type-safe wrappers
List<String> checked = Collections.checkedList(list, String.class);

// Enumeration
Enumeration<String> e = Collections.enumeration(list);
ArrayList<String> arrayList = Collections.list(e);

// Comparators
Comparator<String> rev = Collections.reverseOrder();
Comparator<String> revCustom = Collections.reverseOrder(customComp);

// Special
Set<String> setFromMap = Collections.newSetFromMap(new ConcurrentHashMap<>());
Queue<String> lifo = Collections.asLifoQueue(deque);
List<String> nCopies = Collections.nCopies(5, "same");
```

---

_Happy Interview Prep! 🎉_
