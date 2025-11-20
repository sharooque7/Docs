# Deadlock Prevention and Detection Techniques in Java

## Introduction
- Techniques covered: lock reordering, timeout backoff, deadlock detection
- Assumes prior knowledge of Java deadlocks (see previous video)

## 1. Lock Reordering
- Simplest deadlock prevention technique
- Problem occurs when locks are taken in different orders by different threads
- Solution: Ensure all threads take locks in the same order

### Example Fix:
```java
// Runnable 1
synchronized(lock1) {
    synchronized(lock2) {
        // ...
    }
}

// Runnable 2 - Fixed to use same order
synchronized(lock1) {
    synchronized(lock2) {
        // ...
    }
}
```

## 2. Timeout Backoff
- Thread attempts to lock with a timeout
- If timeout occurs:
  - Release all currently held locks
  - Sleep for random time (prevents livelock)
  - Retry

### Implementation Notes:
- Use `tryLock(timeout)` instead of `lock()`
- Random sleep duration between retries (e.g., 0-100ms)
- Must release all locks if timeout occurs

### Example Code Structure:
```java
while(true) {
    if(tryLockBothLocks()) {
        try {
            // Do work
        } finally {
            unlockBoth();
        }
    } else {
        failureCount++;
        Thread.sleep(randomBackoffTime);
    }
}
```

## 3. Deadlock Detection
- More complex technique
- Uses a graph to track lock-thread dependencies
- Nodes represent locks and threads
- Edges represent:
  - Lock → Thread (owner)
  - Thread → Lock (waiting for)

### How It Works:
1. Before locking, check if adding the new lock would create a cycle
2. If cycle detected → potential deadlock
3. Can detect multiple independent deadlocks

### Graph Example:
```
Lock1 → Thread1 → Lock2 → Thread2 → Lock3 → Thread3
```
- No deadlock (no cycle)
- If Thread3 tries to lock Lock1 → cycle → deadlock

### Implementation Challenges:
- Need to maintain accurate graph
- Must handle concurrent modifications
- Complex to implement correctly

## Important Notes
- Sample code available in GitHub repository (link in video description)
- Implementations shown are for educational purposes
- Not guaranteed production-ready
- For production, consider using existing libraries

## Conclusion
- Lock reordering: simplest solution when possible
- Timeout backoff: more general but complex
- Deadlock detection: most complex but most comprehensive

Remember to:
- Like/subscribe for more content
- Check description for code and text versions
- Study the GitHub examples