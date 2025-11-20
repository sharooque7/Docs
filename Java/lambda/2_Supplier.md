# ✅ **Using Lambda Expressions in Your Application — Summary**

## **1. Why Lambdas Changed the JDK**

When Java 8 introduced **lambda expressions**, the entire JDK was updated:

* Many existing interfaces automatically became **functional interfaces** (because they had exactly one abstract method).
* You don’t need to modify your old interfaces — if they have one abstract method, they can now be implemented using lambdas.
* Lambdas enabled huge improvements in:

  * Collections API
  * Stream API
  * java.util.function package

This was the biggest API change since generics in Java 5.

---

# ✅ **2. java.util.function Package**

This package contains **40+ functional interfaces**, but they are all built around **4 main core types**:

1. **Supplier<T>**
2. **Consumer<T>**
3. **Predicate<T>**
4. **Function<T, R>**

Once you understand these four shapes, you understand the whole package.

---

# 🔵 **3. Supplier<T> — Creating/Providing Objects**

### **Definition**

A Supplier **takes no arguments** and **returns a value**.

```java
@FunctionalInterface
public interface Supplier<T> {
    T get();
}
```

### **Example**

```java
Supplier<String> sup = () -> "Hello Duke!";
sup.get(); // returns the string
```

### **Returning new objects each time**

```java
Random random = new Random(314L);
Supplier<Integer> newRandom = () -> random.nextInt(10);
```

Every call to `get()` generates a new random integer.

### **Important**

This lambda **captures the `random` variable**, which must be *effectively final*.

---

# 🔵 **4. Why Specialized Suppliers Exist**

Example problem:

```java
Supplier<Integer> sup = () -> random.nextInt();
```

Two performance issues:

1. `int` → `Integer` (boxing)
2. `Integer` → `int` (unboxing)

Boxing/unboxing creates **temporary objects** and has a CPU cost.

In high-performance or large loops, this is not acceptable.

---

# 🔵 **5. IntSupplier — Optimized Version**

```java
@FunctionalInterface
public interface IntSupplier {
    int getAsInt();
}
```

Usage:

```java
Random random = new Random(314L);
IntSupplier s = () -> random.nextInt();
```

No boxing/unboxing → **more efficient**.

### Available Primitive Suppliers

* **IntSupplier**
* **BooleanSupplier**
* **LongSupplier**
* **DoubleSupplier**

### Naming rule

Instead of `get()`, they have:

* getAsInt()
* getAsBoolean()
* getAsLong()
* getAsDouble()

---

# 🎯 **Key Takeaways**

### ✔ Lambda = implementation of a functional interface

### ✔ Supplier = no input, returns a value

### ✔ Boxed types (Integer, Long) cause overhead via boxing/unboxing

### ✔ Use primitive versions (IntSupplier, LongSupplier) for performance

### ✔ java.util.function has many interfaces, but all derive from 4 core patterns

---
