Of course! Here are structured notes summarizing the key points about method references from the provided text.

### **Method References: Summary Notes**

#### **Core Concept**
*   A **lambda expression** is an implementation of a functional interface's single abstract method (an "anonymous method").
*   A **method reference** is a shorthand syntax for a lambda expression that *only calls a specific, existing method*.
*   **Syntax:** `ClassOrObject::methodName`

---

### **The 4 Types of Method References**

#### 1. Static Method Reference
*   **Purpose:** Reference a static method.
*   **Syntax:** `RefType::staticMethod`
*   **Lambda Equivalent:** `(args) -> RefType.staticMethod(args)`
*   **Examples:**
    *   `a -> Math.sqrt(a)` becomes `Math::sqrt`
    *   `(a, b) -> Integer.max(a, b)` becomes `Integer::max`

#### 2. Bound Method Reference
*   **Purpose:** Reference an instance method on a *specific, pre-existing object*.
*   **Syntax:** `expr::instanceMethod` (where `expr` evaluates to an object)
*   **Lambda Equivalent:** `(args) -> expr.instanceMethod(args)`
*   **Examples:**
    *   `s -> System.out.println(s)` becomes `System.out::println`
    *   `s -> myInstanceVar.myMethod(s)` becomes `myInstanceVar::myMethod`

#### 3. Unbound Method Reference
*   **Purpose:** Reference an instance method where the target object is *provided as the first argument* of the lambda.
*   **Syntax:** `RefType::instanceMethod`
*   **Lambda Equivalent:** `(arg0, rest) -> arg0.instanceMethod(rest)`
    *   `arg0` is an instance of `RefType`.
    *   `rest` represents the remaining arguments (if any).
*   **Examples:**
    *   `s -> s.length()` becomes `String::length` (First arg is the `String`)
    *   `user -> user.getName()` becomes `User::getName` (First arg is the `User`)
    *   `(sentence, word) -> sentence.indexOf(word)` becomes `String::indexOf` (First arg is the `String`, second is the method argument).

#### 4. Constructor Method Reference
*   **Purpose:** Reference a constructor.
*   **Syntax:** `ClassName::new`
*   **Lambda Equivalent:** `(args) -> new ClassName(args)`
*   **Examples:**
    *   `() -> new ArrayList<>()` becomes `ArrayList::new`
    *   `(size) -> new ArrayList<>(size)` also becomes `ArrayList::new`
*   **Important:** The exact constructor called is determined by the functional interface's method signature (number and type of parameters). The type can be specified if needed: `ArrayList<String>::new`.

---

### **Quick Reference Table**

| Name | Syntax | Lambda Equivalent |
| :--- | :--- | :--- |
| **Static** | `RefType::staticMethod` | `(args) -> RefType.staticMethod(args)` |
| **Bound** | `expr::instanceMethod` | `(args) -> expr.instanceMethod(args)` |
| **Unbound** | `RefType::instanceMethod` | `(arg0, rest) -> arg0.instanceMethod(rest)` |
| **Constructor** | `ClassName::new` | `(args) -> new ClassName(args)` |

---

### **Key Takeaways & Best Practices**
*   **When to Use:** Use method references to make your code more concise and readable when a lambda does nothing but call another method.
*   **IDE is Your Friend:** Most IDEs can automatically suggest converting eligible lambda expressions to method references.
*   **Context is Key:** The same method reference syntax (e.g., `ArrayList::new`) can refer to different constructors depending on the context (the functional interface it is assigned to). Always check the target type.
*   **Unbound vs. Static:** The syntax for Unbound (`String::length`) looks like a static call but is not. Remember the first parameter becomes the target object.