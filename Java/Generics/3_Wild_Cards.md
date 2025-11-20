# ⭐ 1. What are Wildcards?

Wildcards are **?** inside generics.

They mean:

> “I don’t know the exact type, but I want flexibility.”

There are 3 types:

| Wildcard      | Meaning                    | When to use                    |
| ------------- | -------------------------- | ------------------------------ |
| `? extends T` | Unknown **subtype** of T   | Read data ("in")               |
| `? super T`   | Unknown **supertype** of T | Write data ("out")             |
| `?`           | Completely unknown         | Only using methods from Object |

---

# ⭐ 2. Upper Bounded Wildcards — `? extends T`

**Means:** “I will accept T or any subclass of T.”

Example:

```java
List<? extends Number>
```

This can be:

* List<Integer>
* List<Double>
* List<Float>
* List<Number>

### ✔ You can **read** safely

Because if something is `? extends Number`, it **is guaranteed to be a Number**.

Example:

```java
Number n = list.get(0); 
```

### ❌ You **cannot write** anything (except null)

Because the compiler doesn’t know which subtype the list really is.

Example:

```java
list.add(10); // ❌ Error
list.add(new Number()); // ❌ Error
```

Reason:
The compiler doesn’t know if list is actually List<Integer>, List<Float>, etc.

---

# ⭐ **PECS Rule** (most important point)

### **Producer Extends**

If the list **produces** elements for you → use `? extends`.

Example:

```java
double sumOfList(List<? extends Number> list)
```

The list is a **producer** of Number values that you read.

---

# ⭐ 3. Unbounded Wildcards — `?`

Means “I don’t care about the type.”

Example:

```java
List<?> list;
```

This is useful when:

### ✔ You only need methods from Object

Examples: size(), clear(), iterator(), printing values.

Example:

```java
void printList(List<?> list) {
    for (Object o : list) {
        System.out.println(o);
    }
}
```

### ❌ You cannot insert anything (except null)

```java
list.add("abc"); // ❌ Error
list.add(123);   // ❌ Error
list.add(null);  // ✔ OK
```

---

# ⭐ 4. Lower Bounded Wildcards — `? super T`

Means: “I accept T or any **superclass of T**.”

Example:

```java
List<? super Integer>
```

This can be:

* List<Integer>
* List<Number>
* List<Object>

### ✔ You can **insert (write)** integers safely

Because all of them can hold Integer.

Example:

```java
list.add(10); // ✔ Safe
```

### ❌ You cannot safely read exact types

Because the list might be List<Object>, List<Number>, etc.

Example:

```java
Object o = list.get(0); // ✔ OK
Integer x = list.get(0); // ❌ Not guaranteed
```

---

# ⭐ **PECS Rule** continued

### **Consumer Super**

If the list **consumes** elements from you → use `? super`.

Example:

```java
void addNumbers(List<? super Integer> list)
```

The list is the **destination**, so we use `super`.

---

# ⭐ 5. Wildcards + Subtyping

Important principle:

### **List<Integer> IS NOT a subtype of List<Number>**

Even though Integer extends Number.

Because generics are **invariant**.

Example:

```java
List<Number> list = new ArrayList<Integer>(); // ❌ Not allowed
```

But:

### ✔ `List<Integer>` **is a subtype of** `List<? extends Number>`

---

# ⭐ 6. Wildcard Capture

Occurs when Java needs to “infer” what ? really is.

Example that fails:

```java
void foo(List<?> list) {
    list.set(0, list.get(0)); // ❌ Capture error
}
```

Java doesn't know the precise type — only "some unknown type".

Fix (using helper method):

```java
private <T> void fooHelper(List<T> list) {
    list.set(0, list.get(0)); // ✔ works
}
```

The helper method **captures** the actual type of the wildcard.

---

# ⭐ 7. The Most Important Rules (Easy to Remember)

## **PECS — Producer Extends, Consumer Super**

* Use `? extends T` when you **only read** and want subtype flexibility.
* Use `? super T` when you **only write** and want supertype flexibility.

---

## **Rule 2: Do not use wildcards in return types**

This makes the caller's life difficult.

Prefer:

```java
List<String> method()   // ✔ good
List<? extends String> method() // ❌ avoid
```

---

## **Rule 3: `List<? extends T>` is effectively "read-only"**

You cannot insert values (except null).

---

## **Rule 4: `List<?>` allows nothing to be inserted**

Only null.

Use it when you don't care about the type.

---

# ⭐ 8. Quick Comparison Table

| Wildcard      | You can read? | You can write? | Good for          |
| ------------- | ------------- | -------------- | ----------------- |
| `? extends T` | ✔ As T        | ❌ No           | Producers         |
| `? super T`   | ✔ As Object   | ✔ T            | Consumers         |
| `?`           | ✔ As Object   | ❌ Only null    | Type-agnostic use |

---

# ⭐ 9. Real-world Example: Copy Method

```java
void copy(List<? extends T> src, List<? super T> dest)
```

* src is the **producer** → extends
* dest is the **consumer** → super

This pattern is seen everywhere in Java Collections.

---