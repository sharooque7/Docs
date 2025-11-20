# Java Volatile Keyword Documentation

## Overview

The `volatile` keyword in Java is a special modifier that can be applied when declaring a variable. It provides specific visibility and ordering guarantees for multi-threaded applications, ensuring that changes to a variable's value are always visible across threads.

## Syntax

```java
private volatile int counter;
```

## Key Characteristics

### 1. Memory Visibility Guarantee

When a variable is declared `volatile`:
- **Read operations**: Always read directly from main memory (not CPU cache)
- **Write operations**: Always write directly back to main memory immediately

Without the `volatile` keyword, Java provides no guarantees about when variable values are read from or written to main memory. This can lead to threads seeing stale or outdated values.

### 2. Happens-Before Guarantee

The `volatile` keyword prevents instruction reordering that could break visibility guarantees:

- **Write guarantee**: All variable writes that happen before a write to a volatile variable will remain before the volatile write and cannot be reordered.
- **Read guarantee**: All reads of a volatile variable will happen before any subsequent reads of other variables and cannot be reordered.

## When to Use Volatile Variables

Use `volatile` when:
- A variable is shared between multiple threads
- The variable can be modified by one thread and read by others
- You need visibility guarantees without the overhead of synchronization

Do not use `volatile` when:
- The code runs in a single-threaded context
- You need atomic compound operations (use synchronization or atomic classes instead)
- Performance is critical (volatile has performance overhead)

## Visibility Problems Without Volatile

Consider a scenario with two threads:

```java
class SharedObject {
    private Object object;
    private boolean hasNewObject;
    
    public void setObject(Object obj) {
        object = obj;
        hasNewObject = true;
    }
    
    public Object getObject() {
        while (!hasNewObject) {
            // Wait for new object
        }
        hasNewObject = false;
        return object;
    }
}
```

Without `volatile`, Thread 1 may update `object` and `hasNewObject`, but these changes might remain in CPU registers or cache, not visible to Thread 2. Thread 2 might continue looping indefinitely because it never sees the updated `hasNewObject` value.

## Correct Usage Example

```java
class SharedObject {
    private Object object;
    private volatile boolean hasNewObject;
    
    public void setObject(Object obj) {
        object = obj;
        hasNewObject = true; // Writing to volatile variable
    }
    
    public Object getObject() {
        while (!hasNewObject) { // Reading volatile variable
            // Wait for new object
        }
        hasNewObject = false;
        return object;
    }
}
```

Here, the `volatile` keyword on `hasNewObject` guarantees:
1. When Thread 1 sets `hasNewObject = true`, both `hasNewObject` and `object` are written to main memory
2. When Thread 2 reads `hasNewObject`, both `hasNewObject` and `object` are refreshed from main memory

## Limitations of Volatile

The `volatile` keyword does not make compound operations atomic. Consider this counter:

```java
class Counter {
    private volatile int count = 0;
    
    public void inc() {
        if (count != 10) {
            count++; // Not atomic!
        }
    }
}
```

The `count++` operation consists of:
1. Reading the value from memory
2. Incrementing it in a CPU register
3. Writing it back to memory

If two threads execute `inc()` simultaneously when `count` is 9:
- Both read 9 from memory
- Both increment to 10
- Both write 10 back to memory
- Final value is 10, not 11 as expected

## Better Alternatives for Compound Operations

For compound operations like increments, use:

1. **Synchronized methods/blocks**:
```java
class Counter {
    private int count = 0;
    
    public synchronized void inc() {
        if (count != 10) {
            count++;
        }
    }
}
```

2. **Atomic classes**:
```java
import java.util.concurrent.atomic.AtomicInteger;

class Counter {
    private AtomicInteger count = new AtomicInteger(0);
    
    public void inc() {
        int current = count.get();
        if (current != 10) {
            count.incrementAndGet();
        }
    }
}
```

## Performance Considerations

The `volatile` keyword introduces a performance overhead due to:
- Bypassing CPU caches
- Preventing certain compiler optimizations
- Memory barriers being inserted

Only use `volatile` when you need the visibility guarantees it provides.

## Summary

- `volatile` ensures variable changes are immediately visible to all threads
- `volatile` prevents dangerous instruction reordering
- `volatile` is not a substitute for synchronization when atomic operations are needed
- `volatile` has performance overhead and should only be used when necessary