# Java Synchronized Blocks: Complete Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Synchronized Instance Methods](#synchronized-instance-methods)
3. [Synchronized Blocks Inside Instance Methods](#synchronized-blocks-inside-instance-methods)
4. [Monitor Objects](#monitor-objects)
5. [Synchronized Static Methods](#synchronized-static-methods)
6. [Using Both Synchronized Static and Instance Methods](#using-both-synchronized-static-and-instance-methods)
7. [Using Different Monitor Objects](#using-different-monitor-objects)
8. [Sharing Monitor Objects Across Instances](#sharing-monitor-objects-across-instances)
9. [Synchronized Blocks in Lambda Expressions](#synchronized-blocks-in-lambda-expressions)
10. [Reentrance Rules](#reentrance-rules)
11. [Visibility Guarantees](#visibility-guarantees)
12. [Happens-Before Guarantee](#happens-before-guarantee)
13. [Limitations of Synchronized Blocks](#limitations-of-synchronized-blocks)
14. [Performance Considerations](#performance-considerations)
15. [Synchronized Blocks in Clustered Environments](#synchronized-blocks-in-clustered-environments)
16. [Best Practices](#best-practices)

## Introduction

A Java synchronized block is a block of code that can only be executed by one thread at a time. Synchronized blocks provide a mechanism to control access to shared resources in a multi-threaded environment, preventing data corruption and ensuring thread safety.

## Synchronized Instance Methods

When you declare an instance method as synchronized, the entire method becomes a synchronized block.

```java
public synchronized void setObject(Object obj) {
    this.obj = obj;
}

public synchronized Object getObject() {
    return obj;
}
```

Key points:
- Only one thread can execute a synchronized instance method at a time on a given instance
- If a class has multiple synchronized instance methods, only one thread can execute any of these methods at a time on the same instance
- Synchronized instance methods use the instance itself (`this`) as the monitor object

## Synchronized Blocks Inside Instance Methods

Instead of synchronizing an entire method, you can create synchronized blocks within methods:

```java
public void setObj(Object obj) {
    synchronized(this) {
        this.obj = obj;
    }
}

public Object getObj() {
    synchronized(this) {
        return obj;
    }
}
```

This approach offers more fine-grained control over synchronization, allowing you to synchronize only the critical sections of a method.

## Monitor Objects

The object specified in the parentheses of a synchronized block is called the monitor object (or lock). This is the object on which the synchronized block is synchronized.

For synchronized instance methods, the implicit monitor object is `this` (the instance the method belongs to).

All synchronized blocks that use the same monitor object will mutually exclude threads from entering them simultaneously.

## Synchronized Static Methods

Static methods can also be synchronized:

```java
private static Object object = null;

public static synchronized void setObject(Object obj) {
    object = obj;
}

public static synchronized Object getObject() {
    return object;
}
```

Key points:
- Static synchronized methods use the class object as the monitor object (e.g., `MyClass.class`)
- Only one thread can execute any static synchronized method of a class at a time

Equivalent synchronized block in a static method:

```java
public static void setObj(Object obj) {
    synchronized(StaticSynchronizedExchanger.class) {
        object = obj;
    }
}
```

## Using Both Synchronized Static and Instance Methods

A class can have both synchronized static and instance methods:

```java
private static Object staticObj = null;
private Object instanceObj = null;

public static synchronized void setStaticObj(Object obj) {
    staticObj = obj;
}

public synchronized void setInstanceObj(Object obj) {
    instanceObj = obj;
}
```

Key points:
- Static synchronized methods and instance synchronized methods use different monitor objects
- A thread executing a static synchronized method will not block threads from executing instance synchronized methods
- Different instances can execute their synchronized instance methods concurrently

## Using Different Monitor Objects

Different synchronized blocks within the same class can use different monitor objects:

```java
private Object monitor1 = new Object();
private Object monitor2 = new Object();
private int counter1 = 0;
private int counter2 = 0;

public void incCounter1() {
    synchronized(monitor1) {
        counter1++;
    }
}

public void incCounter2() {
    synchronized(monitor2) {
        counter2++;
    }
}
```

Since these blocks use different monitor objects, they do not mutually exclude threads. One thread can execute `incCounter1()` while another thread executes `incCounter2()` concurrently, even on the same instance.

## Sharing Monitor Objects Across Instances

Monitor objects can be shared between different instances of the same class or even between instances of different classes:

```java
public class SharedMonitorObject {
    private Object monitor = null;
    private int counter = 0;
    
    public SharedMonitorObject(Object monitor) {
        if(monitor == null) {
            throw new IllegalArgumentException("Monitor cannot be null");
        }
        this.monitor = monitor;
    }
    
    public void incCounter() {
        synchronized(monitor) {
            counter++;
        }
    }
}
```

Example usage:
```java
Object monitor1 = new Object();
SharedMonitorObject smo1 = new SharedMonitorObject(monitor1);
SharedMonitorObject smo2 = new SharedMonitorObject(monitor1);

// These will synchronize on the same monitor object
smo1.incCounter();
smo2.incCounter();

Object monitor2 = new Object();
SharedMonitorObject smo3 = new SharedMonitorObject(monitor2);
// This will use a different monitor object
smo3.incCounter();
```

Important note: Monitor objects cannot be null, or a NullPointerException will be thrown when trying to enter the synchronized block.

## Synchronized Blocks in Lambda Expressions

Synchronized blocks can also be used within lambda expressions:

```java
private static Object object = null;

public static synchronized void setObject(Object obj) {
    object = obj;
}

public static void consumeObject(Consumer<Object> consumer) {
    consumer.accept(object);
}

// Usage:
consumeObject(obj -> {
    synchronized(SynchronizedLambda.class) {
        System.out.println(obj);
    }
});
```

Key points:
- Lambda expressions do not have a `this` reference, so you cannot use `this` as a monitor object
- Use a monitor object that makes semantic sense (like the class object in this example)
- Ensure consistent use of monitor objects across related synchronized blocks

## Reentrance Rules

Java synchronized blocks are reentrant, meaning that a thread that already holds the lock on a monitor object can enter another synchronized block that uses the same monitor object:

```java
public synchronized void incAndGet() {
    inc();  // This method is also synchronized on the same object
    return count;
}

public synchronized void inc() {
    count++;
}
```

When a thread calls `incAndGet()`, it obtains the lock on the instance. When it then calls `inc()`, it is allowed to enter that method even though it's also synchronized, because the thread already holds the required lock.

## Visibility Guarantees

Synchronized blocks provide important visibility guarantees for variables shared between threads:

1. When a thread enters a synchronized block, it sees all changes made to variables by any thread that previously exited a synchronized block using the same monitor object
2. When a thread exits a synchronized block, all changes it made to variables will be visible to any thread that subsequently enters a synchronized block using the same monitor object

Example demonstrating visibility issues and fix:

```java
// Without synchronization - may not show correct count
public void incCount() {
    count++;
}

// With synchronization - guarantees visibility
public synchronized void incCount() {
    count++;
}
```

## Happens-Before Guarantee

Java synchronized blocks also provide a happens-before guarantee, which restricts the kinds of instruction reordering that can occur around synchronized blocks:

```java
public void set(Object obj) {
    synchronized(this) {
        count++;
        this.obj = obj;
    }
}
```

The happens-before guarantee ensures that:
1. All memory operations before entering a synchronized block complete before the synchronized block executes
2. All memory operations inside the synchronized block complete before exiting the block
3. These operations cannot be reordered in ways that would break the synchronization semantics

This prevents instruction reordering optimizations that could break thread safety.

## Limitations of Synchronized Blocks

Synchronized blocks have several limitations:

1. **Exclusivity**: Only one thread can enter a synchronized block at a time, which can be limiting when you want to allow multiple readers but restrict writers
2. **Fairness**: There's no guarantee about the order in which waiting threads get access to the synchronized block, which can lead to thread starvation
3. **Granularity**: Synchronization is all-or-nothing; you can't have more nuanced access control

For more advanced concurrency control, consider using the classes in the `java.util.concurrent` package, such as `ReadWriteLock`.

## Performance Considerations

Entering and exiting synchronized blocks incurs a performance overhead:

1. The overhead is minimal when no contention exists (when no other thread is trying to access the same synchronized block)
2. When contention occurs, the overhead increases significantly as threads must be blocked and later notified
3. Blocked threads also lose time waiting for the lock to become available

To minimize performance impact:
- Keep synchronized blocks as small as possible
- Avoid performing lengthy operations inside synchronized blocks
- Consider using alternative concurrency constructs for high-contention scenarios

## Synchronized Blocks in Clustered Environments

Java synchronized blocks only work within a single JVM:
- They cannot coordinate access between threads running in different JVMs or on different machines
- For distributed synchronization, you need alternative mechanisms like database locks or distributed lock managers

## Best Practices

1. **Don't use String constants as monitor objects**: String literals might be interned by the JVM, causing unintended lock sharing
   ```java
   // Bad practice
   synchronized("LOCK") { /* ... */ }
   ```

2. **Don't use primitive wrapper types as monitor objects**: These might also be pooled or cached by the JVM

3. **Use dedicated final Object fields as monitor objects**:
   ```java
   private final Object lock = new Object();
   
   public void someMethod() {
       synchronized(lock) {
           // Critical section
       }
   }
   ```

4. **Keep synchronized blocks small**: Only synchronize the critical sections that need protection

5. **Be consistent with monitor objects**: Use the same monitor object for related operations that need to be synchronized with each other

6. **Document your synchronization strategy**: Make it clear which monitor objects protect which data

7. **Consider alternatives**: For complex synchronization needs, explore the `java.util.concurrent` package