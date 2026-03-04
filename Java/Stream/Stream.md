# **Complete Java Streams API - The Ultimate Interview Guide** 🌊

*Your comprehensive go-to reference for all Java Streams concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What are Streams?](#1-what-are-streams)
2. [Why Streams?](#2-why-streams)
3. [Stream Pipeline](#3-stream-pipeline)
4. [Creating Streams](#4-creating-streams)
5. [Intermediate Operations](#5-intermediate-operations)
6. [Terminal Operations](#6-terminal-operations)
7. [Short-circuiting Operations](#7-short-circuiting-operations)
8. [Primitive Streams](#8-primitive-streams)
9. [Optional with Streams](#9-optional-with-streams)
10. [Collectors](#10-collectors)
11. [Parallel Streams](#11-parallel-streams)
12. [Stream vs Collections](#12-stream-vs-collections)
13. [Common Stream Patterns](#13-common-stream-patterns)
14. [Stream Pitfalls](#14-stream-pitfalls)
15. [Interview Questions](#15-interview-questions)
16. [Quick Reference Cheat Sheet](#16-quick-reference-cheat-sheet)

---

## **1. WHAT ARE STREAMS?**

> **Concept:** Streams are sequences of elements that support functional-style operations for processing collections declaratively.

```java
// Before Streams (imperative)
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David");
List<String> filtered = new ArrayList<>();
for (String name : names) {
    if (name.startsWith("A")) {
        filtered.add(name.toUpperCase());
    }
}
Collections.sort(filtered);

// With Streams (declarative)
List<String> result = names.stream()
    .filter(name -> name.startsWith("A"))
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.toList());
```

---

## **2. WHY STREAMS?**

| Benefit | Explanation | Example |
|---------|-------------|---------|
| **Declarative** | Focus on what, not how | `filter(predicate)` vs manual loops |
| **Composable** | Chain operations together | `stream.filter().map().reduce()` |
| **Parallelizable** | Easy parallel processing | `parallelStream()` |
| **Lazy Evaluation** | Compute only when needed | Intermediate ops are lazy |
| **Less Boilerplate** | Concise, readable code | One line vs many loops |

---

## **3. STREAM PIPELINE**

> **Concept:** A stream pipeline consists of a source, zero or more intermediate operations, and a terminal operation.

```
Source → Intermediate Op(s) → Terminal Operation
         (lazy)              (eager)
```

```java
// Stream pipeline anatomy
List<String> result = list.stream()          // Source: collection
    .filter(s -> s.length() > 3)             // Intermediate: lazy
    .map(String::toUpperCase)                 // Intermediate: lazy
    .sorted()                                  // Intermediate: lazy
    .collect(Collectors.toList());             // Terminal: eager (executes pipeline)

// Nothing happens until terminal op is called
Stream<String> stream = list.stream()
    .filter(s -> {
        System.out.println("Filtering: " + s);
        return s.length() > 3;
    });  // No output yet!

stream.collect(Collectors.toList());  // Now operations execute
```

---

## **4. CREATING STREAMS**

> **Concept:** Streams can be created from various sources.

### **4.1 From Collections**

```java
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream1 = list.stream();                // Sequential
Stream<String> stream2 = list.parallelStream();        // Parallel

Set<String> set = new HashSet<>(list);
Stream<String> stream3 = set.stream();

Map<String, Integer> map = new HashMap<>();
Stream<Map.Entry<String, Integer>> stream4 = map.entrySet().stream();
Stream<String> stream5 = map.keySet().stream();
Stream<Integer> stream6 = map.values().stream();
```

### **4.2 From Arrays**

```java
String[] array = {"a", "b", "c"};

// Using Arrays.stream()
Stream<String> stream1 = Arrays.stream(array);
Stream<String> stream2 = Arrays.stream(array, 1, 3);  // "b", "c"

// Using Stream.of()
Stream<String> stream3 = Stream.of("a", "b", "c");
Stream<String> stream4 = Stream.of(array);
Stream<Integer> stream5 = Stream.of(1, 2, 3, 4, 5);
```

### **4.3 From Values**

```java
Stream<String> stream = Stream.of("a", "b", "c");
Stream<Integer> intStream = Stream.of(1, 2, 3, 4, 5);
Stream<Double> empty = Stream.empty();
```

### **4.4 From Functions (Infinite Streams)**

```java
// iterate - seed + function
Stream<Integer> infinite1 = Stream.iterate(0, n -> n + 2);
List<Integer> evens = infinite1.limit(10).collect(Collectors.toList());  // [0,2,4,6,8,10,12,14,16,18]

// iterate with predicate (Java 9+)
Stream<Integer> finite = Stream.iterate(0, n -> n < 100, n -> n + 10);

// generate - supplier
Stream<Double> randoms = Stream.generate(Math::random);
List<Double> fiveRandoms = randoms.limit(5).collect(Collectors.toList());

Stream<String> constant = Stream.generate(() -> "Echo");
List<String> echoes = constant.limit(3).collect(Collectors.toList());  // ["Echo","Echo","Echo"]
```

### **4.5 From Files (Java 8+)**

```java
// Read lines from file
try (Stream<String> lines = Files.lines(Paths.get("file.txt"))) {
    lines.filter(line -> line.contains("ERROR"))
         .forEach(System.out::println);
} catch (IOException e) {
    e.printStackTrace();
}

// Walk file tree
try (Stream<Path> paths = Files.walk(Paths.get("/home"))) {
    paths.filter(Files::isRegularFile)
         .forEach(System.out::println);
}
```

### **4.6 From Random Numbers**

```java
Random random = new Random();
IntStream ints = random.ints(5, 1, 100);  // 5 random ints between 1-100
ints.forEach(System.out::println);

DoubleStream doubles = random.doubles(3);  // 3 random doubles
```

### **4.7 From String**

```java
String str = "Hello";
IntStream chars = str.chars();  // Stream of char ASCII values
chars.forEach(c -> System.out.print((char) c));

// Split pattern
Stream<String> words = Pattern.compile(" ").splitAsStream("Hello World Java");
```

### **4.8 Builder Pattern**

```java
Stream<String> stream = Stream.<String>builder()
    .add("a")
    .add("b")
    .add("c")
    .build();
```

---

## **5. INTERMEDIATE OPERATIONS**

> **Concept:** Operations that transform a stream into another stream. They are lazy (not executed until terminal op).

### **5.1 filter()**

> **Concept:** Returns stream with elements matching given predicate.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> evens = numbers.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());  // [2,4,6,8,10]

List<String> words = Arrays.asList("cat", "dog", "elephant", "tiger");
List<String> longWords = words.stream()
    .filter(w -> w.length() > 3)
    .collect(Collectors.toList());  // ["elephant", "tiger"]

// Multiple filters
List<Integer> result = numbers.stream()
    .filter(n -> n > 3)
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());  // [4,6,8,10]
```

### **5.2 map()**

> **Concept:** Transforms each element using given function.

```java
List<String> words = Arrays.asList("hello", "world", "java");

List<Integer> lengths = words.stream()
    .map(String::length)
    .collect(Collectors.toList());  // [5,5,4]

List<String> upper = words.stream()
    .map(String::toUpperCase)
    .collect(Collectors.toList());  // ["HELLO","WORLD","JAVA"]

List<String> prefixed = words.stream()
    .map(s -> "Word: " + s)
    .collect(Collectors.toList());

// Object transformation
List<Person> people = getPeople();
List<String> names = people.stream()
    .map(Person::getName)
    .collect(Collectors.toList());
```

### **5.3 flatMap()**

> **Concept:** Flattens nested structures. One-to-many mapping.

```java
// Flatten list of lists
List<List<Integer>> listOfLists = Arrays.asList(
    Arrays.asList(1, 2, 3),
    Arrays.asList(4, 5, 6),
    Arrays.asList(7, 8, 9)
);

List<Integer> flat = listOfLists.stream()
    .flatMap(List::stream)
    .collect(Collectors.toList());  // [1,2,3,4,5,6,7,8,9]

// Flatten arrays
String[] words = {"Hello", "World"};
Stream<String> letters = Arrays.stream(words)
    .flatMap(word -> Arrays.stream(word.split("")));
// ["H","e","l","l","o","W","o","r","l","d"]

// Multiple levels
List<String> sentences = Arrays.asList(
    "Java is great",
    "Streams are powerful"
);

List<String> words2 = sentences.stream()
    .flatMap(sentence -> Arrays.stream(sentence.split(" ")))
    .collect(Collectors.toList());  // ["Java","is","great","Streams","are","powerful"]

// Remove duplicates from multiple lists
List<List<String>> names = Arrays.asList(
    Arrays.asList("Alice", "Bob"),
    Arrays.asList("Bob", "Charlie"),
    Arrays.asList("Charlie", "David")
);

List<String> unique = names.stream()
    .flatMap(List::stream)
    .distinct()
    .collect(Collectors.toList());  // ["Alice","Bob","Charlie","David"]
```

### **5.4 mapMulti() (Java 16+)**

> **Concept:** More efficient alternative to flatMap for certain cases.

```java
// Replace each element with multiple elements
List<Integer> numbers = Arrays.asList(1, 2, 3);

List<Integer> expanded = numbers.stream()
    .mapMulti((num, consumer) -> {
        for (int i = 0; i < num; i++) {
            consumer.accept(i);
        }
    })
    .collect(Collectors.toList());  // [0,0,1,0,1,2]

// Alternative to flatMap with less overhead
List<String> result = words.stream()
    .mapMulti((word, consumer) -> {
        for (char c : word.toCharArray()) {
            consumer.accept(String.valueOf(c));
        }
    })
    .collect(Collectors.toList());
```

### **5.5 distinct()**

> **Concept:** Removes duplicates (uses equals()).

```java
List<Integer> numbers = Arrays.asList(1, 2, 2, 3, 3, 3, 4, 4, 4, 4);

List<Integer> unique = numbers.stream()
    .distinct()
    .collect(Collectors.toList());  // [1,2,3,4]

List<String> words = Arrays.asList("cat", "dog", "cat", "bird");
List<String> uniqueWords = words.stream()
    .distinct()
    .collect(Collectors.toList());  // ["cat","dog","bird"]
```

### **5.6 sorted()**

> **Concept:** Sorts elements (natural order or custom comparator).

```java
List<Integer> numbers = Arrays.asList(5, 2, 8, 1, 9, 3);

// Natural order
List<Integer> sorted = numbers.stream()
    .sorted()
    .collect(Collectors.toList());  // [1,2,3,5,8,9]

// Reverse order
List<Integer> reverse = numbers.stream()
    .sorted((a, b) -> b - a)
    .collect(Collectors.toList());  // [9,8,5,3,2,1]

// Using Comparator
List<String> words = Arrays.asList("banana", "apple", "cherry");
List<String> sortedWords = words.stream()
    .sorted(Comparator.comparing(String::length))
    .collect(Collectors.toList());  // ["apple","banana","cherry"] (by length)

// Multiple criteria
List<Person> people = getPeople();
List<Person> sortedPeople = people.stream()
    .sorted(Comparator.comparing(Person::getLastName)
        .thenComparing(Person::getFirstName))
    .collect(Collectors.toList());
```

### **5.7 peek()**

> **Concept:** Performs action on each element (mainly for debugging).

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

List<Integer> result = numbers.stream()
    .peek(n -> System.out.println("Before filter: " + n))
    .filter(n -> n % 2 == 0)
    .peek(n -> System.out.println("After filter: " + n))
    .map(n -> n * n)
    .peek(n -> System.out.println("After map: " + n))
    .collect(Collectors.toList());

// Debugging pipeline
long count = numbers.stream()
    .peek(System.out::println)
    .count();  // Still prints even though count doesn't need elements

// Logging intermediate values
```

### **5.8 limit()**

> **Concept:** Truncates stream to max size.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> first5 = numbers.stream()
    .limit(5)
    .collect(Collectors.toList());  // [1,2,3,4,5]

// With infinite streams
Stream.iterate(0, n -> n + 1)
    .limit(10)
    .forEach(System.out::println);  // 0 to 9
```

### **5.9 skip()**

> **Concept:** Discards first n elements.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> after5 = numbers.stream()
    .skip(5)
    .collect(Collectors.toList());  // [6,7,8,9,10]

// Pagination
int page = 2;
int pageSize = 3;
List<Integer> page2 = numbers.stream()
    .skip(page * pageSize)
    .limit(pageSize)
    .collect(Collectors.toList());  // [7,8,9] (page 2, size 3)
```

### **5.10 takeWhile() (Java 9+)**

> **Concept:** Takes elements while predicate is true (stops when false).

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> taken = numbers.stream()
    .takeWhile(n -> n < 5)
    .collect(Collectors.toList());  // [1,2,3,4]

List<String> words = Arrays.asList("apple", "banana", "cherry", "date");
List<String> takenWords = words.stream()
    .takeWhile(w -> w.length() <= 5)
    .collect(Collectors.toList());  // ["apple","date"? No! Stops at "banana" (length 6)]
```

### **5.11 dropWhile() (Java 9+)**

> **Concept:** Drops elements while predicate is true, then returns rest.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> dropped = numbers.stream()
    .dropWhile(n -> n < 5)
    .collect(Collectors.toList());  // [5,6,7,8,9,10]

List<String> words = Arrays.asList("apple", "banana", "cherry", "date");
List<String> droppedWords = words.stream()
    .dropWhile(w -> w.length() <= 5)
    .collect(Collectors.toList());  // ["banana","cherry","date"]
```

### **5.12 mapToInt/mapToLong/mapToDouble**

> **Concept:** Convert to primitive streams for performance.

```java
List<String> numbers = Arrays.asList("1", "2", "3", "4", "5");

IntStream intStream = numbers.stream()
    .mapToInt(Integer::parseInt);  // Primitive int stream

int sum = intStream.sum();  // 15

// Avoid boxing overhead
double avg = numbers.stream()
    .mapToDouble(Double::parseDouble)
    .average()
    .orElse(0.0);
```

---

## **6. TERMINAL OPERATIONS**

> **Concept:** Operations that produce a result or side-effect and close the stream.

### **6.1 forEach()**

> **Concept:** Performs action on each element.

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

names.stream()
    .forEach(name -> System.out.println("Hello, " + name));

// Using method reference
names.forEach(System.out::println);

// Order guaranteed for sequential streams
Stream.of("a", "b", "c")
    .forEach(System.out::print);  // "abc"

// Not guaranteed for parallel
Stream.of("a", "b", "c")
    .parallel()
    .forEach(System.out::print);  // Order not guaranteed
```

### **6.2 forEachOrdered()**

> **Concept:** Performs action in encounter order (important for parallel streams).

```java
Stream.of("a", "b", "c")
    .parallel()
    .forEachOrdered(System.out::print);  // Always "abc" even in parallel
```

### **6.3 collect()**

> **Concept:** Accumulates elements into a collection or other result.

```java
List<String> list = stream.collect(Collectors.toList());
Set<String> set = stream.collect(Collectors.toSet());
Map<String, Integer> map = stream.collect(Collectors.toMap(
    Function.identity(), String::length
));

// Custom collection
ArrayList<String> arrayList = stream.collect(Collectors.toCollection(ArrayList::new));
TreeSet<String> treeSet = stream.collect(Collectors.toCollection(TreeSet::new));

// Joining strings
String joined = stream.collect(Collectors.joining(", "));
```

### **6.4 toList() (Java 16+)**

> **Concept:** Convenience method to collect to unmodifiable list.

```java
List<String> list = stream.toList();  // Java 16+, returns unmodifiable list
// Equivalent to: stream.collect(Collectors.toUnmodifiableList())
```

### **6.5 reduce()**

> **Concept:** Combines elements into single result using associative function.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// With identity
int sum = numbers.stream()
    .reduce(0, (a, b) -> a + b);  // 15

int product = numbers.stream()
    .reduce(1, (a, b) -> a * b);  // 120

// Without identity (returns Optional)
Optional<Integer> max = numbers.stream()
    .reduce((a, b) -> a > b ? a : b);

Optional<String> longest = words.stream()
    .reduce((a, b) -> a.length() >= b.length() ? a : b);

// Three-argument reduce (for parallel streams)
int parallelSum = numbers.parallelStream()
    .reduce(0, Integer::sum, Integer::sum);
```

### **6.6 count()**

> **Concept:** Returns count of elements.

```java
long count = numbers.stream()
    .filter(n -> n > 5)
    .count();  // 4
```

### **6.7 anyMatch() / allMatch() / noneMatch()**

> **Concept:** Check if elements match predicate.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

boolean anyEven = numbers.stream()
    .anyMatch(n -> n % 2 == 0);  // true

boolean allPositive = numbers.stream()
    .allMatch(n -> n > 0);  // true

boolean noneNegative = numbers.stream()
    .noneMatch(n -> n < 0);  // true

// Short-circuiting - stops as soon as result known
boolean result = numbers.stream()
    .map(n -> {
        System.out.println("Processing: " + n);
        return n;
    })
    .anyMatch(n -> n > 3);  // Only processes until 4
```

### **6.8 findFirst()**

> **Concept:** Returns first element (respects encounter order).

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

Optional<Integer> first = numbers.stream()
    .filter(n -> n > 3)
    .findFirst();  // Optional[4]

// In parallel streams, still respects order
Optional<Integer> firstParallel = numbers.parallelStream()
    .filter(n -> n > 3)
    .findFirst();  // Still 4 (slower)
```

### **6.9 findAny()**

> **Concept:** Returns any element (optimized for parallel).

```java
Optional<Integer> any = numbers.parallelStream()
    .filter(n -> n > 3)
    .findAny();  // Could be 4 or 5 (whichever found first)

// More efficient in parallel streams
Optional<String> found = words.parallelStream()
    .filter(w -> w.startsWith("A"))
    .findAny();
```

### **6.10 min() / max()**

> **Concept:** Returns minimum or maximum element.

```java
List<Integer> numbers = Arrays.asList(5, 2, 8, 1, 9, 3);

Optional<Integer> min = numbers.stream()
    .min(Integer::compareTo);  // Optional[1]

Optional<Integer> max = numbers.stream()
    .max((a, b) -> a - b);  // Optional[9]

// With Comparator
Optional<Person> oldest = people.stream()
    .max(Comparator.comparing(Person::getAge));
```

---

## **7. SHORT-CIRCUITING OPERATIONS**

> **Concept:** Operations that can terminate early without processing entire stream.

| Operation | Type | Short-circuits when |
|-----------|------|---------------------|
| **limit(n)** | Intermediate | After n elements |
| **anyMatch** | Terminal | First true found |
| **allMatch** | Terminal | First false found |
| **noneMatch** | Terminal | First true found |
| **findFirst** | Terminal | First element found |
| **findAny** | Terminal | Any element found |

```java
// Example - short-circuiting in action
Stream.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    .peek(System.out::println)  // Prints until condition met
    .anyMatch(n -> n > 5);  // Prints 1,2,3,4,5,6 (stops at 6)
```

---

## **8. PRIMITIVE STREAMS**

> **Concept:** Specialized streams for primitives to avoid boxing overhead.

### **8.1 IntStream**

```java
// Creating IntStream
IntStream intStream1 = IntStream.of(1, 2, 3, 4, 5);
IntStream intStream2 = Arrays.stream(new int[]{1, 2, 3, 4, 5});
IntStream intStream3 = IntStream.range(1, 6);      // 1,2,3,4,5
IntStream intStream4 = IntStream.rangeClosed(1, 5); // 1,2,3,4,5
IntStream intStream5 = "Hello".chars();  // ASCII values

// Operations
int sum = intStream1.sum();  // 15
OptionalInt max = intStream2.max();
OptionalDouble avg = intStream3.average();
IntSummaryStatistics stats = intStream4.summaryStatistics();

System.out.println("Count: " + stats.getCount());
System.out.println("Sum: " + stats.getSum());
System.out.println("Min: " + stats.getMin());
System.out.println("Max: " + stats.getMax());
System.out.println("Avg: " + stats.getAverage());

// Conversion to object stream
Stream<Integer> boxed = intStream5.boxed();
```

### **8.2 LongStream**

```java
LongStream longStream1 = LongStream.of(1L, 2L, 3L);
LongStream longStream2 = LongStream.range(1L, 10L);  // 1-9
LongStream longStream3 = LongStream.rangeClosed(1L, 10L);  // 1-10
LongStream longStream4 = LongStream.iterate(0, i -> i + 2).limit(5);

long sum = longStream1.sum();
```

### **8.3 DoubleStream**

```java
DoubleStream doubleStream1 = DoubleStream.of(1.1, 2.2, 3.3);
DoubleStream doubleStream2 = DoubleStream.iterate(0, i -> i + 0.5).limit(5);
DoubleStream doubleStream3 = DoubleStream.generate(Math::random).limit(3);

double avg = doubleStream1.average().orElse(0);
```

---

## **9. OPTIONAL WITH STREAMS**

> **Concept:** Optional is used to handle potential absence of values.

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// findFirst returns Optional
Optional<String> first = names.stream()
    .filter(n -> n.startsWith("Z"))
    .findFirst();

// Handle Optional
String result = first.orElse("Not found");
String result2 = first.orElseGet(() -> generateDefault());
String result3 = first.orElseThrow(() -> new RuntimeException("Not found"));

// ifPresent
first.ifPresent(System.out::println);

// Optional in collectors
Map<Boolean, List<String>> partitioned = names.stream()
    .collect(Collectors.partitioningBy(n -> n.length() > 3));

// OptionalInt, OptionalLong, OptionalDouble for primitives
OptionalInt max = IntStream.of(1, 2, 3).max();
int value = max.orElse(0);
```

---

## **10. COLLECTORS**

> **Concept:** Terminal operation that accumulates elements into a result.

### **10.1 toList() / toSet() / toMap()**

```java
List<String> list = stream.collect(Collectors.toList());
Set<String> set = stream.collect(Collectors.toSet());

// toMap with key and value mappers
Map<String, Integer> map = stream.collect(
    Collectors.toMap(
        Function.identity(),  // key mapper
        String::length        // value mapper
    )
);

// Handle duplicate keys
Map<String, String> phoneBook = people.stream()
    .collect(Collectors.toMap(
        Person::getName,
        Person::getPhone,
        (existing, replacement) -> existing + ", " + replacement  // merge function
    ));

// Specify map type
TreeMap<String, Integer> treeMap = stream.collect(
    Collectors.toMap(
        Function.identity(),
        String::length,
        (a, b) -> a,
        TreeMap::new
    )
);
```

### **10.2 joining()**

```java
List<String> words = Arrays.asList("Java", "Streams", "Are", "Great");

String joined = words.stream()
    .collect(Collectors.joining());  // "JavaStreamsAreGreat"

String withSpaces = words.stream()
    .collect(Collectors.joining(" "));  // "Java Streams Are Great"

String withPrefixSuffix = words.stream()
    .collect(Collectors.joining(", ", "[", "]"));  // "[Java, Streams, Are, Great]"
```

### **10.3 summarizingInt / averagingInt / summingInt**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// Summarize
IntSummaryStatistics stats = numbers.stream()
    .collect(Collectors.summarizingInt(Integer::intValue));

// Average
Double avg = numbers.stream()
    .collect(Collectors.averagingInt(n -> n));  // 3.0

// Sum
Integer sum = numbers.stream()
    .collect(Collectors.summingInt(n -> n));  // 15

// For objects
Double avgAge = people.stream()
    .collect(Collectors.averagingInt(Person::getAge));
```

### **10.4 groupingBy()**

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25, "NY"),
    new Person("Bob", 30, "LA"),
    new Person("Charlie", 25, "NY"),
    new Person("David", 35, "LA"),
    new Person("Eve", 30, "NY")
);

// Simple grouping
Map<Integer, List<Person>> byAge = people.stream()
    .collect(Collectors.groupingBy(Person::getAge));

// Grouping with downstream collector
Map<String, Long> countByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.counting()
    ));

Map<String, Double> avgAgeByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.averagingInt(Person::getAge)
    ));

// Multi-level grouping
Map<String, Map<Integer, List<Person>>> byCityAndAge = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.groupingBy(Person::getAge)
    ));

// Grouping with custom map type
TreeMap<String, List<Person>> sortedByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        TreeMap::new,
        Collectors.toList()
    ));
```

### **10.5 partitioningBy()**

```java
Map<Boolean, List<Person>> partitioned = people.stream()
    .collect(Collectors.partitioningBy(p -> p.getAge() >= 30));

List<Person> older = partitioned.get(true);
List<Person> younger = partitioned.get(false);

// With downstream collector
Map<Boolean, Long> countByAgeGroup = people.stream()
    .collect(Collectors.partitioningBy(
        p -> p.getAge() >= 30,
        Collectors.counting()
    ));
```

### **10.6 mapping() / reducing()**

```java
// Collecting results of mapping
List<String> namesByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.mapping(Person::getName, Collectors.toList())
    ));

// Custom reduction
Optional<Integer> totalAge = people.stream()
    .map(Person::getAge)
    .collect(Collectors.reducing(Integer::sum));

Integer totalAge2 = people.stream()
    .collect(Collectors.reducing(0, Person::getAge, Integer::sum));
```

### **10.7 collectingAndThen()**

```java
// Post-process collection
List<String> unmodifiableList = people.stream()
    .map(Person::getName)
    .collect(Collectors.collectingAndThen(
        Collectors.toList(),
        Collections::unmodifiableList
    ));

// Get only one element after grouping
Map<String, Optional<Person>> oldestByCity = people.stream()
    .collect(Collectors.groupingBy(
        Person::getCity,
        Collectors.collectingAndThen(
            Collectors.maxBy(Comparator.comparing(Person::getAge)),
            Optional::get
        )
    ));
```

### **10.8 teeing() (Java 12+)**

```java
// Combine results of two collectors
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

Map<String, Double> result = numbers.stream()
    .collect(Collectors.teeing(
        Collectors.summingInt(Integer::intValue),  // First collector
        Collectors.counting(),                      // Second collector
        (sum, count) -> Map.of("sum", (double)sum, "avg", sum / count)
    ));

// Find min and max in one pass
Pair<Integer, Integer> minMax = numbers.stream()
    .collect(Collectors.teeing(
        Collectors.minBy(Integer::compareTo),
        Collectors.maxBy(Integer::compareTo),
        (min, max) -> new Pair<>(min.orElse(0), max.orElse(0))
    ));
```

---

## **11. PARALLEL STREAMS**

> **Concept:** Streams that leverage multiple cores for parallel processing.

### **11.1 Creating Parallel Streams**

```java
// From collection
List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
Stream<Integer> parallel1 = list.parallelStream();

// Convert sequential to parallel
Stream<Integer> parallel2 = list.stream().parallel();

// Check if parallel
boolean isParallel = parallel1.isParallel();

// Convert back to sequential
Stream<Integer> sequential = parallel1.sequential();
```

### **11.2 When to Use Parallel Streams**

```java
// Good for CPU-intensive operations on large datasets
long sum = LongStream.rangeClosed(1, 10_000_000)
    .parallel()
    .sum();

// Good when order doesn't matter
Set<String> names = people.parallelStream()
    .map(Person::getName)
    .collect(Collectors.toSet());

// Avoid when operations are not independent
// (shared mutable state is bad)
List<Integer> list = new ArrayList<>();  // Shared mutable state
IntStream.range(0, 1000)
    .parallel()
    .forEach(list::add);  // ❌ Not thread-safe!
System.out.println(list.size());  // Not 1000!

// Correct way
List<Integer> safeList = IntStream.range(0, 1000)
    .parallel()
    .boxed()
    .collect(Collectors.toList());  // ✅ Thread-safe collector
```

### **11.3 Performance Considerations**

```java
// Measure performance
long start = System.currentTimeMillis();
long sum1 = LongStream.rangeClosed(1, 100_000_000)
    .sum();
long time1 = System.currentTimeMillis() - start;

start = System.currentTimeMillis();
long sum2 = LongStream.rangeClosed(1, 100_000_000)
    .parallel()
    .sum();
long time2 = System.currentTimeMillis() - start;

System.out.println("Sequential: " + time1 + "ms");
System.out.println("Parallel: " + time2 + "ms");

// Parallel overhead - not worth for small datasets
List<Integer> small = IntStream.range(1, 1000).boxed().collect(Collectors.toList());
small.stream().parallel().forEach(x -> {});  // More overhead than benefit
```

### **11.4 Custom ForkJoinPool**

```java
// Use custom thread pool
ForkJoinPool customPool = new ForkJoinPool(4);  // 4 threads

try {
    customPool.submit(() -> 
        LongStream.rangeClosed(1, 10_000_000)
            .parallel()
            .sum()
    ).get();
} catch (Exception e) {
    e.printStackTrace();
} finally {
    customPool.shutdown();
}
```

### **11.5 Stateless vs Stateful Operations**

```java
// Stateless operations (good for parallel)
numbers.parallelStream()
    .filter(n -> n % 2 == 0)  // Stateless
    .map(n -> n * n)           // Stateless
    .collect(Collectors.toList());

// Stateful operations (limited parallel benefit)
numbers.parallelStream()
    .distinct()     // Stateful
    .sorted()       // Stateful
    .limit(10)      // Stateful