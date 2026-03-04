# **CAS in Java's Concurrent Collections** 🔄

## **The Short Answer:**

**YES!** Most modern concurrent collections use CAS (Compare-And-Swap) as their foundation, but they combine it with different strategies:

| Collection                | Uses CAS?  | Primary Mechanism                     |
| ------------------------- | ---------- | ------------------------------------- |
| **ConcurrentHashMap**     | ✅ Yes     | CAS + synchronized(bucket)            |
| **ConcurrentLinkedQueue** | ✅ Yes     | 100% CAS (lock-free)                  |
| **ConcurrentLinkedDeque** | ✅ Yes     | 100% CAS (lock-free)                  |
| **ConcurrentSkipListMap** | ✅ Yes     | CAS + lock-free navigation            |
| **ConcurrentSkipListSet** | ✅ Yes     | CAS + lock-free navigation            |
| **CopyOnWriteArrayList**  | ❌ No      | ReentrantLock + array copy            |
| **CopyOnWriteArraySet**   | ❌ No      | ReentrantLock + array copy            |
| **LinkedBlockingQueue**   | ⚠️ Partial | Locks (putLock/takeLock)              |
| **ArrayBlockingQueue**    | ❌ No      | Single ReentrantLock                  |
| **PriorityBlockingQueue** | ❌ No      | Single ReentrantLock                  |
| **DelayQueue**            | ❌ No      | ReentrantLock + PriorityQueue         |
| **SynchronousQueue**      | ⚠️ Both    | CAS for fair mode, locks for non-fair |

---

## **1. 100% CAS (Lock-Free) Collections** 🔓

### **ConcurrentLinkedQueue**

```java
public class ConcurrentLinkedQueue<E> {
    // 100% CAS - no locks at all!

    private static class Node<E> {
        volatile E item;
        volatile Node<E> next;
    }

    public boolean offer(E e) {
        Node<E> newNode = new Node<E>(e);
        for (Node<E> t = tail, p = t;;) {
            Node<E> q = p.next;
            if (q == null) {
                // CAS to set next pointer
                if (p.casNext(null, newNode)) {
                    // CAS to update tail
                    casTail(t, newNode);
                    return true;
                }
            } else if (p == q) {
                // Handle removed nodes
                p = (t != (t = tail)) ? t : head;
            } else {
                p = q;
            }
        }
    }
}
```

### **ConcurrentLinkedDeque**

```java
// Similar to ConcurrentLinkedQueue but for both ends
// Uses CAS for prev/next pointers
```

---

## **2. Hybrid CAS + Synchronized** 🔐

### **ConcurrentHashMap (Java 8+)**

```java
// Uncontended: CAS only
if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value, null))) {
    break;  // CAS success - no lock!
}

// Contended: synchronized on bucket
synchronized (f) {  // f = first node in bucket
    // Bucket-specific operations
}
```

---

## **3. CAS + Lock-Free Navigation** 🧭

### **ConcurrentSkipListMap**

```java
// Uses CAS for node links, but also lock-free traversal
// Skip list nodes have multiple levels of pointers
// CAS used to update pointers atomically
```

---

## **4. Lock-Based Collections** 🔒

### **CopyOnWriteArrayList** (No CAS)

```java
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();  // ALWAYS locks
    try {
        // Copy array, add element
        Object[] elements = getArray();
        int len = elements.length;
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        newElements[len] = e;
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
```

### **ArrayBlockingQueue** (No CAS)

```java
public void put(E e) throws InterruptedException {
    final ReentrantLock lock = this.lock;
    lock.lockInterruptibly();  // Single lock for all operations
    try {
        while (count == items.length)
            notFull.await();  // Condition wait
        enqueue(e);
    } finally {
        lock.unlock();
    }
}
```

### **LinkedBlockingQueue** (Partial)

```java
// Two locks: putLock and takeLock
// But still uses locks, not CAS for main operations
private final ReentrantLock putLock = new ReentrantLock();
private final ReentrantLock takeLock = new ReentrantLock();

public void put(E e) {
    putLock.lock();  // Lock for puts
    try {
        // Add to queue
    } finally {
        putLock.unlock();
    }
}
```

---

## **5. CAS vs Locks - Why Different Choices?** 🤔

### **CAS-Based (Lock-Free) Advantages:**

