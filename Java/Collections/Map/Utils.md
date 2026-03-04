# Complete Map Utility Classes Guide 🛠️

*A comprehensive guide to all utility methods for working with Maps in Java (JDK, Apache Commons, and Guava)*

---

## **📋 OVERVIEW**

Java provides several utility classes for Map operations across different libraries:

| Library | Utility Class | Key Features |
|---------|---------------|--------------|
| **JDK** | `Map` interface methods | `getOrDefault()`, `computeIfAbsent()`, `merge()` |
| **JDK** | `Collections` class | `synchronizedMap()`, `unmodifiableMap()` |
| **JDK 21+** | `SequencedMap` interface | `firstEntry()`, `lastEntry()`, `reversed()` |
| **Apache Commons** | `MapUtils` | Null-safe operations, type-safe getters, decorators |
| **Google Guava** | `Maps` class | `difference()`, `filter*()`, `transform*()`, utility creators |

---

## **1. JDK MAP UTILITIES (Standard Library)** ☕

### **1.1 Map Interface Default Methods (Java 8+)**

```java
Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
map.put("B", 2);

// getOrDefault - Return default if key missing
int value = map.getOrDefault("C", 0);  // Returns 0, not null

// putIfAbsent - Add only if key not present
map.putIfAbsent("A", 100);  // Won't change, "A" already exists
map.putIfAbsent("C", 3);     // Adds C=3

// computeIfAbsent - Compute value only if key missing
map.computeIfAbsent("D", k -> k.length() * 10);  // D=10
map.computeIfAbsent("A", k -> 999);  // Won't compute, key exists

// computeIfPresent - Update value only if key exists
map.computeIfPresent("A", (k, v) -> v * 10);  // A=10

// compute - Always compute (may remove if result null)
map.compute("E", (k, v) -> v == null ? 1 : v + 1);  // E=1

// merge - Combine existing value with new value
map.merge("A", 5, Integer::sum);  // A=15 (10 + 5)
map.merge("F", 10, Integer::sum); // F=10 (key absent, uses 10)

// forEach - Easy iteration
map.forEach((k, v) -> System.out.println(k + "=" + v));

// replaceAll - Transform all values
map.replaceAll((k, v) -> v * 2);

// remove(key, value) - Remove only if key maps to specified value
boolean removed = map.remove("A", 15);  // true if removed

// getOrDefault vs computeIfAbsent
map.getOrDefault(key, defaultValue);    // Returns default, doesn't store it
map.computeIfAbsent(key, k -> value);   // Computes and STORES if absent
```

### **1.2 Collections Utility Class**

```java
import java.util.Collections;

// Synchronized wrappers (thread-safe)
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());

// Must synchronize on iteration!
synchronized(syncMap) {
    for (Map.Entry<String, String> entry : syncMap.entrySet()) {
        // process
    }
}

// Unmodifiable wrappers (read-only)
Map<String, String> unmodMap = Collections.unmodifiableMap(originalMap);
// unmodMap.put("X", "Y");  // ❌ UnsupportedOperationException!

// Empty map (immutable)
Map<String, String> empty = Collections.emptyMap();

// Singleton map (immutable, single entry)
Map<String, String> single = Collections.singletonMap("key", "value");

// Checked map (type-safe)
Map<String, Date> checked = Collections.checkedMap(
    new HashMap<>(), String.class, Date.class
);

// New map from properties
Map<String, String> props = Collections.list(properties.propertyNames())
    .stream()
    .collect(Collectors.toMap(
        key -> (String) key,
        key -> properties.getProperty((String) key)
    ));
```

### **1.3 SequencedMap (Java 21+)**

