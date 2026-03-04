# **Complete Java Generics - Interview Ready Reference** 📚

*Your one-stop guide for all Generics concepts with brief explanations and examples*

---

## **📋 TABLE OF CONTENTS**

1. [What are Generics?](#1-what-are-generics)
2. [Why Generics?](#2-why-generics)
3. [Generic Classes](#3-generic-classes)
4. [Generic Methods](#4-generic-methods)
5. [Generic Interfaces](#5-generic-interfaces)
6. [Type Parameters Naming](#6-type-parameters-naming)
7. [Bounded Type Parameters](#7-bounded-type-parameters)
8. [Wildcards](#8-wildcards)
9. [PECS Rule (Producer Extends, Consumer Super)](#9-pecs-rule-producer-extends-consumer-super)
10. [Type Erasure](#10-type-erasure)
11. [Generics Limitations](#11-generics-limitations)
12. [Raw Types](#12-raw-types)
13. [Wildcard vs Type Parameter](#13-wildcard-vs-type-parameter)
14. [Common Interview Questions](#14-common-interview-questions)

---

## **1. WHAT ARE GENERICS?**

> **Concept:** Generics enable types to be parameters when defining classes, interfaces, and methods.

```java
// Without Generics
List list = new ArrayList();
list.add("Hello");
String s = (String) list.get(0);  // Cast needed

// With Generics
List<String> list = new ArrayList<>();
list.add("Hello");
String s = list.get(0);  // No cast, type-safe
```

---

## **2. WHY GENERICS?**

| Benefit | Explanation | Example |
|---------|-------------|---------|
| **Type Safety** | Catch type errors at compile time | `list.add(123)` on `List<String>` fails at compile time |
| **No Casting** | Eliminate explicit casts | `String s = list.get(0)` vs `(String)list.get(0)` |
| **Code Reuse** | Write once, use with any type | `ArrayList<T>` works for any type |

---

## **3. GENERIC CLASSES**

> **Concept:** Class declared with one or more type parameters.

```java
// Single type parameter
public class Box<T> {
    private T content;
    
    public void set(T content) { this.content = content; }
    public T get() { return content; }
}

// Usage
Box<String> stringBox = new Box<>();
stringBox.set("Hello");
String value = stringBox.get();

Box<Integer> intBox = new Box<>();
intBox.set(123);

// Multiple type parameters
public class Pair<K, V> {
    private K key;
    private V value;
    
    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }
    
    public K getKey() { return key; }
    public V getValue() { return value; }
}

// Usage
Pair<String, Integer> pair = new Pair<>("Age", 30);
String key = pair.getKey();
Integer val = pair.getValue();
```

---

## **4. GENERIC METHODS**

> **Concept:** Methods that introduce their own type parameters, independent of the class.

```java
// Generic method in non-generic class
public class Utils {
    // Type parameter <T> before return type
    public static <T> T identity(T value) {
        return value;
    }
    
    public static <T> void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    
    public static <T, U> boolean compare(Pair<T, U> p1, Pair<T, U> p2) {
        return p1.getKey().equals(p2.getKey()) &&
               p1.getValue().equals(p2.getValue());
    }
    
    // Generic varargs
    public static <T> List<T> asList(T... elements) {
        return Arrays.asList(elements);
    }
}

// Usage
String s = Utils.identity("Hello");
Integer i = Utils.identity(123);

String[] names = {"A", "B", "C"};
Utils.swap(names, 0, 2);  // Now ["C", "B", "A"]

List<String> list = Utils.asList("X", "Y", "Z");
```

---

## **5. GENERIC INTERFACES**

> **Concept:** Interfaces that can take type parameters.

```java
// Basic generic interface
public interface Repository<T> {
    void save(T entity);
    T findById(long id);
    List<T> findAll();
}

// Implementation
public class UserRepository implements Repository<User> {
    @Override
    public void save(User user) { /* ... */ }
    
    @Override
    public User findById(long id) { 
        return new User(); 
    }
    
    @Override
    public List<User> findAll() {
        return new ArrayList<>();
    }
}

// Generic interface with multiple types
public interface Pair<K, V> {
    K getKey();
    V getValue();
}

// Interface extending another generic interface
public interface Comparable<T> {
    int compareTo(T o);
}

public interface Sortable<T> extends Comparable<T> {
    void sort();
}
```

---

## **6. TYPE PARAMETERS NAMING CONVENTIONS**

> **Concept:** Standard naming conventions for type parameters.

| Letter | Usage | Example |
|--------|-------|---------|
| **E** | Element (used in collections) | `List<E>` |
| **K** | Key (used in maps) | `Map<K, V>` |
| **V** | Value (used in maps) | `Map<K, V>` |
| **T** | Type (general purpose) | `Box<T>` |
| **N** | Number | `NumberBox<N extends Number>` |
| **S, U, V** | 2nd, 3rd, 4th types | `Triplet<T, U, V>` |

---

## **7. BOUNDED TYPE PARAMETERS**

> **Concept:** Restrict what types can be used as type arguments.

### **Upper Bounds (extends)**

> **Concept:** Type must be a subclass of a specific class or implement specific interfaces.

```java
// Single bound - T must be Number or its subclass
public class NumericBox<T extends Number> {
    private T number;
    
    public NumericBox(T number) {
        this.number = number;
    }
    
    public double doubleValue() {
        return number.doubleValue();  // Can call Number methods
    }
}

// Usage
NumericBox<Integer> intBox = new NumericBox<>(123);
NumericBox<Double> doubleBox = new NumericBox<>(45.67);
// NumericBox<String> stringBox = ...  // ❌ Compile error!

// Multiple bounds - T must extend A and implement B and C
public class MultiBound<T extends Number & Comparable<T> & Serializable> {
    private T data;
    
    public int compareTo(T other) {
        return data.compareTo(other);  // Can call Comparable method
    }
}

// Generic method with bounds
public static <T extends Comparable<T>> T max(T a, T b) {
    return a.compareTo(b) > 0 ? a : b;
}

// Usage
max(10, 20);        // OK - Integer implements Comparable
max("A", "B");      // OK - String implements Comparable
```

### **Lower Bounds (super)**

> **Concept:** Only used with wildcards - type must be a superclass of a specific type.

```java
// ❌ Cannot use 'super' in type parameter declaration
// public class Box<T super Number> { }  // Not allowed!

// ✅ 'super' only with wildcards (see wildcards section)
public void addNumbers(List<? super Integer> list) {
    list.add(123);  // Can add Integer to List<Number>, List<Object>, etc.
}
```

---

## **8. WILDCARDS**

> **Concept:** Unknown type represented by `?` - used for flexibility in method parameters.

### **Unbounded Wildcard (?)**

> **Concept:** Accept any type - used when type doesn't matter for the operation.

```java
public static void printList(List<?> list) {
    // Can only read as Object
    for (Object item : list) {
        System.out.println(item);
    }
    // Cannot add (except null)
    // list.add("A");  // ❌ Compile error!
    list.add(null);     // OK
}

// Usage - accepts any List type
List<String> strings = Arrays.asList("A", "B");
List<Integer> numbers = Arrays.asList(1, 2);
printList(strings);  // OK
printList(numbers);  // OK
```

### **Upper Bounded Wildcard (extends)**

> **Concept:** Accept any type that is a subclass of a specific type - used for reading.

```java
public static double sum(List<? extends Number> numbers) {
    double total = 0.0;
    for (Number n : numbers) {  // Read as Number
        total += n.doubleValue();
    }
    return total;
    // Cannot add - list.add(123);  // ❌
}

// Usage
List<Integer> ints = Arrays.asList(1, 2, 3);
List<Double> doubles = Arrays.asList(1.5, 2.5);
sum(ints);     // OK
sum(doubles);  // OK
```

### **Lower Bounded Wildcard (super)**

> **Concept:** Accept any type that is a superclass of a specific type - used for writing.

```java
public static void addNumbers(List<? super Integer> list) {
    for (int i = 1; i <= 10; i++) {
        list.add(i);  // Can add Integer
    }
    // When reading, you get Object
    Object obj = list.get(0);
    // Integer num = list.get(0);  // ❌ - not safe
}

// Usage
List<Number> numbers = new ArrayList<>();
List<Object> objects = new ArrayList<>();
List<Integer> integers = new ArrayList<>();  // Also works (Integer is super of itself)

addNumbers(numbers);   // OK - Number is super of Integer
addNumbers(objects);   // OK - Object is super of Integer
addNumbers(integers);  // OK - Integer is super of itself
```

---

## **9. PECS RULE (Producer Extends, Consumer Super)**

> **Concept:** When to use `extends` vs `super` wildcards.

| Scenario | Use | Explanation | Example |
|----------|-----|-------------|---------|
| **Producer** (reading) | `? extends T` | When you **get** values from structure | `copy(src, dest)` where src produces |
| **Consumer** (writing) | `? super T` | When you **put** values into structure | `copy(src, dest)` where dest consumes |

```java
// Producer Extends - reading from src
public static <T> void copy(List<? extends T> src, List<? super T> dest) {
    for (T item : src) {     // src PRODUCES T (use extends)
        dest.add(item);      // dest CONSUMES T (use super)
    }
}

// Usage
List<Integer> ints = Arrays.asList(1, 2, 3);
List<Number> nums = new ArrayList<>();
copy(ints, nums);  // ints produces Integers, nums consumes Numbers

// Real-world example: Collections.copy()
public static <T> void copy(List<? super T> dest, List<? extends T> src) {
    // Note: Collections.copy has opposite parameter order!
}

// Another example
public static <T> void fill(List<? super T> list, T item) {
    for (int i = 0; i < list.size(); i++) {
        list.set(i, item);  // list CONSUMES T (use super)
    }
}

public static <T> T max(List<? extends T> list, Comparator<T> cmp) {
    // list PRODUCES T (use extends)
    return list.stream().max(cmp).get();
}
```

---

## **10. TYPE ERASURE**

> **Concept:** Compiler removes all generic type information, replacing with Object or bounds.

```java
// Compile time
List<String> strings = new ArrayList<>();
List<Integer> integers = new ArrayList<>();

// Runtime - both become just ArrayList (no generic info!)
// strings and integers are both ArrayList at runtime

// What happens during erasure
public class Box<T> {
    private T content;
    public T get() { return content; }
}
// After erasure (roughly)
public class Box {
    private Object content;  // T replaced with Object
    public Object get() { return content; }
}

// With bounds
public class NumericBox<T extends Number> {
    private T number;
    public double doubleValue() { return number.doubleValue(); }
}
// After erasure
public class NumericBox {
    private Number number;  // T replaced with Number (bound)
    public double doubleValue() { return number.doubleValue(); }
}

// Bridge methods - compiler generates for polymorphism
public class MyList implements List<String> {
    public boolean add(String e) { /*...*/ }
}
// After erasure + bridge
public class MyList implements List {
    public boolean add(String e) { /*...*/ }  // Original
    public boolean add(Object e) {            // Bridge method
        return add((String) e);                // Casts to String
    }
}
```

---

## **11. GENERICS LIMITATIONS**

| Limitation | Explanation | Example |
|------------|-------------|---------|
| **No Primitives** | Cannot use primitive types | `List<int>` ❌, use `List<Integer>` ✅ |
| **No Generic Arrays** | Cannot create arrays of generic types | `new T[10]` ❌, `new List<String>[10]` ❌ |
| **No Instantiation** | Cannot create instances of type parameters | `new T()` ❌ |
| **No Static Fields of T** | Static fields cannot use class type parameters | `static T count;` ❌ |
| **Cannot Use instanceof** | Can't check generic types at runtime | `list instanceof List<String>` ❌ |
| **Cannot Throw/Catch Generic Types** | Cannot use generics in catch blocks | `catch (MyException<T> e)` ❌ |
| **Cannot Create Generic Exception Classes** | Exception classes cannot be generic | `class MyException<T> extends Exception` ❌ |

```java
public class Limitations<T> {
    // ❌ No primitives
    // List<int> ints = new ArrayList<>();
    List<Integer> ints = new ArrayList<>();  // ✅ Use wrapper
    
    // ❌ No generic array creation
    // T[] array = new T[10];
    // List<String>[] array = new List<String>[10];
    
    // Workaround for generic array
    @SuppressWarnings("unchecked")
    public T[] createArray(Class<T> clazz, int size) {
        return (T[]) Array.newInstance(clazz, size);
    }
    
    // ❌ No instantiation
    // T obj = new T();
    
    // ❌ No static fields of T
    // static T staticField;
    
    // ❌ Cannot use instanceof
    // if (list instanceof List<String>) { }
    if (list instanceof List<?>) { }  // ✅ OK
    
    // ❌ Cannot create generic exception
    // class MyException<T> extends Exception { }
}
```

---

## **12. RAW TYPES**

> **Concept:** Using a generic class without type parameters - for backward compatibility only.

```java
// Generic class
List<String> strings = new ArrayList<>();  // Parameterized type (good)

// Raw type (BAD - avoid!)
List list = new ArrayList();  // Raw type
list.add("Hello");
list.add(123);  // Can add any type - type safety lost!

String s = (String) list.get(0);  // Need cast
// String s2 = (String) list.get(1);  // Runtime ClassCastException!

// Why raw types exist? Backward compatibility with pre-Java 5 code
// Always avoid raw types in new code!

// Compiler warning when using raw types
List rawList = new ArrayList();  // Warning: unchecked conversion
List<String> strings = new ArrayList();
List raw = strings;  // OK - assigning parameterized to raw (warning)
```

---

## **13. WILDCARD VS TYPE PARAMETER**

> **Concept:** When to use wildcards vs explicit type parameters.

```java
// Use wildcard when:
// 1. Method only reads from structure
// 2. Type parameter appears only once
// 3. You don't need to refer to the type

// Use type parameter when:
// 1. You need to refer to the type multiple times
// 2. You have dependencies between parameters
// 3. You need to return the type

// Example 1: Wildcard sufficient
public static void printList(List<?> list) {
    // Type appears only once, only reading
    for (Object o : list) System.out.println(o);
}

// Example 2: Type parameter needed
public static <T> void swap(List<T> list, int i, int j) {
    // Need to refer to T multiple times
    T temp = list.get(i);
    list.set(i, list.get(j));
    list.set(j, temp);
}

// Example 3: Dependencies between parameters
public static <T> void copy(List<? extends T> src, List<? super T> dest) {
    // T appears in both bounds - need type parameter
    for (T item : src) dest.add(item);
}

// Example 4: Return type uses the type
public static <T> List<T> reverse(List<T> list) {
    // Need T for return type
    List<T> result = new ArrayList<>();
    for (int i = list.size() - 1; i >= 0; i--) {
        result.add(list.get(i));
    }
    return result;
}
```

---

## **14. COMMON INTERVIEW QUESTIONS**

| Question | Answer |
|----------|--------|
| **What are generics?** | Enable types to be parameters when defining classes, interfaces, and methods |
| **Why use generics?** | Type safety (compile-time checks), no casting, code reuse |
| **What is type erasure?** | Compiler removes generic info, replaces with Object or bounds; generics don't exist at runtime |
| **What is wildcard?** | `?` represents unknown type; provides flexibility in method parameters |
| **What is bounded wildcard?** | `? extends T` (upper bound) or `? super T` (lower bound) restricts allowed types |
| **What is PECS rule?** | Producer Extends, Consumer Super - use extends when reading, super when writing |
| **Can you create generic array?** | No - due to type erasure and array covariance; use collections instead |
| **Can you use primitives?** | No - use wrapper classes (Integer, Double, etc.) |
| **What are bridge methods?** | Compiler-generated methods to maintain polymorphism after erasure |
| **What is raw type?** | Generic class used without type parameters (e.g., `List` instead of `List<String>`) - avoid! |
| **Difference between `List<T>`, `List<?>`, `List<Object>`?** | `List<T>`: specific type parameter; `List<?>`: unknown type; `List<Object>`: specifically Object type |
| **Can generic method be static?** | Yes - type parameter is method-specific, not class-level |
| **What is multiple bounding?** | `<T extends Number & Comparable<T>>` - T must extend Number AND implement Comparable |
| **Can you use `super` in type parameter declaration?** | No - `super` only with wildcards, not in class/method type parameters |
| **What is recursive type bound?** | Type bound that refers to itself, e.g., `<T extends Comparable<T>>` |

---

## **🚀 QUICK REFERENCE CHEAT SHEET**

```java
// Generic class
class Box<T> { T get(); void set(T t); }

// Generic method
<T> T identity(T t) { return t; }

// Multiple type parameters
class Pair<K, V> { K getKey(); V getValue(); }

// Bounded type
<T extends Number> double toDouble(T t) { return t.doubleValue(); }

// Multiple bounds
<T extends Number & Comparable<T>> int compare(T a, T b) { return a.compareTo(b); }

// Unbounded wildcard
void print(List<?> list) { for (Object o : list) System.out.println(o); }

// Upper bounded wildcard
double sum(List<? extends Number> list) { double s=0; for (Number n: list) s+=n.doubleValue(); return s; }

// Lower bounded wildcard
void addInts(List<? super Integer> list) { for (int i=0; i<10; i++) list.add(i); }

// PECS rule
<T> void copy(List<? extends T> src, List<? super T> dest) { for (T t: src) dest.add(t); }

// Type token (workaround for erasure)
<T> T create(Class<T> clazz) throws Exception { return clazz.getDeclaredConstructor().newInstance(); }
```

---

## **📝 KEY TAKEAWAYS FOR INTERVIEW**

1. **Generics = compile-time safety**
2. **Type erasure = generics disappear at runtime**
3. **Wildcards = API flexibility**
4. **PECS = remember extends/super direction**
5. **No generic arrays, no primitives**
6. **Bridge methods = compiler magic for polymorphism**
7. **Raw types = avoid at all costs!**
8. **`super` only with wildcards, never in type parameter declaration**

---

*Good luck with your interview! 🎉*