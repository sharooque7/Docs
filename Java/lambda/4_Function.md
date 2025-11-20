# ✅ **Java Function<T, R> & Related Functional Interfaces — Summary for Notes**

## **1. Function<T, R>**

Represents a mapping/transformation:

* **Input:** T
* **Output:** R

**Method:**

```java
R apply(T t);
```

Use case: **map**, **transform**, **convert** objects
Example:

```java
Function<String, Integer> toLength = s -> s.length();
```

---

## **2. Boxing / Unboxing Issue**

* Returning `Integer` causes boxing of primitive `int`.
* Assigning to `int` causes unboxing again.
* This is OK unless you're in **performance-critical** systems.
* JDK provides **specialized functional interfaces** to avoid boxing.

---

## **3. Why Specialized Functions?**

Because both *input* and *output* types may be:

* Generic `T`
* `int`
* `long`
* `double`

So the JDK provides many variants like:

* `IntFunction<T>`
* `ToIntFunction<T>`
* `DoubleUnaryOperator`
* etc.

---

## **4. UnaryOperator<T>**

A special case of Function where:

* Input = Output = same type

Signature:

```java
T apply(T t);
```

Use case examples:

* uppercasing strings
* math operations (sqrt, log, etc.)
* modifying list elements in-place

### Example: replaceAll()

```java
List<String> list = Arrays.asList("one","two","three");
UnaryOperator<String> upper = s -> s.toUpperCase();
list.replaceAll(upper);
```

---

## **5. List.replaceAll() Uses UnaryOperator**

Why not Function?

* Because list type cannot change
* UnaryOperator enforces **same-type transformation**

---

## **6. Specialized Function Types Matrix**

There are **16 total variants** based on input/output type combinations:

| Parameter ↓ / Return → | T                 | int                 | long                 | double               |
| ---------------------- | ----------------- | ------------------- | -------------------- | -------------------- |
| **T**                  | UnaryOperator<T>  | ToIntFunction<T>    | ToLongFunction<T>    | ToDoubleFunction<T>  |
| **int**                | IntFunction<T>    | IntUnaryOperator    | IntToLongFunction    | IntToDoubleFunction  |
| **long**               | LongFunction<T>   | LongToIntFunction   | LongUnaryOperator    | LongToDoubleFunction |
| **double**             | DoubleFunction<T> | DoubleToIntFunction | DoubleToLongFunction | DoubleUnaryOperator  |

---

## **7. BiFunction<T, U, R>**

Accepts **two inputs**, returns one output.

```java
R apply(T t, U u);
```

Example:

```java
BiFunction<String, String, Integer> findIndex =
    (word, sentence) -> sentence.indexOf(word);
```

---

## **8. BinaryOperator<T>**

Special BiFunction where:

* both inputs and the output are same type T

Used for:

* addition
* multiplication
* min/max

---

## **9. Specialized BiFunctions**

For primitives:

* `IntBinaryOperator`
* `LongBinaryOperator`
* `DoubleBinaryOperator`

Also:

* `ToIntBiFunction<T>`
* `ToLongBiFunction<T>`
* `ToDoubleBiFunction<T>`

---

# ⭐ Final Mental Model

### ✔ **Function<T, R>** — transforms (T → R)

### ✔ **UnaryOperator<T>** — transforms T → T

### ✔ **BiFunction<T, U, R>** — combines two inputs

### ✔ **BinaryOperator<T>** — combines two inputs of same type, returns same type

### ✔ Specialized versions exist to avoid boxing overhead

---