```java
// Java 21+ - For maps with encounter order (LinkedHashMap, TreeMap, etc.)
LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
map.put("A", 1);
map.put("B", 2);
map.put("C", 3);

// New sequenced methods
Map.Entry<String, Integer> first = map.firstEntry();    // A=1
Map.Entry<String, Integer> last = map.lastEntry();      // C=3
map.removeFirstEntry();  // Removes and returns first entry
map.removeLastEntry();   // Removes and returns last entry
map.putFirst("Z", 26);   // Inserts at beginning
map.putLast("D", 4);     // Inserts at end (same as put)

// Reversed view
SequencedMap<String, Integer> reversed = map.reversed();

// Sequenced key set
SequencedSet<String> keySet = map.sequencedKeySet();
String firstKey = keySet.getFirst();
String lastKey = keySet.getLast();

// Sequenced values
SequencedCollection<Integer> values = map.sequencedValues();

// SortedMap and LinkedHashMap both implement SequencedMap
SortedMap<String, Integer> sortedMap = new TreeMap<>();
sortedMap.firstEntry();  // Available in Java 21+
```

### **1.4 Properties - Special Map for Configurations**

```java
Properties props = new Properties();

// Load from file
try (FileInputStream fis = new FileInputStream("config.properties")) {
    props.load(fis);
}

// Get with defaults
String url = props.getProperty("db.url", "jdbc:default://localhost");
int timeout = Integer.parseInt(props.getProperty("timeout", "30"));

// Store
props.setProperty("app.name", "MyApp");
props.store(new FileOutputStream("app.properties"), "App Config");

// Convert to regular map
Map<String, String> map = new HashMap<>();
for (String name : props.stringPropertyNames()) {
    map.put(name, props.getProperty(name));
}
```

---

## **2. APACHE COMMONS MAPUTILS** 🐘

### **Maven Dependency**
```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.5.0-M2</version>
</dependency>
```

### **2.1 Null-Safe Operations**

```java
import org.apache.commons.collections4.MapUtils;

Map<String, Integer> map = null;  // Even null map is safe!

// Null-safe checks
boolean empty = MapUtils.isEmpty(map);        // true
boolean notEmpty = MapUtils.isNotEmpty(map);  // false

// Null-safe get with default
Integer val = MapUtils.getInteger(map, "key", 0);  // Returns 0 safely

// Type-safe getters (with defaults)
String str = MapUtils.getString(map, "name", "default");
Boolean bool = MapUtils.getBoolean(map, "active", false);
Long longVal = MapUtils.getLong(map, "count", 0L);
Double doubleVal = MapUtils.getDouble(map, "price", 0.0);

// Even with null map
String safe = MapUtils.getString(null, "any", "default");  // "default"
```

### **2.2 Creating Maps**

```java
// From two-dimensional array
String[][] colorArray = {
    {"RED", "#FF0000"},
    {"GREEN", "#00FF00"},
    {"BLUE", "#0000FF"}
};
Map<String, String> colorMap = MapUtils.putAll(
    new HashMap<>(), colorArray
);

// From one-dimensional array (alternating keys and values)
String[] flatArray = {"RED", "#FF0000", "GREEN", "#00FF00", "BLUE", "#0000FF"};
Map<String, String> flatMap = MapUtils.putAll(
    new HashMap<>(), flatArray
);

// Empty map if null (useful for avoiding null checks)
Map<String, String> safeMap = MapUtils.emptyIfNull(possiblyNullMap);
```

### **2.3 Printing Maps**

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Alice", 95);
scores.put("Bob", 87);
scores.put("Charlie", 92);

// Pretty print with label
MapUtils.verbosePrint(System.out, "Scores", scores);
// Output:
// Scores = 
// {
//     Alice = 95
//     Bob = 87
//     Charlie = 92
// }

// Debug print (includes data types)
MapUtils.debugPrint(System.out, "Debug", scores);
// Output includes type information
```

### **2.4 Map Inversion**

```java
Map<String, String> colors = new HashMap<>();
colors.put("RED", "#FF0000");
colors.put("GREEN", "#00FF00");
colors.put("BLUE", "#0000FF");

// Swap keys and values
Map<String, String> inverted = MapUtils.invertMap(colors);
// Result: {"#FF0000"="RED", "#00FF00"="GREEN", "#0000FF"="BLUE"}

// Note: If multiple keys have same value, one wins arbitrarily
```

### **2.5 Predicated Maps (Validation)**

```java
import org.apache.commons.collections4.PredicateUtils;

Map<String, String> map = new HashMap<>();

