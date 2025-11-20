# **Type Erasure - Short Notes**

## **1. What is Type Erasure?**
- **Generics exist only at compile time**
- **Type information removed** during compilation
- **No runtime overhead** for generics

## **2. Erasure Process**

### **Unbounded Types → Object**
```java
// Source
public class Node<T> {
    private T data;
    public T getData() { return data; }
}

// After erasure
public class Node {
    private Object data;
    public Object getData() { return data; }
}
```

### **Bounded Types → First Bound**
```java
// Source  
public class Node<T extends Comparable<T>> {
    private T data;
    public T getData() { return data; }
}

// After erasure
public class Node {
    private Comparable data;
    public Comparable getData() { return data; }
}
```

### **Generic Methods**
```java
// Source
public static <T> int count(T[] array, T elem) {
    return 0;
}

// After erasure  
public static int count(Object[] array, Object elem) {
    return 0;
}
```

## **3. Bridge Methods**
**Problem:** Type erasure breaks method overriding

```java
class Node<T> {
    public void setData(T data) { }
}

class MyNode extends Node<Integer> {
    // This should override Node.setData(Integer)
    public void setData(Integer data) { }
}
```

**After erasure:**
```java
class Node {
    public void setData(Object data) { }  // Method signature changes
}

class MyNode extends Node {
    public void setData(Integer data) { }  // No longer overrides!
    
    // COMPILER GENERATES BRIDGE METHOD:
    public void setData(Object data) {
        setData((Integer) data);  // Cast + delegate
    }
}
```

**Why needed:** Preserve polymorphism

## **4. Heap Pollution & Varargs**

### **The Problem**
```java
public static <T> void addToList(List<T> list, T... elements) {
    // T... becomes Object[] due to erasure
    // Potential ClassCastException at runtime
}
```

### **Example of Heap Pollution**
```java
public static void faultyMethod(List<String>... lists) {
    Object[] objectArray = lists;  // Valid - array covariance
    objectArray[0] = Arrays.asList(42);  // Heap pollution!
    String s = lists[0].get(0);  // ClassCastException!
}
```

### **Solutions**
```java
@SafeVarargs  // Best solution - indicates method is safe
public static <T> void safeMethod(List<T> list, T... elements) {
    // Implementation
}

@SuppressWarnings({"unchecked", "varargs"})  // Alternative
public static <T> void anotherMethod(List<T> list, T... elements) {
    // Implementation  
}
```

## **5. Reifiable vs Non-Reifiable Types**

### **Reifiable (Full type info at runtime)**
- Primitives: `int`, `double`
- Non-generic types: `String`, `Number`
- Raw types: `List`
- Unbounded wildcards: `List<?>`

### **Non-Reifiable (Type info erased)**
- Generic types: `List<String>`, `List<Number>`
- **Cannot use in:**
  - `instanceof` checks
  - Array creation: `new List<String>[10]` ❌

## **Key Points**
1. **Generics disappear at runtime** - type erasure
2. **Bridge methods maintain polymorphism**  
3. **Varargs + generics = heap pollution risk**
4. **Use `@SafeVarargs` for safe varargs methods**
5. **No generic arrays** - `new T[10]` doesn't work