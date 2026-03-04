# **Complete Arrays Utility Class Guide** 📦

_A comprehensive guide to all java.util.Arrays methods with examples and use cases_

---

## **📋 OVERVIEW**

`java.util.Arrays` is a utility class containing **static methods** for manipulating arrays. It provides:

- **Sorting and searching**
- **Conversion between arrays and lists**
- **Comparison and hashing**
- **Copying and filling**
- **Stream operations** (Java 8+)
- **Parallel operations** (Java 8+)

---

## **1. CONVERSION METHODS** 🔄

### **asList() - Array to List**

```java
// Convert array to fixed-size list
String[] array = {"A", "B", "C"};
List<String> list = Arrays.asList(array);
// list = ["A", "B", "C"]

// Direct creation
List<String> list2 = Arrays.asList("X", "Y", "Z");

// IMPORTANT: Returns fixed-size list!
list.set(0, "Z");           // ✅ OK - modifies array!
// list.add("D");            // ❌ UnsupportedOperationException!
// list.remove(0);           // ❌ UnsupportedOperationException!

// Backed by original array - changes reflect both ways
array[1] = "Changed";
System.out.println(list.get(1));  // "Changed"

// For modifiable list:
List<String> modifiable = new ArrayList<>(Arrays.asList(array));

// Primitive arrays need care
int[] intArray = {1, 2, 3};
List<int[]> list = Arrays.asList(intArray);  // List with ONE element (the array!)
// Correct way for primitives:
Integer[] integerArray = {1, 2, 3};
List<Integer> correct = Arrays.asList(integerArray);
```

---

## **2. SORTING METHODS** 📊

### **sort() - Sort Arrays**

```java
// Sort entire array
int[] numbers = {5, 2, 8, 1, 9, 3};
Arrays.sort(numbers);  // [1, 2, 3, 5, 8, 9]

// Sort specific range [fromIndex, toIndex)
int[] nums = {5, 2, 8, 1, 9, 3, 7, 4};
Arrays.sort(nums, 2, 6);  // Sort indices 2-5 only
// Original: [5, 2, 8, 1, 9, 3, 7, 4]
// Result:   [5, 2, 1, 3, 8, 9, 7, 4]

// Sort objects (must implement Comparable)
String[] names = {"Charlie", "Alice", "Bob"};
Arrays.sort(names);  // ["Alice", "Bob", "Charlie"]

// Sort with Comparator
String[] words = {"banana", "Apple", "cherry", "Date"};
Arrays.sort(words, String.CASE_INSENSITIVE_ORDER);
// ["Apple", "banana", "cherry", "Date"]

// Custom comparator
Person[] people = getPeople();
Arrays.sort(people, Comparator.comparing(Person::getAge));
Arrays.sort(people, (a, b) -> b.getAge() - a.getAge());  // Descending

// Multi-criteria sort
Arrays.sort(people, Comparator
    .comparing(Person::getLastName)
    .thenComparing(Person::getFirstName)
    .thenComparingInt(Person::getAge));
```

### **parallelSort() - Parallel Sort (Java 8+)**

```java
// Uses multiple threads for large arrays
int[] bigArray = generateBigArray();
Arrays.parallelSort(bigArray);  // Faster for large arrays (> 8192 elements)

// Range sort in parallel
Arrays.parallelSort(bigArray, 1000, 5000);

// Custom comparator with parallel sort
Person[] people = getManyPeople();
Arrays.parallelSort(people, Comparator.comparing(Person::getAge));

// Performance benefit grows with array size
// Uses ForkJoinPool.commonPool()
```

---

## **3. SEARCHING METHODS** 🔍

### **binarySearch() - Fast Search in Sorted Array**

