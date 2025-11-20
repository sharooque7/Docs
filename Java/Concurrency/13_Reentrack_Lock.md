# Java Locks and ReentrantLock

## Overview
Java's `Lock` interface (and its `ReentrantLock` implementation) provides a more flexible synchronization mechanism than synchronized blocks.

## Key Concepts

### Basic Lock Usage
```java
Lock lock = new ReentrantLock();
lock.lock();
try {
    // Critical section
} finally {
    lock.unlock();
}
```

### Comparison with Synchronized Blocks
| Feature               | Synchronized Blocks | Locks |
|-----------------------|---------------------|-------|
| Scope                 | Single method       | Across methods |
| Reentrancy            | Always              | Configurable |
| Fairness              | No guarantee        | Configurable |
| Try-lock capability   | No                  | Yes |
| Interruptible waits   | No                  | Yes |

### ReentrantLock Features
1. **Reentrancy**:
   - Same thread can acquire lock multiple times
   - Must release lock same number of times

2. **Fairness**:
   - Constructor parameter: `new ReentrantLock(true)`
   - Prevents thread starvation
   - Comes with performance cost

3. **Additional Methods**:
   - `tryLock()`: Non-blocking attempt
   - `lockInterruptibly()`: Responds to thread interruption
   - `getHoldCount()`: Number of locks by current thread
   - `isHeldByCurrentThread()`: Check lock ownership

### Common Patterns

#### Basic Usage
```java
Lock lock = new ReentrantLock();
// ...
lock.lock();
try {
    // Critical section
} finally {
    lock.unlock();
}
```

#### Try-Lock Pattern
```java
if (lock.tryLock()) {
    try {
        // Critical section
    } finally {
        lock.unlock();
    }
} else {
    // Alternative handling
}
```

#### Timed Try-Lock
```java
try {
    if (lock.tryLock(1, TimeUnit.SECONDS)) {
        try {
            // Critical section
        } finally {
            lock.unlock();
        }
    }
} catch (InterruptedException e) {
    // Handle interruption
}
```

### Potential Issues
1. **Starvation**:
   - Can occur without fairness guarantee
   - Solved by fair locks (`new ReentrantLock(true)`)

2. **Reentrance Lockout**:
   - Non-reentrant locks can cause deadlock
   - Thread blocks itself trying to re-lock

### Best Practices
1. Always unlock in `finally` block
2. Consider fairness needs vs performance
3. Prefer `tryLock()` when possible to avoid deadlocks
4. Use `lockInterruptibly()` for responsive cancellation

## Example: Concurrent Calculator
```java
public class Calculator {
    private int result = 0;
    private Lock lock = new ReentrantLock();
    
    public void add(int value) {
        lock.lock();
        try {
            result += value;
        } finally {
            lock.unlock();
        }
    }
    
    public void calculate(Calculation... calculations) {
        lock.lock();
        try {
            for (Calculation calc : calculations) {
                if (calc.type == ADD) add(calc.value);
                else subtract(calc.value);
            }
        } finally {
            lock.unlock();
        }
    }
}
```

## When to Use Locks vs Synchronized
- Use locks when you need:
  - Cross-method synchronization
  - Fairness guarantees
  - Try-lock functionality
  - More flexible control
- Use synchronized blocks for simpler cases
