# Complete Set Utility Classes Guide 🛠️

*A comprehensive guide to all utility methods for working with Sets in Java (JDK, Apache Commons, and Guava)*

---

## **📋 OVERVIEW**

Java provides several utility classes for Set operations across different libraries:

| Library | Utility Class | Key Features |
|---------|---------------|--------------|
| **JDK** | `Set` interface methods | Java 9+ factory methods, bulk operations |
| **JDK** | `Collections` class | `synchronizedSet()`, `unmodifiableSet()`, singleton/empty sets |
| **Apache Commons** | `SetUtils` | Set operations (union, intersection, difference), type-safe decorators |
| **Google Guava** | `Sets` class | Power set, cartesian product, difference, union, intersection, filtering |

---

## **1. JDK SET UTILITIES (Standard Library)** ☕

### **1.1 Set Interface Methods**

```java
Set<String> set1 = new HashSet<>(Arrays.asList("A", "B", "C"));
Set<String> set2 = new HashSet<>(Arrays.asList("B", "C", "D"));

// Bulk operations (modify set1)
set1.addAll(set2);        // Union - adds all from set2
set1.retainAll(set2);     // Intersection - keeps only elements in both
set1.removeAll(set2);     // Difference - removes all in set2
set1.containsAll(set2);   // Check if set1 contains all of set2

// Note: These modify the set they're called on!
```

### **1.2 Collections Utility Class**

```java
import java.util.Collections;

// Synchronized wrapper (thread-safe)
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());

// Must synchronize on iteration!
synchronized(syncSet) {
    for (String s : syncSet) {
        // process
    }
}

// Unmodifiable wrapper (read-only)
Set<String> unmodSet = Collections.unmodifiableSet(originalSet);
// unmodSet.add("X");  // ❌ UnsupportedOperationException!

// Empty set (immutable)
Set<String> empty = Collections.emptySet();

// Singleton set (immutable, single element)
Set<String> single = Collections.singleton("A");

// Checked set (type-safe at runtime)
Set<String> checked = Collections.checkedSet(new HashSet<>(), String.class);

// Using checked set to prevent heap pollution
Set rawSet = checked;
// rawSet.add(123);  // ❌ ClassCastException at runtime!
```

### **1.3 Java 9+ Factory Methods**

```java
// Immutable sets with varargs (up to 10 elements)
Set<String> set1 = Set.of("A", "B", "C");
Set<String> set2 = Set.of("X", "Y");

// Empty immutable set
Set<String> empty = Set.of();

// Single element immutable set
Set<String> single = Set.of("A");

// Set.of() ensures no duplicates at creation time
// Set.of("A", "A", "B");  // ❌ IllegalArgumentException! Duplicate element

// From array
String[] array = {"A", "B", "C"};
Set<String> fromArray = Set.of(array);  // Creates immutable set

// From existing collection (creates copy)
Set<String> copy = Set.copyOf(existingSet);  // Returns immutable set
```

### **1.4 SequencedSet (Java 21+)**

```java
// Java 21+ - For sets with encounter order (LinkedHashSet, TreeSet)
LinkedHashSet<String> set = new LinkedHashSet<>();
set.add("A");
set.add("B");
set.add("C");

// New sequenced methods
String first = set.getFirst();    // "A"
String last = set.getLast();      // "C"
set.removeFirst();                 // Removes "A"
set.removeLast();                  // Removes "C"
set.addFirst("Z");                 // Adds at beginning
set.addLast("D");                  // Adds at end

// Reversed view
SequencedSet<String> reversed = set.reversed();

// Works with TreeSet too
TreeSet<Integer> treeSet = new TreeSet<>();
treeSet.add(1); treeSet.add(2); treeSet.add(3);
Integer firstInt = treeSet.getFirst();  // 1
Integer lastInt = treeSet.getLast();    // 3

// Works with any SequencedCollection
SequencedSet<String> seqSet = set;
```

### **1.5 Stream API for Set Operations**