```java
// Array must be SORTED before searching!
int[] numbers = {1, 3, 5, 7, 9, 11, 13};
int index = Arrays.binarySearch(numbers, 7);  // Returns 3

// If not found, returns -(insertion point) - 1
int notFound = Arrays.binarySearch(numbers, 6);  // Returns -4
// Insertion point for 6 would be index 3 (between 5 and 7)
// Formula: -(3) - 1 = -4

// Search in range [fromIndex, toIndex)
int[] nums = {1, 3, 5, 7, 9, 11, 13, 15, 17};
int idx = Arrays.binarySearch(nums, 2, 6, 9);  // Search indices 2-5 for 9
// Returns 4 (within range)

// Object arrays
String[] names = {"Alice", "Bob", "Charlie", "David"};
int pos = Arrays.binarySearch(names, "Charlie");  // 2

// With comparator
String[] words = {"apple", "banana", "Cherry", "date"};
// Case-insensitive search (array must be sorted with same comparator!)
Arrays.sort(words, String.CASE_INSENSITIVE_ORDER);
int found = Arrays.binarySearch(words, "CHERRY", String.CASE_INSENSITIVE_ORDER);

// Check if element exists
boolean exists = Arrays.binarySearch(sortedArray, key) >= 0;
```

---

## **4. COMPARISON METHODS** ⚖️

### **equals() - Compare Arrays**

```java
int[] arr1 = {1, 2, 3, 4, 5};
int[] arr2 = {1, 2, 3, 4, 5};
int[] arr3 = {1, 2, 3, 4, 6};

boolean equal = Arrays.equals(arr1, arr2);  // true
boolean notEqual = Arrays.equals(arr1, arr3);  // false

// Range comparison [fromIndex, toIndex)
boolean rangeEqual = Arrays.equals(arr1, 1, 4, arr2, 1, 4);  // Compare [1,2,3]

// Object arrays
String[] s1 = {"A", "B", "C"};
String[] s2 = {"A", "B", "C"};
Arrays.equals(s1, s2);  // true (uses equals() on elements)

// For deep comparison (nested arrays)
int[][] matrix1 = {{1,2}, {3,4}};
int[][] matrix2 = {{1,2}, {3,4}};
Arrays.equals(matrix1, matrix2);  // false (compares references)
Arrays.deepEquals(matrix1, matrix2);  // true (compares content)
```

### **deepEquals() - Deep Array Comparison**

```java
// For multi-dimensional arrays
int[][] a = {{1, 2}, {3, 4}};
int[][] b = {{1, 2}, {3, 4}};
int[][] c = {{1, 2}, {3, 5}};

Arrays.deepEquals(a, b);  // true
Arrays.deepEquals(a, c);  // false

// Works with any nesting depth
Object[] nested1 = {1, new int[]{2, 3}, new String[]{"A", "B"}};
Object[] nested2 = {1, new int[]{2, 3}, new String[]{"A", "B"}};
Arrays.deepEquals(nested1, nested2);  // true

// Regular equals would compare references, not content
Arrays.equals(nested1, nested2);  // false (different array objects)
```

---

## **5. HASH CODE METHODS** 🔢

### **hashCode() - Array Hash Code**

```java
int[] numbers = {1, 2, 3, 4, 5};
int hash = Arrays.hashCode(numbers);  // Hash based on content

// Consistent with equals: if Arrays.equals(a,b) then Arrays.hashCode(a) == Arrays.hashCode(b)
int[] copy = Arrays.copyOf(numbers, numbers.length);
System.out.println(Arrays.hashCode(numbers) == Arrays.hashCode(copy));  // true

// For multi-dimensional arrays
int[][] matrix = {{1,2}, {3,4}};
int deepHash = Arrays.deepHashCode(matrix);  // Hash of all elements
```

### **deepHashCode() - Deep Hash Code**

```java
Object[] mixed = {1, "Hello", new int[]{2, 3}};
int deepHash = Arrays.deepHashCode(mixed);
// Consistent with deepEquals
```

---

## **6. STRING REPRESENTATION** 📝

### **toString() - Array to String**

```java
int[] numbers = {1, 2, 3, 4, 5};
String str = Arrays.toString(numbers);  // "[1, 2, 3, 4, 5]"

String[] names = {"Alice", "Bob", "Charlie"};
System.out.println(Arrays.toString(names));  // "[Alice, Bob, Charlie]"

// For debugging
int[] data = getData();
System.out.println("Data: " + Arrays.toString(data));

// For single element
int[] single = {42};
Arrays.toString(single);  // "[42]"

// Empty array
int[] empty = {};
Arrays.toString(empty);  // "[]"
```

