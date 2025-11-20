Here's the summarized content in Markdown format:

```markdown
# Java Deadlocks: Understanding and Prevention

## What is a Deadlock?
A deadlock occurs when two or more threads are blocked forever, each waiting for a resource held by another thread in the set.

## Deadlock Example with Locks
```java
// Thread 1
lock1.lock();
Thread.sleep(3000); // Simulate work
lock2.lock(); // Will block if Thread 2 has lock2
// Critical section
lock2.unlock();
lock1.unlock();

// Thread 2 (reverse order)
lock2.lock();
Thread.sleep(3000); // Simulate work
lock1.lock(); // Will block if Thread 1 has lock1
// Critical section
lock1.unlock();
lock2.unlock();
```

## Deadlock Example with Synchronized Blocks
```java
// Thread 1
synchronized(lock1) {
    Thread.sleep(3000);
    synchronized(lock2) { // Deadlock potential
        // Critical section
    }
}

// Thread 2 (reverse order)
synchronized(lock2) {
    Thread.sleep(3000);
    synchronized(lock1) { // Deadlock occurs
        // Critical section
    }
}
```

## The Four Necessary Conditions for Deadlock
1. **Mutual Exclusion**: Resources can only be held by one thread at a time
2. **Hold and Wait**: Threads hold resources while waiting for others
3. **No Preemption**: Resources cannot be forcibly taken from threads
4. **Circular Wait**: Threads form a circular chain waiting for resources

## Deadlock Consequences
- Threads block indefinitely
- Application may freeze
- Other threads trying to acquire involved locks also block

## Similar Problems to Deadlock
| Problem         | Description |
|----------------|------------|
| **Livelock**    | Threads keep retrying but make no progress |
| **Starvation**  | Thread is perpetually denied access to resources |
| **Nested Monitor Lockout** | Special case of deadlock with wait/notify |

## Prevention Techniques
1. **Lock Ordering**: Always acquire locks in a consistent global order
2. **Lock Timeout**: Use `tryLock()` with timeout
3. **Deadlock Detection**: Periodic checks for circular waits
4. **Avoid Nested Locks**: When possible, restructure code to need fewer locks

## Best Practices
- Minimize lock scope (duration)
- Reduce lock granularity (smaller critical sections)
- Use higher-level concurrency utilities when possible
- Document lock ordering policies
- Consider thread dumps for deadlock analysis

## Example: Safe Lock Ordering
```java
// Global lock ordering
private static final Object lock1 = new Object();
private static final Object lock2 = new Object();

// Thread 1 and Thread 2 both use this order:
synchronized(lock1) {
    synchronized(lock2) {
        // Critical section
    }
}
```

## Tools for Deadlock Detection
- `jstack` - Java stack trace tool
- VisualVM - Graphical monitoring
- Thread dump analysis tools
- Java Mission Control (JMC)

## Key Takeaways
- Deadlocks occur when all four necessary conditions are met
- Prevention is better than detection/recovery
- Consistent lock ordering is the most reliable prevention method
- Design concurrency carefully to minimize deadlock risk
``` 

This summary covers the essential aspects of Java deadlocks including examples, conditions, consequences, and prevention techniques in a concise Markdown format.