// Ensure all keys are non-null and values are unique
Map<String, String> predicated = MapUtils.predicatedMap(
    map,
    PredicateUtils.notNullPredicate(),           // Keys not null
    PredicateUtils.uniquePredicate()             // Values unique
);

predicated.put("A", "X");  // OK
predicated.put("B", "X");  // ❌ IllegalArgumentException! Duplicate value
predicated.put(null, "Z"); // ❌ IllegalArgumentException! Null key

// Custom predicate
Map<String, Integer> rangedMap = MapUtils.predicatedMap(
    new HashMap<>(),
    key -> key != null && key.length() >= 2,
    value -> value != null && value > 0 && value < 100
);
```

### **2.6 Fixed-Size Map**

```java
Map<String, String> fixed = MapUtils.fixedSizeMap(new HashMap<>());
fixed.put("A", "1");  // OK
fixed.put("B", "2");  // OK

// Cannot add or remove
fixed.put("C", "3");  // ❌ IllegalArgumentException! Map is fixed size
fixed.remove("A");    // ❌ IllegalArgumentException! Can't remove

// But can change existing values
fixed.put("A", "100"); // ✅ OK - modify, not add
```

### **2.7 Lazy Map**

```java
import org.apache.commons.collections4.TransformerUtils;

// Values created on demand when accessed
Map<Integer, String> lazy = MapUtils.lazyMap(
    new HashMap<>(),
    TransformerUtils.stringValueTransformer()  // Converts key to string
);

// Map is empty initially
System.out.println(lazy.size());  // 0

// Access triggers value creation
String val = lazy.get(42);  // Creates and stores "42"
System.out.println(lazy);    // {42=42}

// Multiple accesses use cached value
lazy.get(42);  // Returns existing "42", doesn't recreate

// Custom transformer
Map<String, List<String>> listMap = MapUtils.lazyMap(
    new HashMap<>(),
    key -> new ArrayList<>()
);

listMap.get("users").add("Alice");  // List created automatically
listMap.get("users").add("Bob");
System.out.println(listMap);  // {users=[Alice, Bob]}
```

### **2.8 Ordered Map**

```java
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.map.ListOrderedMap;

OrderedMap<String, Integer> ordered = MapUtils.orderedMap(new HashMap<>());
ordered.put("B", 2);
ordered.put("A", 1);
ordered.put("C", 3);

// Access in insertion order
String firstKey = ordered.firstKey();      // "B"
String nextKey = ordered.nextKey("B");     // "A"
String prevKey = ordered.previousKey("C"); // "A"
String lastKey = ordered.lastKey();        // "C"

// Alternative: ListOrderedMap
OrderedMap<String, Integer> listOrdered = ListOrderedMap.listOrderedMap(new HashMap<>());
```

### **2.9 MultiValueMap**

```java
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap;

// Map with multiple values per key
MultiValuedMap<String, String> multiMap = new ArrayListValuedHashMap<>();
multiMap.put("colors", "red");
multiMap.put("colors", "blue");
multiMap.put("colors", "green");

Collection<String> colors = multiMap.get("colors");  // [red, blue, green]

// Using MapUtils to create
MultiValuedMap<String, Integer> scores = new ArrayListValuedHashMap<>();
scores.put("Alice", 95);
scores.put("Alice", 87);  // Multiple scores per person
```

### **2.10 Safe Add to Map**

```java
Map<String, String> map = new HashMap<>();

// Prevents adding null values
MapUtils.safeAddToMap(map, "key", "value");  // OK
MapUtils.safeAddToMap(map, "key2", null);    // Won't add (ignored)
// No exception thrown - just doesn't add
```

---

## **3. GOOGLE GUAVA MAPS** 🎯

### **Maven Dependency**
```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>33.4.0-jre</version>
</dependency>
```

### **3.1 Map Creation Utilities**

```java
import com.google.common.collect.Maps;
import com.google.common.collect.ImmutableMap;

// Convenient map creation
Map<String, Integer> map1 = Maps.newHashMap();
Map<String, Integer> map2 = Maps.newLinkedHashMap();
Map<String, Integer> map3 = Maps.newTreeMap();