### **deepToString() - Deep Array String**

```java
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};
System.out.println(Arrays.deepToString(matrix));
// "[[1, 2, 3], [4, 5, 6], [7, 8, 9]]"

// Nested arrays
Object[] nested = {1, "Hello", new int[]{2, 3}, new String[]{"A", "B"}};
System.out.println(Arrays.deepToString(nested));
// "[1, Hello, [2, 3], [A, B]]"

// 3D arrays
int[][][] cube = {{{1,2}, {3,4}}, {{5,6}, {7,8}}};
System.out.println(Arrays.deepToString(cube));
// "[[[1, 2], [3, 4]], [[5, 6], [7, 8]]]"
```

---

## **7. COPYING METHODS** 📋

### **copyOf() - Copy Array with New Length**

```java
int[] original = {1, 2, 3, 4, 5};

// Copy with same length
int[] copy = Arrays.copyOf(original, original.length);  // [1, 2, 3, 4, 5]

// Copy with larger length (pads with default values)
int[] longer = Arrays.copyOf(original, 8);  // [1, 2, 3, 4, 5, 0, 0, 0]

// Copy with smaller length (truncates)
int[] shorter = Arrays.copyOf(original, 3);  // [1, 2, 3]

// Works with objects
String[] names = {"Alice", "Bob", "Charlie"};
String[] moreNames = Arrays.copyOf(names, 5);  // ["Alice", "Bob", "Charlie", null, null]

// Type conversion doesn't work
// Integer[] nums = Arrays.copyOf(intArray, intArray.length); // COMPILE ERROR!
```

### **copyOfRange() - Copy Array Range**

```java
int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// Copy range [fromIndex, toIndex)
int[] subArray = Arrays.copyOfRange(numbers, 3, 7);  // [4, 5, 6, 7]

// toIndex can be beyond length (pads with defaults)
int[] extended = Arrays.copyOfRange(numbers, 5, 12);  // [6, 7, 8, 9, 10, 0, 0]

// fromIndex can be 0, toIndex can be length
int[] allButFirst = Arrays.copyOfRange(numbers, 1, numbers.length);  // [2..10]

// Object arrays
String[] words = {"The", "quick", "brown", "fox", "jumps"};
String[] someWords = Arrays.copyOfRange(words, 1, 4);  // ["quick", "brown", "fox"]
```

---

## **8. FILLING METHODS** 🎨

### **fill() - Fill Array with Value**

```java
int[] numbers = new int[10];
Arrays.fill(numbers, 42);  // [42, 42, 42, 42, 42, 42, 42, 42, 42, 42]

// Fill range [fromIndex, toIndex)
int[] data = new int[10];
Arrays.fill(data, 2, 7, 99);  // Indices 2-6 get 99, rest default (0)

// Object arrays
String[] names = new String[5];
Arrays.fill(names, "Unknown");  // ["Unknown", "Unknown", "Unknown", "Unknown", "Unknown"]

// Multi-dimensional (fill each row separately)
int[][] matrix = new int[3][4];
for (int[] row : matrix) {
    Arrays.fill(row, 1);
}
// Matrix filled with 1s

// Reset array
int[] scores = {95, 87, 92, 78, 88};
Arrays.fill(scores, 0);  // Reset to zero
```

### **setAll() - Generate Values (Java 8+)**

```java
int[] squares = new int[10];
Arrays.setAll(squares, i -> i * i);  // [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

// With generator function
String[] labels = new String[5];
Arrays.setAll(labels, i -> "Item " + (i+1));  // ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

// Random values
double[] randomValues = new double[100];
Arrays.setAll(randomValues, i -> Math.random());

// Fibonacci
int[] fib = new int[10];
fib[0] = 0; fib[1] = 1;
Arrays.setAll(fib, i -> i < 2 ? fib[i] : fib[i-1] + fib[i-2]);
```

