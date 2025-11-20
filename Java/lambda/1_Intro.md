# ✅ **Summary of the Article: Writing Your First Lambda Expression in Java**

### **1. Lambda Expressions in Java**

* Introduced in **Java 8 (2014)**.
* They are a **simpler alternative to anonymous classes**, but only for **functional interfaces**.
* A **functional interface** = an interface with **exactly one abstract method**.
* Default and static methods are allowed and **do not count** as abstract methods.

---

# ✅ **2. Steps to Write a Lambda**

Writing a lambda involves **3 steps**:

### **Step 1 — Identify the type**

* Every lambda must have a known type at compile time.
* This type must be a **functional interface** (Runnable, Consumer, Predicate, Function, etc.).

### **Step 2 — Find the abstract method**

Examples:

* Runnable → `void run()`
* Consumer<T> → `void accept(T)`
* Predicate<T> → `boolean test(T)`
* Function<T, R> → `R apply(T)`

### **Step 3 — Write the lambda implementing that method**

General structure:

```
(parameters) -> { body }
```

Simplifications:

* Type inference lets you remove parameter types.
* If only one parameter → parentheses optional.
* If only one statement → `{}` and `return` optional.

Example:

```java
Predicate<String> p = s -> s.length() == 3;
```

---

# ✅ **3. Examples of Functional Interfaces**

### **Runnable**

```java
@FunctionalInterface
public interface Runnable {
    void run();
}
```

### **Consumer<T>**

```java
void accept(T t);
```

### **Predicate<T>**

```java
boolean test(T t);
```

All have exactly **one abstract method**, so they qualify.

---

# ✅ **4. Using and Calling Lambdas**

Once a lambda is assigned to a functional interface variable, you call them using that interface's method:

```java
predicate.test("cat");
consumer.accept("hello");
runnable.run();
```

---

# ✅ **5. Lambdas in Collections**

Lambdas work beautifully with collections, especially for:

* filtering (`Predicate`)
* iterating (`Consumer`)
* transforming values (`Function`)

Example:

```java
List<String> three = filter(words, w -> w.length() == 3);
```

---

# ✅ **6. Capturing Local Variables**

Lambdas can read, but **cannot modify**, local variables from outside their body.

Variables used inside a lambda must be:

* **final**, or
* **effectively final** (never modified)

This fails:

```java
int total = 0;
list.forEach(p -> total += p.getPrice());  // ❌ compile error
```

---

# ✅ **7. Serializing Lambdas**

* Lambdas **can** be serialized (mainly for backward compatibility).
* A lambda may appear inside an object without the programmer realizing it.

---

# 🎯 **Overall Key Ideas**

* Lambdas are just **inline implementations of functional interfaces**.
* They are strongly typed — Java determines which interface you are implementing.
* Writing them becomes easy after you:

  1. Identify the functional interface
  2. Find its abstract method
  3. Implement it using lambda syntax