// With expected size (optimized)
Map<String, Integer> sized = Maps.newHashMapWithExpectedSize(100);

// Concurrent map
ConcurrentMap<String, Integer> concurrent = Maps.newConcurrentMap();

// EnumMap
EnumMap<DayOfWeek, String> enumMap = Maps.newEnumMap(DayOfWeek.class);

// IdentityHashMap
IdentityHashMap<String, Integer> identityMap = Maps.newIdentityHashMap();

// ImmutableMap (Guava style)
ImmutableMap<String, Integer> immutable = ImmutableMap.of(
    "A", 1,
    "B", 2,
    "C", 3
);

// ImmutableMap builder
ImmutableMap<String, Integer> built = ImmutableMap.<String, Integer>builder()
    .put("X", 100)
    .put("Y", 200)
    .put("Z", 300)
    .build();
```

### **3.2 Map Differences**

```java
Map<String, Integer> left = Maps.newHashMap();
left.put("A", 1);
left.put("B", 2);
left.put("C", 3);

Map<String, Integer> right = Maps.newHashMap();
right.put("A", 1);
right.put("B", 22);
right.put("D", 4);

// Compute difference between two maps
MapDifference<String, Integer> diff = Maps.difference(left, right);

// Entries only in left
Map<String, Integer> onlyLeft = diff.entriesOnlyOnLeft();  // {C=3}

// Entries only in right
Map<String, Integer> onlyRight = diff.entriesOnlyOnRight(); // {D=4}

// Entries in common (same key and value)
Map<String, Integer> inCommon = diff.entriesInCommon();  // {A=1}

// Entries with same key but different values
Map<String, MapDifference.ValueDifference<Integer>> differing = diff.entriesDiffering();
// {B=(2, 22)}

// Check if equal
boolean equal = diff.areEqual();  // false

// With custom equivalence
MapDifference<String, Integer> diffWithEq = Maps.difference(
    left, right, 
    (v1, v2) -> Math.abs(v1 - v2) < 5  // Values considered equal if within 5
);
```

### **3.3 Filtering Maps**

```java
Map<String, Integer> scores = Maps.newHashMap();
scores.put("Alice", 95);
scores.put("Bob", 87);
scores.put("Charlie", 92);
scores.put("David", 78);

// Filter by keys
Map<String, Integer> filteredKeys = Maps.filterKeys(
    scores,
    key -> key.startsWith("A") || key.startsWith("C")
);  // {Alice=95, Charlie=92}

// Filter by values
Map<String, Integer> filteredValues = Maps.filterValues(
    scores,
    value -> value >= 90
);  // {Alice=95, Charlie=92}

// Filter by entries
Map<String, Integer> filteredEntries = Maps.filterEntries(
    scores,
    entry -> entry.getKey().length() > 4 && entry.getValue() > 80
);  // {Alice=95, Charlie=92}

// Note: Returns live views - changes to original reflect
scores.put("Alice", 100);  // Updates filtered views too!
```

### **3.4 Transforming Maps**

```java
Map<String, Integer> original = Maps.newHashMap();
original.put("A", 1);
original.put("B", 2);
original.put("C", 3);

// Transform values
Map<String, String> transformed = Maps.transformValues(
    original,
    value -> "Value: " + value
);  // {A="Value: 1", B="Value: 2", C="Value: 3"}

// Transform entries (key + value)
Map<String, String> entryTransformed = Maps.transformEntries(
    original,
    (key, value) -> key + "=" + value
);  // {A="A=1", B="B=2", C="C=3"}

// Views - transformations applied on-the-fly
original.put("D", 4);  // Reflected in transformed maps!

// To get independent copy
Map<String, String> copy = Maps.newHashMap(transformed);
```

### **3.5 Unique Index (Inverse Map)**

```java
List<String> strings = Arrays.asList("apple", "banana", "cherry");

// Create map using function to generate keys
ImmutableMap<Integer, String> indexed = Maps.uniqueIndex(
    strings,
    String::length
);  // {5="apple", 6="banana", 6="cherry"}? Wait, duplicate key!