### **parallelSetAll() - Parallel Generation (Java 8+)**

```java
int[] bigArray = new int[1_000_000];
Arrays.parallelSetAll(bigArray, i -> i * 2);  // Uses multiple threads

// Faster for large arrays
long[] factorials = new long[100_000];
Arrays.parallelSetAll(factorials, i -> computeFactorial(i));
```

---

## **9. PREFIX OPERATIONS (Java 8+)** ➕

### **parallelPrefix() - Cumulative Operations**

```java
int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// Cumulative sum
Arrays.parallelPrefix(numbers, Integer::sum);
// [1, 3, 6, 10, 15, 21, 28, 36, 45, 55]

// Cumulative product
int[] values = {1, 2, 3, 4, 5};
Arrays.parallelPrefix(values, (x, y) -> x * y);
// [1, 2, 6, 24, 120]

// Range prefix
int[] data = {2, 4, 6, 8, 10, 12, 14, 16};
Arrays.parallelPrefix(data, 2, 6, (x, y) -> x + y);
// Indices 2-5 get cumulative sum, rest unchanged

// Custom operation
String[] words = {"Hello", " ", "World", " ", "!"};
Arrays.parallelPrefix(words, (a, b) -> a + b);
// ["Hello", "Hello ", "Hello World", "Hello World ", "Hello World !"]
```

---

## **10. STREAM METHODS (Java 8+)** 🌊

### **stream() - Create Stream from Array**

```java
int[] numbers = {1, 2, 3, 4, 5};

// IntStream
IntStream stream = Arrays.stream(numbers);
int sum = Arrays.stream(numbers).sum();  // 15
double avg = Arrays.stream(numbers).average().orElse(0);  // 3.0

// Range stream
IntStream range = Arrays.stream(numbers, 2, 5);  // elements 2,3,4

// Object arrays
String[] words = {"apple", "banana", "cherry"};
Stream<String> wordStream = Arrays.stream(words);
List<String> filtered = Arrays.stream(words)
    .filter(w -> w.startsWith("b"))
    .collect(Collectors.toList());  // ["banana"]

// Primitive streams
double[] prices = {19.99, 29.99, 39.99};
DoubleStream priceStream = Arrays.stream(prices);
OptionalDouble max = Arrays.stream(prices).max();

// Parallel stream
int sumParallel = Arrays.stream(numbers).parallel().sum();

// Chaining operations
String[] names = {"Alice", "Bob", "Charlie", "David"};
List<String> result = Arrays.stream(names)
    .filter(name -> name.length() > 4)
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.toList());
// ["CHARLIE", "DAVID"]
```

---

## **11. MISCELLANEOUS METHODS** 🎲

### **mismatch() - Find First Difference (Java 9+)**

```java
int[] a = {1, 2, 3, 4, 5};
int[] b = {1, 2, 3, 8, 5};

int index = Arrays.mismatch(a, b);  // Returns 3 (first differing index)

// If identical, returns -1
int[] c = {1, 2, 3, 4, 5};
int same = Arrays.mismatch(a, c);  // -1

// Range mismatch
int[] x = {1, 2, 3, 4, 5, 6, 7};
int[] y = {1, 2, 3, 8, 5, 6, 7};
int mismatch = Arrays.mismatch(x, 0, 4, y, 0, 4);  // Compare first 4 elements: returns 3

// Object arrays
String[] s1 = {"A", "B", "C", "D"};
String[] s2 = {"A", "B", "X", "D"};
Arrays.mismatch(s1, s2);  // 2
```

### **compare() - Lexicographic Comparison (Java 9+)**

```java
int[] a = {1, 2, 3};
int[] b = {1, 2, 3};
int[] c = {1, 2, 4};
int[] d = {1, 2, 3, 4};

Arrays.compare(a, b);  // 0 (equal)
Arrays.compare(a, c);  // -1 (a < c at index 2)
Arrays.compare(c, a);  // 1 (c > a)
Arrays.compare(a, d);  // -1 (a is prefix of d)

// With comparator for objects
String[] s1 = {"Apple", "Banana"};
String[] s2 = {"apple", "banana"};
Arrays.compare(s1, s2, String.CASE_INSENSITIVE_ORDER);  // 0

// Range comparison
int result = Arrays.compare(a, 0, 2, d, 0, 2);  // Compare first 2 elements
```

