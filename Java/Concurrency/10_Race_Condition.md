# Race Conditions in Java: Comprehensive Guide

## What are Race Conditions?

A race condition is a situation where two or more threads access the same variables or data concurrently in a way where the final result stored in the variable depends on how thread access to the variables is scheduled.

Race conditions occur when:
1. Two or more threads read and write the same variables concurrently
2. Thread access follows certain patterns (check-then-act or read-modify-write)
3. The modified value depends on the previously read value
4. Thread access to the variables is not atomic

## Types of Race Conditions

### 1. Read-Modify-Write Race Condition

This occurs when multiple threads:
1. Read a value from a shared variable
2. Modify the value (often based on the read value)
3. Write the modified value back to the shared variable

#### Example:
```java
public class Counter {
    private long count = 0;
    
    public long incrementAndGet() {
        count = count + 1;  // Read, modify, write operation
        return count;
    }
    
    public long getCount() {
        return count;
    }
}
```

When two threads call `incrementAndGet()` concurrently, they may both read the same initial value, independently increment it by 1, and write back the same incremented value - resulting in only one increment being recorded instead of two.

#### Visualizing the Problem:

**Expected Sequential Behavior:**
- Thread 1: Reads count (0) → Increments to 1 → Writes 1
- Thread 2: Reads count (1) → Increments to 2 → Writes 2
- Final result: 2

**Problematic Interleaved Behavior:**
- Thread 1: Reads count (0)
- Thread 2: Reads count (0)
- Thread 1: Increments to 1
- Thread 2: Increments to 1
- Thread 1: Writes 1
- Thread 2: Writes 1
- Final result: 1 (one increment lost)

### 2. Check-Then-Act Race Condition

This occurs when a thread checks a condition and then performs an action based on that check, but the condition changes between the check and the action due to another thread's interference.

#### Example:
```java
// Using a shared map between threads
if (map.containsKey(key)) {  // Check
    Object value = map.remove(key);  // Act
    if (value == null) {
        System.out.println("Value was null for iteration " + i);
    }
} else {
    map.put(key, "value");
}
```

The race condition happens when:
1. Thread 1 checks that the map contains the key
2. Thread 2 checks that the map contains the key
3. Thread 1 removes the key and gets the value
4. Thread 2 tries to remove the key but gets null (since it was already removed)

Both threads verified the key existed, but only one successfully retrieved the value.

## Critical Sections

A critical section is the segment of code where race conditions can occur. In the examples above:
- For the counter: The `count = count + 1` operation
- For the map: The check-then-act sequence with `containsKey()` and `remove()`

## Making Operations Atomic

To fix race conditions, you need to make critical sections atomic, ensuring only one thread can execute the section at a given time.

### Solution 1: Using Synchronized Blocks

```java
public class SynchronizedCounter {
    private long count = 0;
    
    public synchronized long incrementAndGet() {
        count = count + 1;
        return count;
    }
    
    public long getCount() {
        return count;
    }
}
```

For the check-then-act pattern:
```java
synchronized (sharedMap) {
    if (sharedMap.containsKey(key)) {
        Object value = sharedMap.remove(key);
        if (value == null) {
            System.out.println("Value was null for iteration " + i);
        }
    } else {
        sharedMap.put(key, "value");
    }
}
```

### When Race Conditions Don't Occur

Race conditions only occur under specific circumstances:

1. When multiple threads are writing to the same variable
   - If only one thread writes and others only read, you don't have a race condition
   - However, you may still have visibility issues (threads not seeing the latest updates)

2. When threads access different variables
   - If Thread 1 writes to Counter A and reads Counter B
   - And Thread 2 writes to Counter B and reads Counter A
   - No race condition exists because each counter is only modified by one thread

## Visibility Problems vs. Race Conditions

While fixing race conditions, be aware of related memory visibility issues:

- Even without race conditions, threads might read "stale" values if variables aren't properly synchronized
- Use `volatile` keyword or synchronized blocks to ensure visibility
- Race conditions involve lost updates; visibility problems involve delayed updates

## Best Practices

1. Identify critical sections in your code
2. Make critical sections atomic using:
   - Synchronized blocks/methods
   - Lock objects from `java.util.concurrent.locks`
   - Atomic classes from `java.util.concurrent.atomic`
3. Use thread-safe collections where appropriate:
   - `ConcurrentHashMap` for concurrent map access
   - `CopyOnWriteArrayList` for concurrent list operations
4. Understand when synchronization is needed:
   - Multiple threads writing to the same variable
   - Check-then-act or read-modify-write patterns with shared data
5. Consider thread confinement or immutability as alternatives to synchronization

## Additional Resources

For more information on concurrent programming in Java, explore:
- Java's `synchronized` keyword
- The `volatile` keyword for visibility guarantees
- Java Memory Model and happens-before guarantees
- Lock interfaces and Atomic variables
- Thread-safe collections