// Throws IllegalArgumentException on duplicate keys
// Solution: Ensure keys are unique
Set<String> uniqueSet = ImmutableSet.of("apple", "banana", "grape");
ImmutableMap<Integer, String> safeIndex = Maps.uniqueIndex(
    uniqueSet,
    String::length
);  // {5="apple", 6="grape"} (banana removed, last wins)
```

### **3.6 As Map (View of Set)**

```java
Set<String> keys = ImmutableSet.of("A", "B", "C");

// Create map where values are computed on demand
Map<String, Integer> asMap = Maps.asMap(
    keys,
    key -> key.hashCode()
);  // Values computed lazily when accessed

System.out.println(asMap.get("A"));  // Computes and returns hash

// For sorted sets
SortedSet<String> sortedKeys = new TreeSet<>(keys);
SortedMap<String, Integer> asSortedMap = Maps.asMap(
    sortedKeys,
    key -> key.length()
);
```

### **3.7 Immutable Map Utilities**

```java
// From Properties
Properties props = new Properties();
props.setProperty("host", "localhost");
ImmutableMap<String, String> fromProps = Maps.fromProperties(props);

// Immutable enum map
Map<DayOfWeek, String> enumMap = Maps.newEnumMap(DayOfWeek.class);
enumMap.put(DayOfWeek.MONDAY, "Work");
ImmutableMap<DayOfWeek, String> immutableEnum = Maps.immutableEnumMap(enumMap);
```

### **3.8 Submap with Range**

```java
NavigableMap<Integer, String> navMap = new TreeMap<>();
navMap.put(1, "One");
navMap.put(5, "Five");
navMap.put(10, "Ten");
navMap.put(15, "Fifteen");
navMap.put(20, "Twenty");

import com.google.common.collect.Range;

// Get view of map for keys in range
NavigableMap<Integer, String> subRange = Maps.subMap(
    navMap,
    Range.closed(5, 15)  // Inclusive range [5, 15]
);  // {5="Five", 10="Ten", 15="Fifteen"}

// Different range types
Range.open(5, 15);      // (5, 15) exclusive
Range.atLeast(10);       // [10, ∞)
Range.atMost(10);        // (-∞, 10]
Range.greaterThan(5);    // (5, ∞)
Range.lessThan(15);      // (-∞, 15)
```

### **3.9 BiMap - Bidirectional Map**

```java
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

BiMap<String, Integer> biMap = HashBiMap.create();
biMap.put("A", 1);
biMap.put("B", 2);
biMap.put("C", 3);

// Get by key
Integer val = biMap.get("A");  // 1

// Get by value (inverse)
String key = biMap.inverse().get(2);  // "B"

// BiMap ensures values are unique
biMap.put("D", 3);  // ❌ IllegalArgumentException! Value 3 already mapped

// Force put (removes existing mapping)
biMap.forcePut("D", 3);  // Removes C=3, adds D=3

// Inverse view
BiMap<Integer, String> inverse = biMap.inverse();
inverse.get(1);  // "A"

// Synchronized version
BiMap<String, Integer> syncBiMap = Maps.synchronizedBiMap(biMap);
```

---

## **4. JAVA 8+ STREAM UTILITIES** 🌊

### **4.1 Collecting to Map**

```java
import java.util.stream.Collectors;

List<Person> people = getPeople();

// Simple map (key = id, value = person)
Map<Integer, Person> byId = people.stream()
    .collect(Collectors.toMap(
        Person::getId,      // Key mapper
        Function.identity() // Value mapper
    ));  // Throws exception if duplicate keys

// With merge function for duplicates
Map<String, Integer> nameToAge = people.stream()
    .collect(Collectors.toMap(
        Person::getName,
        Person::getAge,
        (age1, age2) -> age1  // Keep first if duplicate
    ));

// Specify map type
Map<Integer, Person> treeMap = people.stream()
    .collect(Collectors.toMap(
        Person::getId,
        Function.identity(),
        (a, b) -> a,          // Merge function
        TreeMap::new           // Map supplier
    ));

// Grouping by
Map<String, List<Person>> byCity = people.stream()
    .collect(Collectors.groupingBy(Person::getCity));