---

## **📊 QUICK REFERENCE TABLE**

| Category       | Method             | Description                     |
| -------------- | ------------------ | ------------------------------- |
| **Conversion** | `asList()`         | Array → List (fixed-size)       |
| **Sorting**    | `sort()`           | Sort array                      |
|                | `parallelSort()`   | Parallel sort (Java 8+)         |
| **Searching**  | `binarySearch()`   | Binary search in sorted array   |
| **Comparison** | `equals()`         | Compare arrays                  |
|                | `deepEquals()`     | Deep compare nested arrays      |
| **Hashing**    | `hashCode()`       | Hash code based on content      |
|                | `deepHashCode()`   | Deep hash code                  |
| **String**     | `toString()`       | Array to string                 |
|                | `deepToString()`   | Deep array to string            |
| **Copying**    | `copyOf()`         | Copy with new length            |
|                | `copyOfRange()`    | Copy range                      |
| **Filling**    | `fill()`           | Fill with value                 |
|                | `setAll()`         | Generate values (Java 8+)       |
|                | `parallelSetAll()` | Parallel generate (Java 8+)     |
| **Prefix**     | `parallelPrefix()` | Cumulative operation (Java 8+)  |
| **Stream**     | `stream()`         | Create stream (Java 8+)         |
| **Misc**       | `mismatch()`       | Find first difference (Java 9+) |
|                | `compare()`        | Lexicographic compare (Java 9+) |

---

## **🎯 USE CASE EXAMPLES**

### **1. Array Initialization and Fill**

```java
// Initialize with default values
int[] counters = new int[100];
Arrays.fill(counters, 1);  // All start at 1

// Generate sequence
int[] sequence = new int[50];
Arrays.setAll(sequence, i -> i * 2);  // Even numbers

// Reset array
int[] scores = getScores();
Arrays.fill(scores, 0);  // Reset all to zero
```

### **2. Safe Array Copy**

```java
public int[] getData() {
    int[] internal = {1, 2, 3, 4, 5};
    // Return copy to prevent modification
    return Arrays.copyOf(internal, internal.length);
}

// Defensive copying
public void processData(int[] data) {
    int[] safeCopy = Arrays.copyOf(data, data.length);
    // Work with safeCopy
}
```

### **3. Print Array for Debugging**

```java
int[] matrix = calculateMatrix();
System.out.println("Matrix: " + Arrays.toString(matrix));

int[][] grid = calculateGrid();
System.out.println("Grid:\n" + Arrays.deepToString(grid));
```

### **4. Check if Arrays are Equal**

```java
public boolean configurationChanged(int[] oldConfig, int[] newConfig) {
    return !Arrays.equals(oldConfig, newConfig);
}

// For deep equality
public boolean deepEquals(Object[] oldData, Object[] newData) {
    return Arrays.deepEquals(oldData, newData);
}
```

### **5. Find Element in Sorted Array**

```java
int[] sortedIds = {101, 102, 103, 104, 105, 106, 107};
int searchId = 104;

int index = Arrays.binarySearch(sortedIds, searchId);
if (index >= 0) {
    System.out.println("Found at index: " + index);
} else {
    int insertionPoint = -index - 1;
    System.out.println("Insert at: " + insertionPoint);
}
```

### **6. Convert Array to List and Back**

```java
// Array → List
String[] colors = {"Red", "Green", "Blue"};
List<String> colorList = new ArrayList<>(Arrays.asList(colors));
colorList.add("Yellow");  // Now modifiable

// List → Array
String[] newArray = colorList.toArray(new String[0]);
String[] sizedArray = colorList.toArray(new String[colorList.size()]);
```

### **7. Sort with Custom Comparator**

