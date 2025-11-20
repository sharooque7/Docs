# ✅ **Consuming Objects with Consumer<T> — Summary**

## **1. What is Consumer<T>?**

A **Consumer<T>** represents an operation that:

* ✔ accepts **one argument**
* ✔ returns **nothing**

This is the opposite of a Supplier.

### Interface:

```java
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}
```

### Example:

```java
Consumer<String> printer = s -> IO.println(s);
```

You call it like:

```java
printer.accept("Hello");
```

---

# ✅ **2. Using Consumer<T> in Practice**

Example integrating with a Supplier:

```java
for (int i = 0; i < 5; i++) {
    int nextRandom = newRandom.getAsInt();
    printer.accept("next random = " + nextRandom);
}
```

---

# ✅ **3. *Auto-boxing Problem* and Specialized Consumers**

If you write:

```java
Consumer<Integer> printer = i -> IO.println(i);
```

Then Java must:

* box `int` → `Integer`
* unbox `Integer` → `int`

This creates overhead.

### To avoid this, Java provides **primitive consumers**:

* **IntConsumer** → `void accept(int value)`
* **LongConsumer**
* **DoubleConsumer**

### Example:

```java
IntConsumer intPrinter = i -> IO.println(i);
```

Now no boxing occurs — faster performance.

---

# 🔵 **4. BiConsumer<T, U> — Consumer with Two Inputs**

Sometimes you need a lambda that:

* takes **two arguments**
* returns **nothing**

Java provides:

```java
@FunctionalInterface
public interface BiConsumer<T, U> {
    void accept(T t, U u);
}
```

### Example:

```java
BiConsumer<Random, Integer> randomNumberPrinter =
        (random, number) -> {
            for (int i = 0; i < number; i++) {
                IO.println("next random = " + random.nextInt());
            }
        };

randomNumberPrinter.accept(new Random(314L), 5);
```

---

# 🔵 **5. Primitive BiConsumers: ObjIntConsumer, ObjLongConsumer, ObjDoubleConsumer**

When one argument is an object and the other is primitive:

* **ObjIntConsumer<T>** → `(T obj, int value)`
* **ObjLongConsumer<T>**
* **ObjDoubleConsumer<T>**

These reduce boxing of primitives while still supporting arbitrary object types.

---

# 🔵 **6. Passing Consumers to Collections — forEach()**

Java 8 added:

```java
default void forEach(Consumer<? super T> action)
```

Example:

```java
List<String> strings = List.of("A", "B", "C");
Consumer<String> printer = s -> IO.println(s);
strings.forEach(printer);
```

This applies the consumer to every element.

### Why this is powerful

* Cleaner than loops
* Works on **any Iterable**
* Fits well with Streams
* Common in modern Java code

You’ll also see this much shorter version later:

```java
strings.forEach(System.out::println);
```

---

# 🎯 **Key Takeaways**

✔ **Consumer<T>** → takes 1 input, returns nothing
✔ **IntConsumer/LongConsumer/DoubleConsumer** → avoid boxing
✔ **BiConsumer<T, U>** → takes two inputs
✔ **ObjIntConsumer<T>** etc. → mix object + primitive efficiently
✔ Used heavily in **Collections**, especially **forEach()**

---

