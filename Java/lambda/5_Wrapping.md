# ✅ **Summary: Java Functional Interfaces (Supplier, Consumer, Predicate, Function)**

Java’s `java.util.function` package contains core functional interfaces used in **lambda expressions**, **Collections**, and the **Stream API**.
They fall into **4 main categories**:

---

# 🟦 **1. Supplier – No Input, Produces Output**

* **Signature:** `T get()`
* Takes **no arguments**.
* **Returns** a value.
* Examples: `Supplier<T>`, `IntSupplier`, `LongSupplier`, etc.

---

# 🟩 **2. Consumer – Takes Input, Returns Nothing**

* **Signature:** `void accept(T)`
* Takes **one argument**, performs an action (**no return**).
* Examples:

  * `Consumer<T>`
  * Specialized: `IntConsumer`, `LongConsumer`, `DoubleConsumer`
* **BiConsumer<T, U>:** takes **two** inputs.
* You can pass a `Consumer` to `Iterable.forEach()`.

---

# 🟧 **3. Predicate – Takes Input, Returns Boolean**

* **Signature:** `boolean test(T)`
* Used for filtering, matching, validations.
* Specialized: `IntPredicate`, `LongPredicate`, etc.
* Also has **BiPredicate<T, U>**.

---

# 🟨 **4. Function – Takes Input, Returns Output**

* **Signature:** `R apply(T)`
* Converts (maps) one object to another.
* Examples:
  `Function<T, R>` → e.g., String → Integer (string length)

### ⚠️ Boxing & Unboxing Issue:

Using `Function<String, Integer>` causes boxing.
To avoid this, specialized versions exist:

### **Specialized Functions (16 total)**

Based on parameter type and return type:

| Input ↓ / Return → | T                   | int                 | long                 | double               |
| ------------------ | ------------------- | ------------------- | -------------------- | -------------------- |
| **T**              | UnaryOperator<T>    | IntFunction<T>      | LongFunction<T>      | DoubleFunction<T>    |
| **int**            | ToIntFunction<T>    | IntUnaryOperator    | LongToIntFunction    | DoubleToIntFunction  |
| **long**           | ToLongFunction<T>   | IntToLongFunction   | LongUnaryOperator    | DoubleToLongFunction |
| **double**         | ToDoubleFunction<T> | IntToDoubleFunction | LongToDoubleFunction | DoubleUnaryOperator  |

### **UnaryOperator<T>**

* Same input and output type
* Extends `Function<T, T>`
* Used in `List.replaceAll()`.

### **BiFunction<T, U, R>**

* Two inputs, one return.

### **BinaryOperator<T>**

* Same type for both inputs and return
* Common for arithmetic operations.

---

# 🟪 **How to Remember Easily**

### 🔹 If it **returns something** → it's a **Supplier** or **Function**

* **No input?** Supplier
* **Has input?** Function

### 🔹 If it **returns nothing** → Consumer

### 🔹 If it **returns boolean** → Predicate

### 🔹 If it **takes 2 arguments** → Add prefix **Bi** (BiConsumer, BiPredicate, BiFunction)

### 🔹 If **input & output are same type** → UnaryOperator / BinaryOperator

### 🔹 If dealing with primitives → Look for `Int`, `Long`, `Double` versions

---

# 🏁 **Final Quick Summary**

* **Supplier** → no input → returns a value

* **Consumer** → input → no return

* **Predicate** → input → returns boolean

* **Function** → input → return value

* **Bi- versions** → same as above but with two inputs

* **UnaryOperator / BinaryOperator** → special cases for same-type transformations

* **Specialized primitive versions** → avoid boxing/unboxing (better performance)

---