```java
Set<Integer> set1 = new HashSet<>(Arrays.asList(1, 2, 3, 4));
Set<Integer> set2 = new HashSet<>(Arrays.asList(3, 4, 5, 6));

// Union (without modifying originals)
Set<Integer> union = Stream.concat(set1.stream(), set2.stream())
    .collect(Collectors.toSet());  // [1, 2, 3, 4, 5, 6]

// Intersection
Set<Integer> intersection = set1.stream()
    .filter(set2::contains)
    .collect(Collectors.toSet());  // [3, 4]

// Difference (set1 - set2)
Set<Integer> difference = set1.stream()
    .filter(e -> !set2.contains(e))
    .collect(Collectors.toSet());  // [1, 2]

// Symmetric difference (elements in either but not both)
Set<Integer> symmetricDiff = Stream.concat(
    set1.stream().filter(e -> !set2.contains(e)),
    set2.stream().filter(e -> !set1.contains(e))
).collect(Collectors.toSet());  // [1, 2, 5, 6]

// Check if one set is subset of another
boolean isSubset = set2.stream().allMatch(set1::contains);
```

---

## **2. APACHE COMMONS SETUTILS** 🐘

### **Maven Dependency**
```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.5.0-M2</version>
</dependency>
```

### **2.1 Basic Set Operations**

```java
import org.apache.commons.collections4.SetUtils;

Set<Integer> set1 = new HashSet<>(Arrays.asList(1, 2, 3, 4));
Set<Integer> set2 = new HashSet<>(Arrays.asList(3, 4, 5, 6));

// Union (returns new set)
Set<Integer> union = SetUtils.union(set1, set2);
// [1, 2, 3, 4, 5, 6]

// Intersection (returns new set)
Set<Integer> intersection = SetUtils.intersection(set1, set2);
// [3, 4]

// Difference (returns new set) - elements in set1 but not in set2
Set<Integer> difference = SetUtils.difference(set1, set2);
// [1, 2]

// Symmetric difference (elements in either but not both)
Set<Integer> symmetricDiff = SetUtils.symmetricDifference(set1, set2);
// [1, 2, 5, 6]

// All operations return new sets, originals unchanged!
```

### **2.2 Disjunction vs Difference**

```java
Set<Integer> setA = new HashSet<>(Arrays.asList(1, 2, 3));
Set<Integer> setB = new HashSet<>(Arrays.asList(3, 4, 5));

// Disjunction = symmetric difference
Set<Integer> disjunction = SetUtils.disjunction(setA, setB);
// [1, 2, 4, 5]

// Difference = elements in first but not second
Set<Integer> diff = SetUtils.difference(setA, setB);
// [1, 2]

// Difference in other direction
Set<Integer> diffRev = SetUtils.difference(setB, setA);
// [4, 5]
```

### **2.3 Subset and Equality Checks**

```java
Set<Integer> set1 = new HashSet<>(Arrays.asList(1, 2, 3));
Set<Integer> set2 = new HashSet<>(Arrays.asList(1, 2, 3, 4));
Set<Integer> set3 = new HashSet<>(Arrays.asList(1, 2, 3));

// Check if set1 is subset of set2
boolean isSubset = SetUtils.isSubSet(set1, set2);  // true

// Check if set2 is subset of set1
boolean isSubset2 = SetUtils.isSubSet(set2, set1);  // false

// Check if sets are equal (ignoring type of Set implementation)
boolean equal = SetUtils.isEqualSet(set1, set3);  // true
boolean notEqual = SetUtils.isEqualSet(set1, set2);  // false

// Compare sets with custom comparators? No - uses equals() on elements
```

### **2.4 Predicated Sets (Validation)**

```java
import org.apache.commons.collections4.PredicateUtils;

Set<String> set = new HashSet<>();

// Ensure all elements are non-null and have length > 2
Set<String> predicated = SetUtils.predicatedSet(
    set,
    PredicateUtils.andPredicate(
        PredicateUtils.notNullPredicate(),
        s -> s != null && s.length() > 2
    )
);

predicated.add("ABC");  // OK
predicated.add("A");    // ❌ IllegalArgumentException! Element rejected
predicated.add(null);   // ❌ IllegalArgumentException! Element rejected

// Custom predicate
Set<Integer> positiveSet = SetUtils.predicatedSet(
    new HashSet<>(),
    n -> n != null && n > 0
);

positiveSet.add(5);    // OK
positiveSet.add(-1);   // ❌ IllegalArgumentException!
```

### **2.5 Type-Safe Sets**

