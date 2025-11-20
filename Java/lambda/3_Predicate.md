
# ✅ **Predicate<T> — Testing Objects**

## **1. What is Predicate<T>?**

A **Predicate<T>** is basically a boolean test.

* ✔ Takes **one argument**
* ✔ Returns **boolean**
* ✔ Used heavily for **filtering streams**, **validations**, and **conditional logic**

### Interface:

```java
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}
```

### Example:

```java
Predicate<String> length3 = s -> s.length() == 3;
```

### Usage:

```java
String word = "cat";
boolean result = length3.test(word);
System.out.println(result); // true
```

---

# 🔵 **2. Auto-boxing Issue & Primitive Predicates**

If you write:

```java
Predicate<Integer> isGreaterThan10 = i -> i > 10;
```

Then Java must:

* unbox `Integer` → `int`
* compare the primitive

This is extra overhead.

### Optimized version:

```java
IntPredicate isGreaterThan10 = i -> i > 10;
```

Primitive predicate interfaces:

* **IntPredicate**
* **LongPredicate**
* **DoublePredicate**

All have:

```java
boolean test(int value);
```

This avoids boxing → faster.

---

# 🔵 **3. BiPredicate<T, U> — Testing Two Inputs**

Takes **two inputs**, returns a **boolean**.

```java
@FunctionalInterface
public interface BiPredicate<T, U> {
    boolean test(T t, U u);
}
```

### Example:

```java
BiPredicate<String, Integer> isOfLength =
        (word, length) -> word.length() == length;

isOfLength.test("hello", 5); // true
```

### Note:

There are **no specialized primitive versions** like ObjIntPredicate.
(Probably because use cases for two primitives are rare.)

---

# 🔵 **4. Passing Predicates to Collections — removeIf()**

Java 8 added:

```java
boolean removeIf(Predicate<? super E> filter)
```

### Example:

```java
List<String> list =
        new ArrayList<>(List.of("one", "two", "three", "four", "five"));

Predicate<String> isEvenLength = s -> s.length() % 2 == 0;

list.removeIf(isEvenLength);

System.out.println(list);
```

### Output:

```
[one, two, three]
```

---

# ⚠️ Important Notes About removeIf()

### 1. It **mutates** the list

So don’t use it on immutable lists.

### 2. `List.of(...)` is immutable

Calling removeIf() → throws UnsupportedOperationException.

### 3. `Arrays.asList(...)` is a fixed-size list

You can modify elements, but you **cannot add/remove**.

removeIf() → also UnsupportedOperationException.

---

# 🎯 **Quick Summary**

| Interface         | Inputs          | Output  | Use Case                    |
| ----------------- | --------------- | ------- | --------------------------- |
| Predicate<T>      | 1               | boolean | filtering, conditions       |
| IntPredicate      | 1 primitive int | boolean | avoid boxing                |
| BiPredicate<T, U> | 2               | boolean | checks involving two inputs |

---