```java
Person[] people = getPeople();

// Sort by age
Arrays.sort(people, Comparator.comparingInt(Person::getAge));

// Sort by multiple fields
Arrays.sort(people, Comparator
    .comparing(Person::getLastName)
    .thenComparing(Person::getFirstName));

// Case-insensitive sort
String[] words = {"apple", "Banana", "CHERRY", "date"};
Arrays.sort(words, String.CASE_INSENSITIVE_ORDER);
```

### **8. Find First Difference**

```java
byte[] expected = {1, 2, 3, 4, 5};
byte[] actual = receiveData();

int diff = Arrays.mismatch(expected, actual);
if (diff == -1) {
    System.out.println("Data matches");
} else {
    System.out.println("Mismatch at position " + diff);
    System.out.println("Expected: " + expected[diff] + ", Got: " + actual[diff]);
}
```

### **9. Parallel Array Operations**

```java
// Parallel prefix for cumulative operations
int[] prices = {10, 20, 30, 40, 50};
Arrays.parallelPrefix(prices, (a, b) -> a + b);
// prices = [10, 30, 60, 100, 150] (running total)

// Parallel set all
double[] squares = new double[1_000_000];
Arrays.parallelSetAll(squares, i -> Math.sqrt(i));
```

### **10. Stream Processing**

```java
int[] numbers = {5, 2, 8, 1, 9, 3, 7, 4, 6};

// Statistics
int sum = Arrays.stream(numbers).sum();
double avg = Arrays.stream(numbers).average().orElse(0);
int max = Arrays.stream(numbers).max().orElse(0);

// Filter and transform
List<Integer> evenSquares = Arrays.stream(numbers)
    .filter(n -> n % 2 == 0)
    .map(n -> n * n)
    .boxed()
    .collect(Collectors.toList());

// Parallel processing
long count = Arrays.stream(numbers)
    .parallel()
    .filter(n -> n > 5)
    .count();
```

---

## **⚠️ IMPORTANT NOTES**

1. **asList() returns fixed-size list** - cannot add/remove, but can set
2. **binarySearch() requires sorted array** - results undefined if not sorted
3. **copyOfRange() toIndex can exceed length** - pads with default values
4. **deepEquals() for nested arrays** - regular equals() compares references
5. **parallel operations benefit large arrays** - overhead for small ones
6. **stream() for primitive arrays** - returns IntStream, LongStream, DoubleStream
7. **Java 9+ methods** - mismatch(), compare() added
8. **Array covariance** - `Object[] objArray = new String[10]` works but can cause runtime errors

---

## **🚀 QUICK CHEAT SHEET**

```java
// Conversion
List<T> list = Arrays.asList(array);
List<T> modifiable = new ArrayList<>(Arrays.asList(array));

// Sorting
Arrays.sort(array);
Arrays.sort(array, from, to);
Arrays.sort(array, comparator);
Arrays.parallelSort(array);

// Searching
int idx = Arrays.binarySearch(array, key);
int idx = Arrays.binarySearch(array, from, to, key);

// Copying
T[] copy = Arrays.copyOf(original, newLength);
T[] range = Arrays.copyOfRange(original, from, to);

// Filling
Arrays.fill(array, value);
Arrays.fill(array, from, to, value);
Arrays.setAll(array, generator);
Arrays.parallelSetAll(array, generator);

// Comparison
boolean equal = Arrays.equals(a1, a2);
boolean deepEqual = Arrays.deepEquals(a1, a2);
int mismatch = Arrays.mismatch(a1, a2);
int compare = Arrays.compare(a1, a2);

// String
String str = Arrays.toString(array);
String deepStr = Arrays.deepToString(array);

// Hash
int hash = Arrays.hashCode(array);
int deepHash = Arrays.deepHashCode(array);

// Stream
IntStream stream = Arrays.stream(array);
IntStream range = Arrays.stream(array, from, to);

// Prefix (cumulative)
Arrays.parallelPrefix(array, operator);
Arrays.parallelPrefix(array, from, to, operator);
```

---

_Happy Interview Prep! 🎉_