```java
import org.apache.commons.collections4.SetUtils;

// Type-safe set (prevents heap pollution)
Set<String> typeSafeSet = SetUtils.typedSet(new HashSet<>(), String.class);

// This will throw ClassCastException at runtime
Set rawSet = typeSafeSet;
rawSet.add(123);  // ❌ ClassCastException!

// For synchronized type-safe sets
Set<String> syncTyped = SetUtils.synchronizedSet(
    SetUtils.typedSet(new HashSet<>(), String.class)
);
```

### **2.6 Transforming Sets**

```java
import org.apache.commons.collections4.TransformerUtils;

Set<Integer> numbers = new HashSet<>(Arrays.asList(1, 2, 3, 4, 5));

// Create transformed set (values transformed on access/insert)
Set<String> transformed = SetUtils.transformedSet(
    new HashSet<>(),
    TransformerUtils.stringValueTransformer()
);

transformed.add(42);  // Automatically transforms to "42" on add
System.out.println(transformed);  // ["42"]

// For lazy transformation (only when accessed)
Set<String> lazyTransformed = SetUtils.lazySet(
    new HashSet<>(),
    String::valueOf
);
```

### **2.7 Ordered Sets**

```java
import org.apache.commons.collections4.OrderedSet;
import org.apache.commons.collections4.set.ListOrderedSet;

// Set that maintains insertion order
OrderedSet<String> ordered = SetUtils.orderedSet(new HashSet<>());
ordered.add("B");
ordered.add("A");
ordered.add("C");

String first = ordered.first();  // "B"
String last = ordered.last();    // "C"

// ListOrderedSet (implements OrderedSet)
OrderedSet<String> listOrdered = ListOrderedSet.listOrderedSet(new HashSet<>());
listOrdered.add("X");
listOrdered.add("Y");
listOrdered.add("Z");

int index = ((ListOrderedSet<String>) listOrdered).indexOf("Y");  // 1
String byIndex = ((ListOrderedSet<String>) listOrdered).get(2);   // "Z"
```

### **2.8 Fixed Size Set**

```java
Set<String> set = new HashSet<>(Arrays.asList("A", "B", "C"));

// Create fixed-size set (can't add or remove)
Set<String> fixed = SetUtils.fixedSizeSet(set);

fixed.add("D");     // ❌ IllegalArgumentException! Set is fixed size
fixed.remove("A");  // ❌ IllegalArgumentException! Can't remove

// But can modify existing elements? Sets don't have "modify" operation
// For mutable objects inside set, they can be changed
```

### **2.9 Empty Set Utilities**

```java
import org.apache.commons.collections4.SetUtils;

// Null-safe empty check
Set<String> nullSet = null;
boolean empty1 = SetUtils.isEmpty(nullSet);      // true
boolean empty2 = SetUtils.isNotEmpty(nullSet);   // false

Set<String> emptySet = new HashSet<>();
boolean empty3 = SetUtils.isEmpty(emptySet);     // true

// Return empty set if null
Set<String> safeSet = SetUtils.emptyIfNull(possiblyNullSet);
// Never returns null - safe to iterate
```

### **2.10 Hash Set with Predictable Iteration**

```java
import org.apache.commons.collections4.set.PredicatedSet;

// HashSet with predictable iteration order (not really)
// For predictable iteration, use LinkedHashSet directly

// For sets that reject certain elements on addition
Set<Integer> rejectNegatives = SetUtils.predicatedSet(
    new HashSet<>(),
    i -> i >= 0
);
```

---

## **3. GOOGLE GUAVA SETS** 🎯

### **Maven Dependency**
```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>33.4.0-jre</version>
</dependency>
```

### **3.1 Set Creation Utilities**

