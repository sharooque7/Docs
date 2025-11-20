### **Introducing Generics: Summary Notes**

#### **Core Concept**
*   **Generics** allow types (classes, interfaces) to be **parameters** when defining classes, interfaces, and methods.
*   **Analogous to method parameters** but for types instead of values.
*   Enables code reusability with different type inputs while maintaining type safety.

---

### **1. Benefits of Generics**

| Benefit | Without Generics | With Generics |
|---------|------------------|---------------|
| **Type Safety** | Runtime errors | ✅ Compile-time type checking |
| **Casting** | Manual casting required | ✅ No casting needed |
| **Code Reuse** | Limited | ✅ Generic algorithms |

**Example: Elimination of Casts**
```java
// Without Generics
List list = new ArrayList();
list.add("hello");
String s = (String) list.get(0);  // Cast required

// With Generics
List<String> list = new ArrayList<>();
list.add("hello");
String s = list.get(0);  // No cast needed
```

---

### **2. Generic Types**

#### **Basic Generic Class Syntax**
```java
class ClassName<T1, T2, ..., Tn> { /* ... */ }
```

#### **Example: Simple Box Class**
```java
// Non-generic version (unsafe)
public class Box {
    private Object object;
    public void set(Object object) { this.object = object; }
    public Object get() { return object; }
}

// Generic version (type-safe)
public class Box<T> {
    private T t;
    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```

#### **Type Parameter Naming Conventions**
*   **E** - Element (used in collections)
*   **K** - Key
*   **N** - Number
*   **T** - Type
*   **V** - Value
*   **S, U, V** - 2nd, 3rd, 4th types

---

### **3. Using Generic Types**

#### **Instantiating Generic Classes**
```java
// Declaration
Box<Integer> integerBox;

// Instantiation (pre-Java 7)
Box<Integer> integerBox = new Box<Integer>();

// Instantiation with Diamond (Java 7+)
Box<Integer> integerBox = new Box<>();
```

#### **Multiple Type Parameters**
```java
public interface Pair<K, V> {
    public K getKey();
    public V getValue();
}

public class OrderedPair<K, V> implements Pair<K, V> {
    private K key;
    private V value;
    
    public OrderedPair(K key, V value) {
        this.key = key;
        this.value = value;
    }
    
    public K getKey() { return key; }
    public V getValue() { return value; }
}

// Usage
OrderedPair<String, Integer> p1 = new OrderedPair<>("Even", 8);
OrderedPair<String, String> p2 = new OrderedPair<>("hello", "world");
```

#### **Nested Parameterized Types**
```java
OrderedPair<String, Box<Integer>> p = 
    new OrderedPair<>("primes", new Box<Integer>());
```

---

### **4. Raw Types (Avoid!)**

#### **What are Raw Types?**
*   Using generic classes **without type parameters**
*   **Backward compatibility** feature from pre-JDK 5.0

```java
Box rawBox = new Box();          // Raw type - DON'T DO THIS!
Box<String> stringBox = new Box<>();

// Allowed but generates warnings
rawBox = stringBox;              // OK
Box<Integer> intBox = rawBox;    // Warning: unchecked conversion
rawBox.set(8);                   // Warning: unchecked invocation
```

**⚠️ Warning:** Raw types bypass generic type checks, making code unsafe.

---

### **5. Generic Methods**

#### **Syntax**
```java
public class Util {
    public static <K, V> boolean compare(Pair<K, V> p1, Pair<K, V> p2) {
        return p1.getKey().equals(p2.getKey()) &&
               p1.getValue().equals(p2.getValue());
    }
}
```

#### **Invocation**
```java
// Explicit type specification
boolean same = Util.<Integer, String>compare(p1, p2);

// Type inference (preferred)
boolean same = Util.compare(p1, p2);
```

---

### **6. Bounded Type Parameters**

#### **Single Bound**
```java
// Restricts T to Number and its subclasses
public <U extends Number> void inspect(U u) {
    // Can safely call Number methods on u
}

// Usage
Box<Integer> integerBox = new Box<>();
integerBox.inspect(10);     // OK
integerBox.inspect("text"); // Compile error!
```

#### **Multiple Bounds**
```java
// T must extend ClassA AND implement InterfaceB and InterfaceC
class ClassD <T extends ClassA & InterfaceB & InterfaceC> { 
    /* ... */ 
}

// Class must come first!
class ClassD <T extends InterfaceB & ClassA & InterfaceC> { // COMPILE ERROR!
    /* ... */ 
}
```

#### **Practical Example: Comparable Bounds**
```java
// Without bound - doesn't compile
public static <T> int countGreaterThan(T[] array, T elem) {
    int count = 0;
    for (T e : array)
        if (e > elem)  // ERROR: > not applicable to objects
            ++count;
    return count;
}

// With bound - works!
public static <T extends Comparable<T>> int countGreaterThan(T[] array, T elem) {
    int count = 0;
    for (T e : array)
        if (e.compareTo(elem) > 0)  // OK: T has compareTo()
            ++count;
    return count;
}
```

---

### **7. Generics and Inheritance**

#### **Important Concept: Invariance**
```java
// This works - Integer is a subtype of Object
Object obj = new Integer(10);  // OK

// This DOESN'T work - Box<Integer> is NOT a subtype of Box<Object>
Box<Number> numberBox = new Box<Number>();
Box<Integer> integerBox = new Box<Integer>();

numberBox = integerBox;  // COMPILE ERROR!
```

**Reason:** `Box<Integer>` and `Box<Number>` have no inheritance relationship, even though `Integer` extends `Number`.

#### **Generic Class Inheritance**
```java
// ArrayList<String> is a subtype of List<String> 
// which is a subtype of Collection<String>
ArrayList<String> → List<String> → Collection<String>

// Custom example with multiple type parameters
interface PayloadList<E, P> extends List<E> {
    void setPayload(int index, P val);
}

// These are all subtypes of List<String>:
PayloadList<String, String>
PayloadList<String, Integer> 
PayloadList<String, Exception>
```

---

### **Quick Reference Table**

| Concept | Syntax | Example |
|---------|--------|---------|
| **Generic Class** | `class Name<T>` | `class Box<T>` |
| **Multiple Parameters** | `class Name<K, V>` | `class Pair<K, V>` |
| **Generic Method** | `<T> returnType method()` | `<T> boolean compare(T a, T b)` |
| **Bounded Parameter** | `<T extends UpperBound>` | `<T extends Number>` |
| **Multiple Bounds** | `<T extends A & B & C>` | `<T extends ClassA & InterfaceB>` |
| **Diamond Operator** | `new ClassName<>()` | `new ArrayList<>()` |

---

### **Key Takeaways**

1. **Use generics for type safety** - Catch errors at compile time rather than runtime
2. **Avoid raw types** - They bypass type checks and generate warnings
3. **Leverage type inference** - Use diamond operator and let compiler infer types
4. **Use bounds for constraints** - Restrict what types can be used with `extends`
5. **Understand invariance** - `Box<Integer>` is not a `Box<Number>` even though `Integer` is a `Number`
6. **Follow naming conventions** - Use standard single-letter names for type parameters
