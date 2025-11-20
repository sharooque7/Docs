
### **Writing and Combining Comparators: Summary Notes**

#### **Core Concept**
*   The `Comparator<T>` interface is a **functional interface** with a single abstract method: `int compare(T o1, T o2)`.
*   **Contract:**
    *   `o1 < o2` → returns a **negative** number
    *   `o1 > o2` → returns a **positive** number
    *   `o1 == o2` → should return `0` (not strictly required if `equals` is true, but recommended)
    *   `compare(o1, o2)` and `compare(o2, o1)` must have **opposite signs**

---

### **1. Creating Comparators**

#### **Basic Lambda Implementation**
```java
// Comparing integers - natural order
Comparator<Integer> comparator = (i1, i2) -> Integer.compare(i1, i2);

// Better: Using method reference
Comparator<Integer> comparator = Integer::compare;
```
**⚠️ Warning:** Avoid implementing with `(i1 - i2)` due to potential integer overflow issues.

#### **Using Factory Methods: `Comparator.comparing()`**
*   Creates a comparator based on a **key extraction function**.
*   The extracted key must be `Comparable`.

```java
// Compare strings by length
Comparator<String> byLength = Comparator.comparing(String::length);

// Compare users by name
Comparator<User> byName = Comparator.comparing(User::getName);

// Usage with List.sort()
List<User> users = ...;
users.sort(byName);
```

---

### **2. Combining Comparators**

#### **Chaining with `thenComparing()`**
*   Used when you need **secondary sorting criteria**.
*   If the primary comparator returns `0` (equal), the secondary comparator is used.

```java
// Method 1: Chain existing comparators
Comparator<User> byFirstName = Comparator.comparing(User::getFirstName);
Comparator<User> byLastName = Comparator.comparing(User::getLastName);
Comparator<User> byFirstNameThenLastName = byFirstName.thenComparing(byLastName);

// Method 2: Fluent API (Preferred)
Comparator<User> byFirstNameThenLastName = 
    Comparator.comparing(User::getFirstName)
              .thenComparing(User::getLastName);
```

---

### **3. Specialized Comparators**

#### **Primitive Specializations**
*   Avoids boxing/unboxing overhead for better performance.

```java
// For primitive properties
Comparator<User> byAge = Comparator.comparingInt(User::getAge);
Comparator<User> bySalary = Comparator.comparingDouble(User::getSalary);

// Chaining with primitives
Comparator<User> comparator = 
    Comparator.comparing(User::getFirstName)
              .thenComparingInt(User::getAge)  // Primitive specialization
              .thenComparingDouble(User::getSalary);
```

---

### **4. Useful Factory Methods & Operations**

#### **Natural Order**
```java
Comparator<String> naturalOrder = Comparator.naturalOrder();

// Chain with natural order
Comparator<String> byLengthThenNatural = 
    Comparator.comparing(String::length)
              .thenComparing(Comparator.naturalOrder());
```

#### **Reversing Order**
```java
Comparator<String> reverseOrder = Comparator.reverseOrder();
Comparator<String> reverseByName = Comparator.comparing(User::getName).reversed();

List<String> strings = Arrays.asList("one", "two", "three");
strings.sort(byLengthThenNatural.reversed());  // Reverse the entire comparator chain
```

#### **Handling Null Values**
*   `Comparator.nullsFirst(comparator)` - Puts null values at the beginning
*   `Comparator.nullsLast(comparator)` - Puts null values at the end

```java
Comparator<String> naturalNullsLast = Comparator.nullsLast(Comparator.naturalOrder());

List<String> strings = Arrays.asList("one", null, "two", "three", null);
strings.sort(naturalNullsLast);
// Result: ["one", "three", "two", null, null]
```

---

### **Quick Reference Table**

| Operation | Method | Example |
|-----------|--------|---------|
| **Create** | `Comparator.comparing()` | `Comparator.comparing(User::getName)` |
| **Chain** | `thenComparing()` | `comp1.thenComparing(comp2)` |
| **Primitive** | `comparingInt()`, `thenComparingDouble()` | `comparingInt(User::getAge)` |
| **Natural Order** | `naturalOrder()` | `Comparator.naturalOrder()` |
| **Reverse** | `reversed()` | `comparator.reversed()` |
| **Null Handling** | `nullsFirst()`, `nullsLast()` | `nullsLast(naturalOrder())` |

---

### **Complete Example**
```java
List<User> users = Arrays.asList(
    new User("Anna", "Smith", 25),
    new User("John", "Doe", 30),
    new User("Anna", "Johnson", 28)
);

// Sort by: first name (asc), last name (asc), age (desc)
Comparator<User> complexComparator = 
    Comparator.comparing(User::getFirstName)
              .thenComparing(User::getLastName)
              .thenComparingInt(User::getAge).reversed();

users.sort(complexComparator);
```

### **Key Takeaways**
1. **Use `Comparator.comparing()`** for clean, readable comparator creation
2. **Chain with `thenComparing()`** for multiple sorting criteria
3. **Use primitive specializations** (`comparingInt`, etc.) for better performance
4. **Handle null values explicitly** using `nullsFirst()`/`nullsLast()`
5. **Leverage method references** (`User::getName`) for cleaner code
6. **Reverse comparators easily** with `.reversed()` on any comparator