```java
import com.google.common.collect.Sets;
import com.google.common.collect.ImmutableSet;

// Convenient set creation
Set<String> hashSet = Sets.newHashSet();
Set<String> linkedHashSet = Sets.newLinkedHashSet();
Set<String> treeSet = Sets.newTreeSet();

// With expected size (optimized)
Set<String> sized = Sets.newHashSetWithExpectedSize(100);

// From iterable/array
Set<String> fromArray = Sets.newHashSet("A", "B", "C");
Set<String> fromIterable = Sets.newHashSet(someIterable);

// Concurrent set (wrapped ConcurrentHashMap)
Set<String> concurrentSet = Sets.newConcurrentHashSet();

// CopyOnWriteArraySet
Set<String> cowSet = Sets.newCopyOnWriteArraySet();

// ImmutableSet (Guava style)
ImmutableSet<String> immutable = ImmutableSet.of("A", "B", "C");

// ImmutableSet builder
ImmutableSet<String> built = ImmutableSet.<String>builder()
    .add("X")
    .add("Y")
    .add("Z")
    .build();

// Immutable copy
ImmutableSet<String> copy = ImmutableSet.copyOf(existingSet);
```

### **3.2 Set Operations (Immutable Results)**

```java
Set<Integer> set1 = Sets.newHashSet(1, 2, 3, 4);
Set<Integer> set2 = Sets.newHashSet(3, 4, 5, 6);

// Union (returns new set)
Set<Integer> union = Sets.union(set1, set2);
// [1, 2, 3, 4, 5, 6] - returns view (changes reflect if sets change!)

// Intersection
Set<Integer> intersection = Sets.intersection(set1, set2);
// [3, 4] - returns view

// Difference
Set<Integer> difference = Sets.difference(set1, set2);
// [1, 2] - returns view (elements in set1 but not set2)

// Symmetric difference
Set<Integer> symDiff = Sets.symmetricDifference(set1, set2);
// [1, 2, 5, 6] - returns view

// Note: All return views that are live-updated!
set1.add(7);  // Now union includes 7 automatically

// To get immutable copy:
Set<Integer> immutableUnion = ImmutableSet.copyOf(Sets.union(set1, set2));
```

### **3.3 Filtering Sets**

```java
Set<Integer> numbers = Sets.newHashSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// Filter by predicate (returns view)
Set<Integer> evens = Sets.filter(numbers, n -> n % 2 == 0);
// [2, 4, 6, 8, 10] - live view!

// Filter by type (for heterogeneous sets)
Set<Object> mixed = Sets.newHashSet("A", 1, "B", 2);
Set<String> strings = Sets.filter(mixed, String.class);
// ["A", "B"] - only String elements

// Filtered view updates with original
numbers.add(12);  // Now evens includes 12
numbers.remove(4); // Now evens no longer has 4

// For immutable result
Set<Integer> evensCopy = ImmutableSet.copyOf(Sets.filter(numbers, n -> n % 2 == 0));
```

### **3.4 Transforming Sets**

```java
Set<String> words = Sets.newHashSet("hello", "world", "java");

// Transform each element (returns view)
Set<Integer> lengths = Sets.transform(words, String::length);
// [5, 5, 4] - live view!

// Transform with function
Set<String> upper = Sets.transform(words, String::toUpperCase);
// ["HELLO", "WORLD", "JAVA"]

// Note: Transform is lazy - function applied on each access
// Be careful with expensive transformations

// For immutable copy
Set<Integer> lengthsCopy = ImmutableSet.copyOf(
    Sets.transform(words, String::length)
);
```

### **3.5 Power Set**

```java
Set<String> set = Sets.newHashSet("A", "B", "C");

// Power set (set of all subsets)
Set<Set<String>> powerSet = Sets.powerSet(set);
// size = 2^3 = 8 subsets: {}, {A}, {B}, {C}, {A,B}, {A,C}, {B,C}, {A,B,C}

System.out.println("Power set size: " + powerSet.size());  // 8

// Iterate over all subsets
for (Set<String> subset : powerSet) {
    System.out.println(subset);
}

// Useful for algorithms requiring subset enumeration
// Returns set of sets - can be memory intensive for large sets!
// For set of size n, power set size is 2^n
```

### **3.6 Cartesian Product**

```java
Set<Integer> set1 = Sets.newHashSet(1, 2);
Set<String> set2 = Sets.newHashSet("A", "B");

// Cartesian product of multiple sets
Set<List<Object>> product = Sets.cartesianProduct(set1, set2);
// Returns sets of lists: [1, A], [1, B], [2, A], [2, B]

// With three sets
Set<Integer> set3 = Sets.newHashSet(10, 20);
Set<List<Object>> product3 = Sets.cartesianProduct(set1, set2, set3);
// 2 × 2 × 2 = 8 combinations

// For type-safe version
Set<List<?>> productAll = Sets.cartesianProduct(set1, set2, set3);
```

