# **Complete Java Lambda Expressions - The Ultimate Interview Guide** 📚

_Your comprehensive go-to reference for all Java Lambda concepts with brief explanations and code examples_

---

## **📋 TABLE OF CONTENTS**

- [**Complete Java Lambda Expressions - The Ultimate Interview Guide** 📚](#complete-java-lambda-expressions---the-ultimate-interview-guide-)
  - [**📋 TABLE OF CONTENTS**](#-table-of-contents)
  - [**1. WHAT ARE LAMBDA EXPRESSIONS?**](#1-what-are-lambda-expressions)
  - [**2. WHY LAMBDAS?**](#2-why-lambdas)
  - [**3. LAMBDA SYNTAX**](#3-lambda-syntax)
    - [**Syntax Variations**](#syntax-variations)
  - [**4. FUNCTIONAL INTERFACES**](#4-functional-interfaces)
    - [**Rules for Functional Interfaces**](#rules-for-functional-interfaces)
  - [**5. BUILT-IN FUNCTIONAL INTERFACES**](#5-built-in-functional-interfaces)
    - [**5.1 Consumer**](#51-consumer)
    - [**5.2 Supplier**](#52-supplier)
    - [**5.3 Predicate**](#53-predicate)
    - [**5.4 Function\<T, R\>**](#54-functiont-r)
    - [**5.5 UnaryOperator**](#55-unaryoperator)
    - [**5.6 BinaryOperator**](#56-binaryoperator)
    - [**5.7 BiFunction\<T, U, R\>**](#57-bifunctiont-u-r)
    - [**5.8 BiConsumer\<T, U\>**](#58-biconsumert-u)
    - [**5.9 BiPredicate\<T, U\>**](#59-bipredicatet-u)
    - [**5.10 Summary Table**](#510-summary-table)
  - [**6. METHOD REFERENCES**](#6-method-references)
    - [**Syntax: `ClassName::methodName` or `instance::methodName`**](#syntax-classnamemethodname-or-instancemethodname)
    - [**Types of Method References**](#types-of-method-references)
    - [**Examples**](#examples)
  - [**7. CONSTRUCTOR REFERENCES**](#7-constructor-references)
  - [**8. VARIABLE CAPTURE (EFFECTIVELY FINAL)**](#8-variable-capture-effectively-final)
  - [**9. SCOPE IN LAMBDAS**](#9-scope-in-lambdas)
  - [**10. TYPE INFERENCE**](#10-type-inference)
  - [**11. LAMBDA AND EXCEPTION HANDLING**](#11-lambda-and-exception-handling)
  - [**12. LAMBDA WITH COLLECTIONS**](#12-lambda-with-collections)
    - [**12.1 Iteration**](#121-iteration)
    - [**12.2 Sorting**](#122-sorting)
    - [**12.3 Filtering**](#123-filtering)
    - [**12.4 Map Operations**](#124-map-operations)
    - [**12.5 List ReplaceAll**](#125-list-replaceall)
  - [**13. LAMBDA WITH STREAMS API**](#13-lambda-with-streams-api)
    - [**13.1 Stream Pipeline**](#131-stream-pipeline)
    - [**13.2 Common Stream Operations**](#132-common-stream-operations)
    - [**13.3 Terminal Operations**](#133-terminal-operations)
    - [**13.4 Grouping and Partitioning**](#134-grouping-and-partitioning)

---

## **1. WHAT ARE LAMBDA EXPRESSIONS?**

> **Concept:** Lambda expressions are anonymous functions (functions without a name) that can be treated as values - passed around, stored in variables, and executed later.

```java
// Before Java 8 (Anonymous inner class)
Runnable r1 = new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello");
    }
};

// Java 8+ (Lambda)
Runnable r2 = () -> System.out.println("Hello");

// Lambda as a value
Function<String, Integer> stringLength = s -> s.length();
Integer len = stringLength.apply("Hello");  // 5
```

---

## **2. WHY LAMBDAS?**

| Benefit                    | Explanation              | Example                                                        |
| -------------------------- | ------------------------ | -------------------------------------------------------------- |
| **Concise Code**           | Less boilerplate         | `() -> System.out.println("Hi")` vs 5 lines of anonymous class |
| **Functional Programming** | Treat functions as data  | Pass behavior as argument                                      |
| **Parallel Processing**    | Enable stream operations | `list.parallelStream().filter(x -> x > 5)`                     |
| **Lazy Evaluation**        | Execute only when needed | Streams are lazily evaluated                                   |
| **Better APIs**            | More expressive APIs     | `Collections.sort(list, (a,b) -> a.compareTo(b))`              |

```java
// Without lambda - verbose
List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
Collections.sort(list, new Comparator<Integer>() {
    @Override
    public int compare(Integer a, Integer b) {
        return a.compareTo(b);
    }
});

// With lambda - concise
Collections.sort(list, (a, b) -> a.compareTo(b));

// Even shorter with method reference
Collections.sort(list, Integer::compareTo);
```

---

## **3. LAMBDA SYNTAX**

> **Concept:** Lambda expressions consist of parameters, arrow token `->`, and body.

```
(parameters) -> expression
(parameters) -> { statements; }
```

### **Syntax Variations**

```java
// 1. No parameters
Runnable r = () -> System.out.println("Hello");

// 2. Single parameter (parentheses optional)
Function<String, Integer> f1 = s -> s.length();
Function<String, Integer> f2 = (s) -> s.length();  // Same

// 3. Multiple parameters
Comparator<Integer> comp = (a, b) -> a.compareTo(b);

// 4. Multiple statements (need braces and return)
Comparator<Integer> comp2 = (a, b) -> {
    System.out.println("Comparing " + a + " and " + b);
    return a.compareTo(b);
};

// 5. Explicit parameter types
BinaryOperator<Integer> sum = (Integer a, Integer b) -> a + b;

// 6. Returning value in single expression (no return keyword)
Function<Integer, Integer> doubleIt = x -> x * 2;

// 7. Returning value in block (need return)
Function<Integer, Integer> doubleIt2 = x -> {
    System.out.println("Doubling " + x);
    return x * 2;
};

// 8. Void method with block
Consumer<String> printer = s -> System.out.println(s);
Consumer<String> printer2 = s -> { System.out.println(s); };
```

---

## **4. FUNCTIONAL INTERFACES**

> **Concept:** An interface with exactly ONE abstract method. Can have multiple default/static methods. Lambdas can be used to instantiate functional interfaces.

```java
// @FunctionalInterface annotation (optional but recommended)
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);  // Single abstract method

    // Default methods allowed
    default void printResult(int result) {
        System.out.println("Result: " + result);
    }

    // Static methods allowed
    static Calculator addition() {
        return (a, b) -> a + b;
    }
}

// Using lambda
Calculator add = (a, b) -> a + b;
int sum = add.calculate(5, 3);  // 8
add.printResult(sum);  // "Result: 8"

Calculator multiply = (a, b) -> a * b;
int product = multiply.calculate(5, 3);  // 15

// Using static factory method
Calculator add2 = Calculator.addition();

// Without lambda (traditional)
Calculator subtract = new Calculator() {
    @Override
    public int calculate(int a, int b) {
        return a - b;
    }
};
```

### **Rules for Functional Interfaces**

```java
// Rule 1: Only one abstract method
@FunctionalInterface
interface Valid {
    void doSomething();  // OK - one abstract method
}

// Rule 2: Multiple default methods allowed
@FunctionalInterface
interface WithDefaults {
    void doit();
    default void log() { System.out.println("Logging"); }
    default void info() { System.out.println("Info"); }
}

// Rule 3: Multiple abstract methods NOT allowed
// @FunctionalInterface
// interface Invalid {
//     void method1();
//     void method2();  // ❌ Compile error!
// }

// Rule 4: Methods from Object don't count
@FunctionalInterface
interface Comparator<T> {
    int compare(T a, T b);  // Abstract method
    boolean equals(Object obj);  // From Object - doesn't count
}
```

---

## **5. BUILT-IN FUNCTIONAL INTERFACES**

> **Concept:** Java 8 provides common functional interfaces in `java.util.function` package.

### **5.1 Consumer<T>**

> **Concept:** Accepts a single input, returns no result.

```java
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}

// Examples
Consumer<String> printer = s -> System.out.println(s);
printer.accept("Hello");  // Hello

Consumer<Integer> doubler = i -> System.out.println(i * 2);
doubler.accept(5);  // 10

// Chaining consumers
Consumer<String> print = s -> System.out.print(s);
Consumer<String> println = s -> System.out.println(s);
Consumer<String> printThenLn = print.andThen(println);
printThenLn.accept("Hello");  // HelloHello (then newline)

// Real usage
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
names.forEach(name -> System.out.println(name));
names.forEach(System.out::println);  // Method reference
```

### **5.2 Supplier<T>**

> **Concept:** Takes no input, returns a result.

```java
@FunctionalInterface
public interface Supplier<T> {
    T get();
}

// Examples
Supplier<String> helloSupplier = () -> "Hello World";
String s = helloSupplier.get();  // "Hello World"

Supplier<Double> randomSupplier = () -> Math.random();
double r = randomSupplier.get();

Supplier<List<String>> listSupplier = () -> new ArrayList<>();
List<String> list = listSupplier.get();

// Lazy initialization
public static <T> T getOrCompute(Supplier<T> supplier) {
    return supplier.get();  // Compute only when called
}

// Real usage - orElseGet
Optional<String> opt = Optional.ofNullable(null);
String result = opt.orElseGet(() -> "Default Value");

// Factory pattern
Supplier<Product> productFactory = () -> new Product();
Product p = productFactory.get();
```

### **5.3 Predicate<T>**

> **Concept:** Takes one input, returns boolean. Used for filtering.

```java
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}

// Examples
Predicate<String> isEmpty = s -> s.isEmpty();
Predicate<String> notEmpty = s -> !s.isEmpty();
Predicate<Integer> isPositive = i -> i > 0;

System.out.println(isEmpty.test(""));    // true
System.out.println(isEmpty.test("Hi"));  // false

// Combining predicates
Predicate<String> startsWithA = s -> s.startsWith("A");
Predicate<String> endsWithZ = s -> s.endsWith("Z");

Predicate<String> startsWithAAndEndsWithZ = startsWithA.and(endsWithZ);
Predicate<String> startsWithAOrEndsWithZ = startsWithA.or(endsWithZ);
Predicate<String> notStartsWithA = startsWithA.negate();

// Real usage - filtering
List<String> names = Arrays.asList("Alice", "Bob", "Alex", "Charlie");
names.stream()
     .filter(name -> name.startsWith("A"))
     .forEach(System.out::println);  // Alice, Alex

// Removing from collection
List<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
numbers.removeIf(n -> n % 2 == 0);  // Remove evens: [1, 3, 5]
```

### **5.4 Function<T, R>**

> **Concept:** Takes one input, returns a result. Can transform input to output.

```java
@FunctionalInterface
public interface Function<T, R> {
    R apply(T t);
}

// Examples
Function<String, Integer> lengthFunction = s -> s.length();
Integer len = lengthFunction.apply("Hello");  // 5

Function<String, String> upperCase = s -> s.toUpperCase();
String upper = upperCase.apply("hello");  // "HELLO"

Function<Integer, String> intToString = i -> "Number: " + i;
String str = intToString.apply(42);  // "Number: 42"

// Chaining functions
Function<String, String> trim = s -> s.trim();
Function<String, Integer> length = s -> s.length();
Function<String, Integer> trimmedLength = trim.andThen(length);  // compose
// Or: length.compose(trim)

int result = trimmedLength.apply("  Hello  ");  // 5

// Identity function
Function<String, String> identity = Function.identity();
// Same as: s -> s

// Real usage
Map<String, Integer> nameLengths = names.stream()
    .collect(Collectors.toMap(
        Function.identity(),  // Key is the name itself
        s -> s.length()       // Value is length
    ));
```

### **5.5 UnaryOperator<T>**

> **Concept:** Special case of Function where input and output are the same type.

```java
@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {
    // Inherits apply(T t)
}

// Examples
UnaryOperator<String> toUpperCase = s -> s.toUpperCase();
String result = toUpperCase.apply("hello");  // "HELLO"

UnaryOperator<Integer> square = x -> x * x;
int squared = square.apply(5);  // 25

UnaryOperator<List<String>> reverseList = list -> {
    Collections.reverse(list);
    return list;
};

// Identity
UnaryOperator<String> identity = UnaryOperator.identity();

// Chaining
UnaryOperator<String> trim = s -> s.trim();
UnaryOperator<String> upper = s -> s.toUpperCase();
UnaryOperator<String> process = trim.andThen(upper);
String res = process.apply("  hello  ");  // "HELLO"

// Real usage - replaceAll
List<String> words = Arrays.asList("apple", "banana", "cherry");
words.replaceAll(s -> s.toUpperCase());
// words = ["APPLE", "BANANA", "CHERRY"]
```

### **5.6 BinaryOperator<T>**

> **Concept:** Special case of BiFunction where both inputs and output are same type.

```java
@FunctionalInterface
public interface BinaryOperator<T> extends BiFunction<T, T, T> {
    T apply(T t1, T t2);
}

// Examples
BinaryOperator<Integer> add = (a, b) -> a + b;
int sum = add.apply(5, 3);  // 8

BinaryOperator<Integer> max = (a, b) -> a > b ? a : b;
int maximum = max.apply(5, 3);  // 5

BinaryOperator<String> concat = (s1, s2) -> s1 + s2;
String combined = concat.apply("Hello", " World");  // "Hello World"

// Min and max by comparator
BinaryOperator<Integer> minBy = BinaryOperator.minBy(Integer::compare);
BinaryOperator<Integer> maxBy = BinaryOperator.maxBy(Integer::compare);

// Real usage - reduce
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
int total = numbers.stream().reduce(0, (a, b) -> a + b);  // 15
```

### **5.7 BiFunction<T, U, R>**

> **Concept:** Takes two inputs, returns a result.

```java
@FunctionalInterface
public interface BiFunction<T, U, R> {
    R apply(T t, U u);
}

// Examples
BiFunction<String, String, Integer> compareLength = (s1, s2) ->
    s1.length() - s2.length();
int diff = compareLength.apply("Hello", "World");  // 0

BiFunction<Integer, Integer, String> sumToString = (a, b) ->
    "Sum: " + (a + b);
String result = sumToString.apply(5, 3);  // "Sum: 8"

BiFunction<Map<String, Integer>, String, Integer> getOrDefault =
    (map, key) -> map.getOrDefault(key, 0);

// Chaining with andThen
BiFunction<String, String, String> concat = (s1, s2) -> s1 + s2;
Function<String, Integer> length = s -> s.length();
BiFunction<String, String, Integer> concatLength = concat.andThen(length);

int len = concatLength.apply("Hello", "World");  // 10
```

### **5.8 BiConsumer<T, U>**

> **Concept:** Takes two inputs, returns no result.

```java
@FunctionalInterface
public interface BiConsumer<T, U> {
    void accept(T t, U u);
}

// Examples
BiConsumer<String, Integer> printEntry = (key, value) ->
    System.out.println(key + "=" + value);
printEntry.accept("age", 30);  // age=30

BiConsumer<Map<String, Integer>, String> incrementValue = (map, key) ->
    map.merge(key, 1, Integer::sum);

// Chaining
BiConsumer<String, Integer> print = (k, v) -> System.out.print(k + ":" + v);
BiConsumer<String, Integer> println = (k, v) -> System.out.println(" - done");
BiConsumer<String, Integer> combined = print.andThen(println);
combined.accept("count", 5);  // count:5 - done

// Real usage - Map.forEach
Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
map.put("B", 2);
map.forEach((key, value) -> System.out.println(key + "=" + value));
```

### **5.9 BiPredicate<T, U>**

> **Concept:** Takes two inputs, returns boolean.

```java
@FunctionalInterface
public interface BiPredicate<T, U> {
    boolean test(T t, U u);
}

// Examples
BiPredicate<String, Integer> lengthEquals = (s, len) -> s.length() == len;
boolean result1 = lengthEquals.test("Hello", 5);  // true
boolean result2 = lengthEquals.test("Hi", 5);     // false

BiPredicate<Integer, Integer> bothPositive = (a, b) -> a > 0 && b > 0;
boolean res = bothPositive.test(5, -3);  // false

BiPredicate<Map<String, Integer>, String> containsKey =
    (map, key) -> map.containsKey(key);

// Combining
BiPredicate<String, String> startsWith = String::startsWith;
BiPredicate<String, String> endsWith = String::endsWith;
BiPredicate<String, String> startsAndEnds = startsWith.and(endsWith);
BiPredicate<String, String> startsOrEnds = startsWith.or(endsWith);
BiPredicate<String, String> notStartsWith = startsWith.negate();
```

### **5.10 Summary Table**

| Interface             | Input | Output  | Method      | Use Case               |
| --------------------- | ----- | ------- | ----------- | ---------------------- |
| **Consumer<T>**       | 1     | void    | accept(T)   | Printing, side effects |
| **Supplier<T>**       | 0     | T       | get()       | Factory, lazy init     |
| **Predicate<T>**      | 1     | boolean | test(T)     | Filtering              |
| **Function<T,R>**     | 1     | R       | apply(T)    | Transformation         |
| **UnaryOperator<T>**  | 1     | T       | apply(T)    | Same type operation    |
| **BinaryOperator<T>** | 2     | T       | apply(T,T)  | Reduction              |
| **BiFunction<T,U,R>** | 2     | R       | apply(T,U)  | Combine two inputs     |
| **BiConsumer<T,U>**   | 2     | void    | accept(T,U) | Map iteration          |
| **BiPredicate<T,U>**  | 2     | boolean | test(T,U)   | Two-value condition    |

---

## **6. METHOD REFERENCES**

> **Concept:** Shorthand syntax for lambda when you're just calling an existing method.

### **Syntax: `ClassName::methodName` or `instance::methodName`**

### **Types of Method References**

```java
// 1. Static method reference
Function<String, Integer> parseInt1 = s -> Integer.parseInt(s);
Function<String, Integer> parseInt2 = Integer::parseInt;  // Static method

// 2. Instance method of a particular object
List<String> list = Arrays.asList("a", "b", "c");
Consumer<String> printer1 = s -> System.out.println(s);
Consumer<String> printer2 = System.out::println;  // Instance method

// 3. Instance method of an arbitrary object of a particular type
Function<String, String> toUpper1 = s -> s.toUpperCase();
Function<String, String> toUpper2 = String::toUpperCase;  // Arbitrary object

// 4. Constructor reference
Supplier<List<String>> supplier1 = () -> new ArrayList<>();
Supplier<List<String>> supplier2 = ArrayList::new;  // Constructor
```

### **Examples**

```java
// Static method reference
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
numbers.stream()
       .map(String::valueOf)  // static method
       .forEach(System.out::println);

// Instance method of particular object
List<String> names = Arrays.asList("Alice", "Bob");
names.forEach(System.out::println);  // System.out instance

// Instance method of arbitrary object
List<String> words = Arrays.asList("apple", "banana", "cherry");
words.stream()
     .map(String::toUpperCase)  // method of arbitrary String
     .forEach(System.out::println);

// Constructor reference
Supplier<List<String>> listSupplier = ArrayList::new;
List<String> newList = listSupplier.get();

Function<char[], String> stringCreator = String::new;
String str = stringCreator.apply(new char[]{'H','i'});

// Multiple parameters
BiFunction<String, String, Boolean> equals = String::equals;
boolean same = equals.apply("Hi", "Hi");  // true

// Array constructor reference
IntFunction<int[]> arrayCreator = int[]::new;
int[] arr = arrayCreator.apply(5);  // new int[5]
```

---

## **7. CONSTRUCTOR REFERENCES**

> **Concept:** Special type of method reference that creates new objects.

```java
// 1. No-arg constructor
Supplier<List<String>> listSupplier = ArrayList::new;
List<String> list = listSupplier.get();

// 2. Constructor with one argument
Function<String, Integer> intConstructor = Integer::new;
Integer num = intConstructor.apply("123");

Function<String, File> fileCreator = File::new;
File f = fileCreator.apply("test.txt");

// 3. Constructor with multiple arguments
BiFunction<String, Integer, Person> personCreator = Person::new;
Person p = personCreator.apply("Alice", 30);

// 4. Array constructor
IntFunction<int[]> intArray = int[]::new;
int[] arr = intArray.apply(10);  // new int[10]

IntFunction<String[]> stringArray = String[]::new;
String[] strArr = stringArray.apply(5);

// 5. Using with streams
List<String> nameList = Arrays.asList("Alice", "Bob", "Charlie");
Stream<Person> personStream = nameList.stream()
    .map(name -> new Person(name));  // lambda
// or
Stream<Person> personStream2 = nameList.stream()
    .map(Person::new);  // constructor reference (if Person has String constructor)
```

---

## **8. VARIABLE CAPTURE (EFFECTIVELY FINAL)**

> **Concept:** Lambdas can access variables from enclosing scope, but they must be effectively final.

```java
// Effectively final - variable not changed after initialization
int localVar = 10;  // Effectively final
Runnable r = () -> System.out.println(localVar);
r.run();  // 10

// Cannot modify captured variable
int counter = 0;
Runnable bad = () -> {
    // counter++;  // ❌ Compile error! Cannot modify
    System.out.println(counter);
};

// Cannot use non-final variable
int value = 5;
// value = 6;  // If uncommented, lambda below fails
Runnable r2 = () -> System.out.println(value);  // Must be effectively final

// Instance variables can be modified
class Example {
    private int instanceVar = 10;

    public void test() {
        Runnable r = () -> {
            instanceVar++;  // OK - instance variables can be modified
            System.out.println(instanceVar);
        };
    }
}

// Static variables can be modified
class StaticExample {
    private static int staticVar = 10;

    public void test() {
        Runnable r = () -> {
            staticVar++;  // OK - static variables can be modified
            System.out.println(staticVar);
        };
    }
}

// Array trick (modify array content, not reference)
int[] array = {10};
Runnable r3 = () -> {
    array[0]++;  // OK - modifying array content, not reference
    System.out.println(array[0]);
};
```

---

## **9. SCOPE IN LAMBDAS**

> **Concept:** Lambdas don't introduce a new scope; they have the same scope as enclosing block.

```java
public class LambdaScope {
    private String instanceVar = "Instance";
    private static String staticVar = "Static";

    public void test() {
        String localVar = "Local";

        // Shadowing - lambda parameter can shadow local variable?
        // Consumer<String> c = localVar -> {  // ❌ Not allowed!
        //     System.out.println(localVar);
        // };

        // Cannot redeclare local variable
        // String localVar = "Another";  // ❌ Already defined

        // 'this' in lambda refers to enclosing instance
        Runnable r = () -> {
            System.out.println(this.instanceVar);  // Refers to LambdaScope.this
            System.out.println(staticVar);         // Static variable
            System.out.println(localVar);          // Local variable
        };

        // Anonymous class comparison
        Runnable anon = new Runnable() {
            @Override
            public void run() {
                System.out.println(this);  // Refers to anonymous class instance
                // System.out.println(localVar);  // Need to be final
            }
        };
    }
}
```

---

## **10. TYPE INFERENCE**

> **Concept:** Compiler can infer parameter types, so you can omit them in many cases.

```java
// Explicit types
Comparator<Integer> comp1 = (Integer a, Integer b) -> a.compareTo(b);

// Inferred types (most common)
Comparator<Integer> comp2 = (a, b) -> a.compareTo(b);

// In assignment context
Function<String, Integer> f = s -> s.length();  // Compiler knows s is String

// In method arguments
List<String> list = Arrays.asList("a", "b", "c");
list.sort((a, b) -> a.compareTo(b));  // Compiler knows a,b are String

// In return statements
public static <T> Comparator<T> reverseComparator() {
    return (a, b) -> ((Comparable<T>) a).compareTo(b) * -1;
}

// Complex inference
Map<String, List<Integer>> map = new HashMap<>();
map.computeIfAbsent("key", k -> new ArrayList<>());  // k is String

// Cannot always infer - need explicit types
BinaryOperator<Integer> sum = (x, y) -> x + y;  // OK
// BinaryOperator<Integer> sum = (x, y) -> x + y;  // Could be ambiguous

// Generic methods need care
public static <T> T identity(T t) { return t; }
String s = identity("Hello");  // OK - T inferred as String
// Compiler needs target type
```

---

## **11. LAMBDA AND EXCEPTION HANDLING**

> **Concept:** Lambdas follow normal exception rules but have limitations with checked exceptions.

```java
// 1. Checked exceptions - need to handle or wrap
List<String> files = Arrays.asList("file1.txt", "file2.txt");

// ❌ Won't compile - readFile throws IOException
// files.forEach(file -> readFile(file));

// ✅ Handle inside lambda
files.forEach(file -> {
    try {
        readFile(file);
    } catch (IOException e) {
        e.printStackTrace();
    }
});

// ✅ Wrap in unchecked exception
files.forEach(file -> {
    try {
        readFile(file);
    } catch (IOException e) {
        throw new RuntimeException(e);
    }
});

// ✅ Custom functional interface that allows checked exceptions
@FunctionalInterface
interface ThrowingConsumer<T> {
    void accept(T t) throws Exception;
}

static <T> Consumer<T> throwingConsumerWrapper(ThrowingConsumer<T> throwingConsumer) {
    return t -> {
        try {
            throwingConsumer.accept(t);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    };
}

// Usage
files.forEach(throwingConsumerWrapper(file -> readFile(file)));

// 2. Unchecked exceptions - propagate normally
List<Integer> numbers = Arrays.asList(1, 2, 3, 0, 4);
numbers.forEach(n -> {
    if (n == 0) {
        throw new ArithmeticException("Zero found");  // Propagates
    }
    System.out.println(10 / n);
});

// 3. Custom exception handling in streams
Stream.of("1", "2", "a", "3")
    .map(s -> {
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    })
    .filter(Objects::nonNull)
    .forEach(System.out::println);
```

---

## **12. LAMBDA WITH COLLECTIONS**

> **Concept:** Lambda expressions simplify collection operations significantly.

### **12.1 Iteration**

```java
List<String> list = Arrays.asList("Apple", "Banana", "Cherry");

// Before Java 8
for (String s : list) {
    System.out.println(s);
}

// With lambda
list.forEach(s -> System.out.println(s));
list.forEach(System.out::println);  // Method reference

// With index (using IntStream)
IntStream.range(0, list.size())
    .forEach(i -> System.out.println(i + ": " + list.get(i)));
```

### **12.2 Sorting**

```java
List<String> names = Arrays.asList("Charlie", "Alice", "Bob");

// Before Java 8
Collections.sort(names, new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return a.compareTo(b);
    }
});

// With lambda
Collections.sort(names, (a, b) -> a.compareTo(b));

// Even simpler
names.sort((a, b) -> a.compareTo(b));
names.sort(Comparator.naturalOrder());
names.sort(String::compareTo);

// Reverse order
names.sort((a, b) -> b.compareTo(a));
names.sort(Comparator.reverseOrder());

// Multiple criteria
List<Person> people = getPeople();
people.sort(Comparator.comparing(Person::getLastName)
    .thenComparing(Person::getFirstName));
```

### **12.3 Filtering**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6);

// Remove elements that match condition
numbers.removeIf(n -> n % 2 == 0);  // Remove evens

// Replace all elements
numbers.replaceAll(n -> n * 2);  // Double each element

// Using streams (non-modifying)
List<Integer> evens = numbers.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());

// Map transformation
List<String> strings = numbers.stream()
    .map(n -> "Number: " + n)
    .collect(Collectors.toList());
```

### **12.4 Map Operations**

```java
Map<String, Integer> map = new HashMap<>();
map.put("A", 1);
map.put("B", 2);

// Iterate
map.forEach((k, v) -> System.out.println(k + "=" + v));

// Compute if absent
map.computeIfAbsent("C", k -> k.length());  // Adds C=1

// Compute if present
map.computeIfPresent("A", (k, v) -> v * 10);  // Updates A=10

// Merge
map.merge("A", 5, (oldVal, newVal) -> oldVal + newVal);  // A=15

// Replace all
map.replaceAll((k, v) -> v * 2);

// Get with default
int value = map.getOrDefault("Z", 0);  // 0
```

### **12.5 List ReplaceAll**

```java
List<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));

// Apply function to each element
numbers.replaceAll(n -> n * n);  // [1, 4, 9, 16, 25]

List<String> words = new ArrayList<>(Arrays.asList("apple", "banana"));
words.replaceAll(s -> s.toUpperCase());  // ["APPLE", "BANANA"]
```

---

## **13. LAMBDA WITH STREAMS API**

> **Concept:** Streams API heavily uses lambdas for functional-style operations on collections.

### **13.1 Stream Pipeline**

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David", "Alex");

List<String> result = names.stream()
    .filter(name -> name.startsWith("A"))           // Predicate
    .map(name -> name.toUpperCase())                // Function
    .sorted((a, b) -> a.compareTo(b))               // Comparator
    .collect(Collectors.toList());                  // ["ALEX", "ALICE"]

System.out.println(result);
```

### **13.2 Common Stream Operations**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// filter - keep elements matching predicate
List<Integer> evens = numbers.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());  // [2,4,6,8,10]

// map - transform elements
List<String> numberStrs = numbers.stream()
    .map(n -> "Num:" + n)
    .collect(Collectors.toList());

// flatMap - flatten nested structures
List<List<Integer>> nested = Arrays.asList(
    Arrays.asList(1, 2),
    Arrays.asList(3, 4),
    Arrays.asList(5, 6)
);
List<Integer> flattened = nested.stream()
    .flatMap(list -> list.stream())
    .collect(Collectors.toList());  // [1,2,3,4,5,6]

// distinct - remove duplicates
List<Integer> distinct = numbers.stream()
    .distinct()
    .collect(Collectors.toList());

// sorted - sort elements
List<Integer> sorted = numbers.stream()
    .sorted((a, b) -> b - a)  // descending
    .collect(Collectors.toList());

// peek - perform action without changing stream
List<Integer> peeked = numbers.stream()
    .peek(n -> System.out.println("Processing: " + n))
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());

// limit - first n elements
List<Integer> first3 = numbers.stream()
    .limit(3)
    .collect(Collectors.toList());  // [1,2,3]

// skip - skip first n elements
List<Integer> after5 = numbers.stream()
    .skip(5)
    .collect(Collectors.toList());  // [6,7,8,9,10]
```

### **13.3 Terminal Operations**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// forEach
numbers.stream().forEach(n -> System.out.println(n));

// collect
List<Integer> list = numbers.stream()
    .collect(Collectors.toList());

Set<Integer> set = numbers.stream()
    .collect(Collectors.toSet());

Map<String, Integer> map = numbers.stream()
    .collect(Collectors.toMap(
        n -> "Key" + n,   // key mapper
        n -> n             // value mapper
    ));

// reduce - combine elements
int sum = numbers.stream()
    .reduce(0, (a, b) -> a + b);  // 15

Optional<Integer> product = numbers.stream()
    .reduce((a, b) -> a * b);  // 120

// count
long count = numbers.stream()
    .filter(n -> n > 3)
    .count();  // 2

// anyMatch / allMatch / noneMatch
boolean anyEven = numbers.stream().anyMatch(n -> n % 2 == 0);
boolean allPositive = numbers.stream().allMatch(n -> n > 0);
boolean noneNegative = numbers.stream().noneMatch(n -> n < 0);

// findFirst / findAny
Optional<Integer> first = numbers.stream()
    .filter(n -> n > 3)
    .findFirst();  // 4

// min / max
Optional<Integer> min = numbers.stream()
    .min((a, b) -> a - b);
Optional<Integer> max = numbers.stream()
    .max(Integer::compare);
```

### **13.4 Grouping and Partitioning**

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25, "NY"),
    new Person("Bob", 30, "LA"),
    new Person("Charlie", 25, "NY"),
    new Person("David", 35, "LA"),
    new Person("Eve", 30, "NY")
);

// Group by age
Map<Integer, List<Person>> byAge = people.stream()
    .collect(Collectors.groupingBy(p -> p.getAge()));

// Group by city, then count
Map<String, Long> countByCity = people.stream()
    .collect(Collectors.groupingBy(
        p -> p.getCity(),
        Collectors.counting()
    ));

// Partition by age > 30
Map<Boolean, List<Person>> partitioned = people.stream()
    .collect(Collect
```
