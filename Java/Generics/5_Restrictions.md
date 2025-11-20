# ✅ **Java Generics — Complete Explanation of Restrictions (Simplified)**

Java uses **type erasure** to implement generics. This means that **generic type information is removed at runtime**. So `List<Integer>` and `List<String>` become just `List`.

Because of this, several restrictions exist. Let’s go one by one.

---

# 1️⃣ **Cannot Instantiate Generics with Primitive Types**

❌ Not allowed:

```java
Pair<int, char> p = new Pair<>(8, 'a'); 
```

✔ Allowed:

```java
Pair<Integer, Character> p = new Pair<>(8, 'a');
```

### **Why?**

Generics only work with **reference types**, not primitives.
Java solves this using **autoboxing** (`int → Integer`, `char → Character`).

---

# 2️⃣ **Cannot Create Instances of Type Parameters**

❌ Not allowed:

```java
E elem = new E();  
```

### **Why?**

After type erasure, the runtime does not know what `E` is, so it cannot create an instance.

### Workaround:

✔ Using reflection:

```java
E elem = cls.newInstance();
```

But this needs:

```java
append(list, String.class);
```

---

# 3️⃣ **Cannot Declare Static Fields Using Type Parameters**

❌ Not allowed:

```java
class MobileDevice<T> {
    private static T os;  // Error
}
```

### **Why?**

Static fields belong to the **class**, not the object.

But different objects may use different type parameters:

```java
MobileDevice<Smartphone>
MobileDevice<Pager>
MobileDevice<TabletPC>
```

Then what type should `os` be?
`Smartphone`? `Pager`? `TabletPC`?

This is why Java disallows it.

---

# 4️⃣ **Cannot Use `instanceof` or Cast with Parameterized Types**

❌ Not allowed:

```java
if (list instanceof ArrayList<Integer>) {}
```

### **Why?**

Because of **type erasure**, JVM only sees:

```java
ArrayList
```

Not `ArrayList<Integer>`.

✔ Allowed:

```java
if (list instanceof ArrayList<?>) {}
```

---

### Casting Example

❌ This cast is unsafe:

```java
List<Number> ln = (List<Number>) li; // li is List<Integer>
```

✔ But sometimes safe:

```java
ArrayList<String> l2 = (ArrayList<String>) l1;
```

Why?
Because if `l1` is already an `ArrayList<String>`, the compiler knows the underlying type.

---

# 5️⃣ **Cannot Create Arrays of Parameterized Types**

❌ Not allowed:

```java
List<Integer>[] array = new List<Integer>[5];
```

### **Why?**

Arrays are **covariant** and reifiable → runtime checks real type.

Generics are **non-reifiable** → type information is erased.

### Example problem:

```java
Object[] arr = new String[2];
arr[1] = 100;   // ArrayStoreException (good)
```

But for generics:

```java
Object[] arr = new List<String>[2];     // pretend this is allowed
arr[1] = new ArrayList<Integer>();      // No way to detect wrong type!
```

So Java **disallows** creation of generic arrays to prevent runtime type corruption.

---

# 6️⃣ **Cannot Create, Catch, or Throw Generic Exceptions**

❌ Not allowed:

```java
class MyException<T> extends Exception {}
```

### **Why?**

Throwable needs **exact type information at runtime**, but due to type erasure, generics lose that info.

❌ Not allowed to catch generic type:

```java
catch (T e) {}
```

### ✔ Allowed: using generics in `throws`

```java
class Parser<T extends Exception> {
    public void parse() throws T {}
}
```

Because throwing does not require creating an object, only declaring.

---

# 7️⃣ **Cannot Overload Methods Whose Generic Parameters Erase to Same Type**

Example:

```java
public void print(Set<String> s) {}
public void print(Set<Integer> s) {}
```

### After type erasure:

Both become:

```java
print(Set s)
```

Same signature → conflict → compile-time error.

---

# 🎯 **Summary Table**

| Restriction                      | Why it happens                           |
| -------------------------------- | ---------------------------------------- |
| No primitives                    | Generics require reference types         |
| Cannot create `new T()`          | Type erased, runtime doesn’t know `T`    |
| No static fields of T            | Static belongs to class, but T varies    |
| No `instanceof List<Integer>`    | Type erased, runtime can’t check type    |
| No arrays of generic types       | Arrays know runtime type, generics don’t |
| No generic exceptions            | Throwable requires specific type info    |
| No erasure-conflicting overloads | Both overloads erase to same signature   |

---