### **3.7 Combinations**

```java
Set<String> set = Sets.newHashSet("A", "B", "C", "D");

// All combinations of size k from set
Set<Set<String>> combinations2 = Sets.combinations(set, 2);
// All 2-element subsets: {A,B}, {A,C}, {A,D}, {B,C}, {B,D}, {C,D}

Set<Set<String>> combinations3 = Sets.combinations(set, 3);
// All 3-element subsets: {A,B,C}, {A,B,D}, {A,C,D}, {B,C,D}

// Useful for combinatorial algorithms
int size = Sets.combinations(set, 2).size();  // C(4,2) = 6
```

### **3.8 Differences Between Sets**

```java
Set<String> set1 = Sets.newHashSet("A", "B", "C");
Set<String> set2 = Sets.newHashSet("B", "C", "D", "E");

// Get detailed set difference
Sets.SetView<String> difference = Sets.difference(set1, set2);
// ["A"] - elements in set1 not in set2

// Get symmetric difference
Sets.SetView<String> symDiff = Sets.symmetricDifference(set1, set2);
// ["A", "D", "E"] - elements in either but not both

// Check subsets
boolean isSubset = set2.containsAll(set1);  // JDK way

// Guava way - not directly, but can use:
boolean isSubset = Sets.difference(set1, set2).isEmpty();  // true if set1 ⊆ set2
```

### **3.9 New HashSet with Elements**

```java
// More readable than Arrays.asList
Set<String> set = Sets.newHashSet("A", "B", "C", "D");

// With varargs
Set<Integer> numbers = Sets.newHashSet(1, 2, 3, 4, 5);

// From iterator
Iterator<String> iter = someIterator();
Set<String> fromIter = Sets.newHashSet(iter);
```

### **3.10 Immutable Set Utilities**

```java
// ImmutableSet features
ImmutableSet<String> set = ImmutableSet.of("A", "B", "C");

// Builder pattern for complex construction
ImmutableSet<String> built = ImmutableSet.<String>builder()
    .add("X")
    .addAll(otherSet)
    .add("Y")
    .build();

// Check if immutable
// built.add("Z");  // ❌ UnsupportedOperationException!

// Copy of existing collection (defensive copy)
ImmutableSet<String> copy = ImmutableSet.copyOf(mutableSet);

// Deduplication - automatically removes duplicates
ImmutableSet<String> deduped = ImmutableSet.copyOf(listWithDuplicates);
```

---

## **4. COMPARISON TABLE**

| Feature | JDK | Apache Commons | Guava |
|---------|-----|----------------|-------|
| **Union** | `addAll()` (modifies) | `SetUtils.union()` | `Sets.union()` (view) |
| **Intersection** | `retainAll()` (modifies) | `SetUtils.intersection()` | `Sets.intersection()` (view) |
| **Difference** | `removeAll()` (modifies) | `SetUtils.difference()` | `Sets.difference()` (view) |
| **Symmetric Difference** | Manual stream | `SetUtils.symmetricDifference()` | `Sets.symmetricDifference()` |
| **Filtering** | Stream API | `predicatedSet()` | `Sets.filter()` |
| **Transforming** | Stream API | `transformedSet()` | `Sets.transform()` (view) |
| **Power Set** | ❌ | ❌ | `Sets.powerSet()` |
| **Cartesian Product** | ❌ | ❌ | `Sets.cartesianProduct()` |
| **Combinations** | ❌ | ❌ | `Sets.combinations()` |
| **Predicated Sets** | ❌ | ✅ | ❌ |
| **Fixed Size** | ❌ | ✅ | ❌ |
| **Ordered Set** | `LinkedHashSet` | `OrderedSet` | ❌ (use `LinkedHashSet`) |
| **Immutable** | `Set.of()` (Java 9+) | ❌ | `ImmutableSet` |
| **Empty Check** | `isEmpty()` | `SetUtils.isEmpty()` | ❌ |
| **Subset Check** | `containsAll()` | `SetUtils.isSubSet()` | `difference().isEmpty()` |

---

## **5. PERFORMANCE CONSIDERATIONS**