| Aspect                 | Benefit                    |
| ---------------------- | -------------------------- |
| **No blocking**        | Threads never wait         |
| **No deadlocks**       | Can't deadlock             |
| **Priority inversion** | Doesn't exist              |
| **Scalability**        | Excellent under contention |

### **Lock-Based Advantages:**

| Aspect                | Benefit                       |
| --------------------- | ----------------------------- |
| **Simplicity**        | Easier to implement correctly |
| **Condition waiting** | Can wait for conditions       |
| **Bounded queues**    | Can block when full/empty     |
| **Fairness**          | Can implement fair policies   |

---

## **6. Decision Tree for Collections** 🌳

```
Need concurrent collection?
        │
        ├─► Need sorted order?
        │       ├─► Yes → ConcurrentSkipListMap/Set (CAS)
        │       └─► No  → Continue
        │
        ├─► Need queue/deque?
        │       ├─► Lock-free, non-blocking → ConcurrentLinkedQueue/Deque (100% CAS)
        │       ├─► Blocking, bounded → ArrayBlockingQueue (Lock)
        │       ├─► Blocking, unbounded → LinkedBlockingQueue (Lock)
        │       └─► Priority order → PriorityBlockingQueue (Lock)
        │
        ├─► Need map?
        │       ├─► General purpose → ConcurrentHashMap (CAS + sync)
        │       └─► Sorted → ConcurrentSkipListMap (CAS)
        │
        └─► Need list/set?
                ├─► Read-heavy, writes rare → CopyOnWriteArrayList/Set (Lock)
                └─► Other cases → Synchronized wrapper (Lock)
```

---

## **7. Performance Comparison** 📊

```
Collection              | Mechanism  | Read Concurrency | Write Concurrency
------------------------|------------|------------------|------------------
ConcurrentLinkedQueue   | 100% CAS   | Unlimited        | Unlimited
ConcurrentHashMap       | CAS + sync | Unlimited        | Scales with cores
ConcurrentSkipListMap   | CAS        | Unlimited        | Unlimited
CopyOnWriteArrayList    | Lock       | Unlimited        | Single thread
ArrayBlockingQueue      | Lock       | Single lock      | Single lock
LinkedBlockingQueue     | 2 locks    | Good (separate)  | Good (separate)
```

---

## **8. Why Not All Use CAS?** 🤷

### **CopyOnWriteArrayList can't use CAS because:**

1. **Array replacement is bulk operation** - CAS works on single memory location
2. **Need atomic whole-array replacement** - can't do with CAS alone
3. **Multiple updates to same array** - would need complex coordination

### **Blocking queues need:**

1. **Condition waiting** (wait when empty/full) - CAS can't block
2. **Fairness guarantees** - CAS is inherently unfair
3. **Bounded capacity management** - needs coordination

---

## **9. The CAS-Only Champions** 🏆

Collections that are **100% lock-free (CAS only):**

1. **ConcurrentLinkedQueue**
2. **ConcurrentLinkedDeque**
3. **ConcurrentSkipListMap** (implementation details)
4. **ConcurrentSkipListSet** (backed by map)
5. **Exchanger** (java.util.concurrent)
6. **Atomic classes** (AtomicInteger, AtomicReference, etc.)

---

## **10. Quick Reference** 📝

```java
// 100% CAS (Lock-free)
ConcurrentLinkedQueue<String> q1 = new ConcurrentLinkedQueue<>();
ConcurrentLinkedDeque<String> d1 = new ConcurrentLinkedDeque<>();
AtomicInteger ai = new AtomicInteger();

// CAS + synchronized
ConcurrentHashMap<String, String> m1 = new ConcurrentHashMap<>();

// CAS + lock-free navigation
ConcurrentSkipListMap<String, String> m2 = new ConcurrentSkipListMap<>();
ConcurrentSkipListSet<String> s1 = new ConcurrentSkipListSet<>();

// Locks only
CopyOnWriteArrayList<String> l1 = new CopyOnWriteArrayList<>();
ArrayBlockingQueue<String> q2 = new ArrayBlockingQueue<>(10);
LinkedBlockingQueue<String> q3 = new LinkedBlockingQueue<>();
PriorityBlockingQueue<String> q4 = new PriorityBlockingQueue<>();
```

---

## **One-Liner Summary:**

> "Concurrent collections use CAS where possible for lock-free operations, but fall back to locks when they need blocking behavior, condition waiting, or bulk atomic updates that CAS can't provide alone."
