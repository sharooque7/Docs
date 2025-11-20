# ✅ **1. What is Type Inference?**

**Type inference = Java compiler figures out generic types automatically.**
You normally don’t need to write:

```java
List<String> list = new ArrayList<String>();
```

The compiler already knows the type from the variable:

```java
List<String> list = new ArrayList<>();
```

👉 Java figures out that `<>` means `<String>` here.

---

# ✅ **2. Generic Methods & Type Inference**

Example:

```java
static <T> T pick(T a1, T a2) { return a2; }
Serializable s = pick("d", new ArrayList<String>());
```

Compiler sees:

* First argument: `"d"` → String → Serializable
* Second argument: `new ArrayList<String>()` → also Serializable

So **best common type = `Serializable`**
Therefore `T = Serializable`.

📌 **Idea:** Java picks the most specific type that fits both arguments.

---

# ✅ **3. Diamond Operator (<>)**

Before Java 7:

```java
Map<String, List<String>> map = new HashMap<String, List<String>>();
```

From Java 7:

```java
Map<String, List<String>> map = new HashMap<>();
```

Compiler infers that `<String, List<String>>` is the type.

❌ If you write:

```java
new HashMap();
```

You get a warning because this becomes a **raw type**, not generic.

---

# ✅ **4. Generic Constructors**

A generic class:

```java
class MyClass<X> {
    <T> MyClass(T t) { }
}
```

Instantiation:

```java
new MyClass<Integer>("Hello")
```

Here:

* `X = Integer` → for the class
* `T = String` → for the constructor (because you passed "Hello")

Java 7+ also supports diamond:

```java
MyClass<Integer> obj = new MyClass<>("");
```

Compiler infers both class type (`Integer`) and constructor type (`String`).

---

# ✅ **5. Target Type**

**Target type = the expected type in a context.**

Example:

```java
List<String> list = Collections.emptyList();
```

Compiler sees the target type is **List<String>**
So it infers:

```
T = String
```

Before Java 8 → this did NOT work in method calls:

```java
processStringList(Collections.emptyList()); // ❌ Java 7 error
```

Because Java 7 guesses:

```
T = Object → List<Object>
```

Java 8 uses the target type from method argument:

✔ Now this works:

```java
processStringList(Collections.emptyList());
```

---

# ✅ **6. Target Type in Lambda Expressions**

A lambda expression has no type by itself.

Example:

```java
printPersons(people, p -> p.getAge() > 18);
```

Compiler sees the method signature:

```java
printPersons(List<Person>, CheckPerson)
```

So it knows:

```
p -> ...  must be a CheckPerson
```

Another method:

```java
printPersonsWithPredicate(List<Person>, Predicate<Person>)
```

Now:

```
p -> ... must be Predicate<Person>
```

👉 **Same lambda code**
👉 **Different target types depending on context**

---

# ✅ **7. Overload Resolution with Lambdas**

Which method is called?

```java
void invoke(Runnable r) { }
<T> T invoke(Callable<T> c) { }
```

Call:

```java
String s = invoke(() -> "done");
```

Why Callable?

* Runnable: `run()` returns **void**
* Callable: `call()` returns **T**

Your lambda returns `"done"` → **has return value**
So it matches Callable, NOT Runnable.

Therefore:

```java
invoke(Callable)
```

---

# 🔥 **EXTREMELY SIMPLE SUMMARY**

| Concept                       | Meaning                                                              |
| ----------------------------- | -------------------------------------------------------------------- |
| Type inference                | Compiler guesses generic types automatically                         |
| Diamond operator `<>`         | Tells compiler to infer generic type on right side                   |
| Generic constructors          | Constructors can also have their own type parameters                 |
| Target type                   | The type expected by the context (variable, method arg, return type) |
| Lambdas depend on target type | The method signature decides the lambda type                         |
| Overload resolution           | Compiler chooses method based on lambda behavior                     |

---