```java
// JDK bulk operations modify the set
set1.addAll(set2);  // O(n) where n is size of set2
set1.retainAll(set2); // O(n) where n is size of set1

// Apache Commons returns new sets
Set<Integer> union = SetUtils.union(set1, set2);  // O(n) copies all

// Guava returns views (lightweight)
Set<Integer> unionView = Sets.union(set1, set2);  // O(1) no copying
Set<Integer> intersectionView = Sets.intersection(set1, set2); // O(1)

// But accessing elements from views may be O(log n) or O(n)
for (Integer i : unionView) {  // O(n) iteration over combined set
    // process
}

// Power set is huge! 2^n subsets
Set<String> set = Sets.newHashSet("A", "B", "C", "D", "E");
Set<Set<String>> powerSet = Sets.powerSet(set); // 32 subsets
// For n=20, that's over 1 million subsets!
```

---

## **🎯 WHEN TO USE WHICH UTILITY**

| Scenario | Recommended Utility |
|----------|---------------------|
| **Need set operations without modifying originals** | Apache Commons `SetUtils` or Guava `Sets` (views) |
| **Need to modify original set** | JDK `addAll()`/`retainAll()`/`removeAll()` |
| **Need to enumerate all subsets** | Guava `Sets.powerSet()` |
| **Need to generate all combinations** | Guava `Sets.combinations()` |
| **Need cartesian product** | Guava `Sets.cartesianProduct()` |
| **Need live updating set views** | Guava `Sets.union()`/`intersection()`/etc. |
| **Need immutable sets** | JDK 9+ `Set.of()` or Guava `ImmutableSet` |
| **Need validation on add** | Apache Commons `predicatedSet()` |
| **Need thread-safe set** | `ConcurrentHashMap.newKeySet()` or `Collections.synchronizedSet()` |
| **Need ordered set** | `LinkedHashSet` (JDK) or Apache `OrderedSet` |
| **Need to transform elements lazily** | Guava `Sets.transform()` |
| **Need to filter elements lazily** | Guava `Sets.filter()` |

---

## **🚀 QUICK CHEAT SHEET**

```java
// ========== JDK ==========
set1.addAll(set2);           // Union (modifies set1)
set1.retainAll(set2);        // Intersection (modifies set1)
set1.removeAll(set2);        // Difference (modifies set1)
set1.containsAll(set2);      // Subset check
Collections.unmodifiableSet(set);
Collections.synchronizedSet(set);
Collections.emptySet();
Collections.singleton("A");
Set.of("A", "B", "C");       // Java 9+ immutable
Set.copyOf(collection);      // Java 10+ immutable copy

// Java 21+
set.getFirst();
set.getLast();
set.reversed();

// ========== Apache Commons ==========
SetUtils.union(set1, set2);                 // New set union
SetUtils.intersection(set1, set2);          // New set intersection
SetUtils.difference(set1, set2);            // New set difference
SetUtils.symmetricDifference(set1, set2);   // New set symmetric diff
SetUtils.isSubSet(set1, set2);               // Subset check
SetUtils.isEqualSet(set1, set2);             // Equality check
SetUtils.isEmpty(set);                        // Null-safe empty check
SetUtils.predicatedSet(set, predicate);      // Validating set
SetUtils.fixedSizeSet(set);                   // Fixed-size set
SetUtils.typedSet(set, String.class);        // Type-safe set

// ========== Guava ==========
Sets.newHashSet("A", "B", "C");
Sets.newLinkedHashSet();
Sets.newTreeSet();
Sets.newConcurrentHashSet();
Sets.union(set1, set2);                       // View union
Sets.intersection(set1, set2);                 // View intersection
Sets.difference(set1, set2);                   // View difference
Sets.symmetricDifference(set1, set2);          // View symmetric diff
Sets.filter(set, predicate);                    // Filtered view
Sets.transform(set, function);                   // Transformed view
Sets.powerSet(set);                             // Power set (all subsets)
Sets.cartesianProduct(set1, set2);              // Cartesian product
Sets.combinations(set, k);                      // All k-element subsets
ImmutableSet.of("A", "B", "C");                  // Immutable set
```

---

## **📝 REAL-WORLD EXAMPLES**