// Grouping with downstream collector
Map<String, Double> avgAgeByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.averagingInt(Person::getAge)
    ));

// Partitioning
Map<Boolean, List<Person>> adults = people.stream()
    .collect(Collectors.partitioningBy(p -> p.getAge() >= 18));
```

### **4.2 Flat Mapping Maps**

```java
Map<String, List<Integer>> mapOfLists = new HashMap<>();
mapOfLists.put("A", Arrays.asList(1, 2, 3));
mapOfLists.put("B", Arrays.asList(4, 5, 6));

// Flatten to pairs
List<String> pairs = mapOfLists.entrySet().stream()
    .flatMap(entry -> entry.getValue().stream()
        .map(value -> entry.getKey() + ":" + value))
    .collect(Collectors.toList());  // ["A:1", "A:2", "A:3", "B:4", "B:5", "B:6"]
```

---

## **5. PERFORMANCE COMPARISON**

| Operation | JDK (Java 8+) | Apache Commons | Guava |
|-----------|---------------|----------------|-------|
| **Null-safe get** | `getOrDefault()` | `MapUtils.get*()` | ❌ |
| **Default value** | ✅ | ✅ | ✅ |
| **Type-safe getters** | ❌ | ✅ | ❌ |
| **Map difference** | ❌ | ❌ | ✅ |
| **Filtering** | Stream API | ✅ (predicated) | ✅ |
| **Transforming** | Stream API | ❌ | ✅ |
| **Bi-directional** | ❌ | ❌ | ✅ |
| **Lazy values** | `computeIfAbsent()` | `lazyMap()` | ❌ |
| **Multi-value map** | `Map<K, List<V>>` | `MultiValuedMap` | `Multimap` |
| **Thread-safe** | `ConcurrentHashMap` | Decorators | Decorators |

---

## **🎯 WHEN TO USE WHICH UTILITY**

| Scenario | Recommended Utility |
|----------|---------------------|
| **Need null-safe operations** | Apache Commons `MapUtils.get*()` |
| **Need map comparison/diff** | Guava `Maps.difference()` |
| **Need bidirectional lookup** | Guava `BiMap` |
| **Need multiple values per key** | Guava `Multimap` or Apache `MultiValuedMap` |
| **Need lazy initialization** | JDK `computeIfAbsent()` or Apache `lazyMap()` |
| **Need value transformation views** | Guava `Maps.transformValues()` |
| **Need filtering views** | Guava `Maps.filter*()` |
| **Need immutable maps** | JDK 9+ `Map.of()` or Guava `ImmutableMap` |
| **Need ordered iteration** | JDK `LinkedHashMap` or Apache `OrderedMap` |
| **Need thread-safe map** | `ConcurrentHashMap` (prefer over synchronized wrappers) |
| **Need validation on put** | Apache `predicatedMap()` |

---

## **🚀 QUICK CHEAT SHEET**

```java
// ========== JDK ==========
map.getOrDefault(key, defaultValue);
map.computeIfAbsent(key, k -> value);
map.merge(key, value, Integer::sum);
Collections.synchronizedMap(map);
Collections.unmodifiableMap(map);
Map.of("A", 1, "B", 2);  // Java 9+

// Java 21+
map.firstEntry();
map.lastEntry();
map.sequencedKeySet();

// ========== Apache Commons ==========
MapUtils.getInteger(map, key, 0);
MapUtils.isEmpty(map);
MapUtils.verbosePrint(System.out, "Label", map);
MapUtils.invertMap(map);
MapUtils.fixedSizeMap(map);
MapUtils.lazyMap(map, transformer);
MapUtils.predicatedMap(map, keyPred, valPred);

// ========== Guava ==========
Maps.newHashMapWithExpectedSize(100);
Maps.difference(map1, map2);
Maps.filterKeys(map, keyPredicate);
Maps.transformValues(map, function);
Maps.uniqueIndex(collection, function);
Maps.asMap(set, function);
HashBiMap.create();  // Bidirectional
ImmutableMap.of("A", 1, "B", 2);
```

---

*Happy Coding with Maps! 🎉*