### **Example 1: Permission Management**
```java
import com.google.common.collect.Sets;
import org.apache.commons.collections4.SetUtils;

enum Permission { READ, WRITE, EXECUTE, DELETE, ADMIN }

public class UserPermissions {
    private Set<Permission> userPerms = new HashSet<>();
    
    // Grant permissions
    public void grant(Permission... perms) {
        Set<Permission> toAdd = Sets.newHashSet(perms);
        userPerms.addAll(toAdd);
    }
    
    // Revoke permissions
    public void revoke(Permission... perms) {
        Set<Permission> toRemove = Sets.newHashSet(perms);
        userPerms.removeAll(toRemove);
    }
    
    // Check if has all required permissions
    public boolean hasAll(Set<Permission> required) {
        return userPerms.containsAll(required);
    }
    
    // Get permissions user has but shouldn't (over-permissioned)
    public Set<Permission> getExcessPermissions(Set<Permission> allowed) {
        return SetUtils.difference(userPerms, allowed);
    }
    
    // Get missing permissions
    public Set<Permission> getMissingPermissions(Set<Permission> required) {
        return SetUtils.difference(required, userPerms);
    }
    
    // Combine permissions from multiple roles
    public static Set<Permission> combine(Set<Permission>... rolePerms) {
        Set<Permission> combined = new HashSet<>();
        for (Set<Permission> perms : rolePerms) {
            combined.addAll(perms);
        }
        return combined;
    }
}
```

### **Example 2: Friend Recommendations**
```java
public class FriendRecommender {
    
    // Find mutual friends
    public Set<String> getMutualFriends(String user1, String user2) {
        Set<String> friends1 = getFriends(user1);
        Set<String> friends2 = getFriends(user2);
        
        return Sets.intersection(friends1, friends2);  // Live view
    }
    
    // Friend suggestions (friends of friends not already friends)
    public Set<String> getFriendSuggestions(String user) {
        Set<String> friends = getFriends(user);
        Set<String> friendsOfFriends = new HashSet<>();
        
        for (String friend : friends) {
            friendsOfFriends.addAll(getFriends(friend));
        }
        
        // Remove self and existing friends
        friendsOfFriends.remove(user);
        friendsOfFriends.removeAll(friends);
        
        return friendsOfFriends;
    }
    
    // People you might know (based on common friends)
    public Set<String> getPeopleYouMayKnow(String user, int minMutual) {
        Set<String> suggestions = new HashSet<>();
        Set<String> friends = getFriends(user);
        
        for (String potential : getAllUsers()) {
            if (potential.equals(user) || friends.contains(potential)) {
                continue;
            }
            
            Set<String> mutual = Sets.intersection(
                friends, getFriends(potential)
            );
            
            if (mutual.size() >= minMutual) {
                suggestions.add(potential);
            }
        }
        
        return suggestions;
    }
}
```

### **Example 3: Data Deduplication**
```java
public class DataCleaner {
    
    // Remove duplicates from list
    public <T> List<T> deduplicate(List<T> list) {
        // Preserve order with LinkedHashSet
        Set<T> unique = new LinkedHashSet<>(list);
        return new ArrayList<>(unique);
    }
    
    // Find duplicates across multiple lists
    public <T> Set<T> findDuplicates(List<T>... lists) {
        if (lists.length == 0) return Collections.emptySet();
        
        Set<T> all = new HashSet<>(lists[0]);
        Set<T> duplicates = new HashSet<>();
        
        for (int i = 1; i < lists.length; i++) {
            for (T item : lists[i]) {
                if (!all.add(item)) {
                    duplicates.add(item);
                }
            }
        }
        
        return duplicates;
    }
    
    // Find unique elements across sets
    public <T> Set<T> findUniqueAcross(Set<T>... sets) {
        if (sets.length == 0) return Collections.emptySet();
        
        // Elements that appear in exactly one set
        Set<T> result = new HashSet<>();
        Multiset<T> counts = HashMultiset.create();
        
        for (Set<T> set : sets) {
            counts.addAll(set);
        }
        
        for (T element : counts.elementSet()) {
            if (counts.count(element) == 1) {
                result.add(element);
            }
        }
        
        return result;
    }
}
```

---

*Happy Coding with Sets! 🎉*