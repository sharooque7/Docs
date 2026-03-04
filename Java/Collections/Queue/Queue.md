# **Complete Java Queue Implementations - Interview Preparation Guide** 🔄

*A comprehensive summary of all Queue implementations with code examples, use cases, and interview questions*

---

## **📊 QUICK REFERENCE TABLE**

| Queue | Thread-Safe | Bounded | Blocking | Nulls | Internal | Best For |
|-------|-------------|---------|----------|-------|----------|----------|
| **LinkedList** | ❌ | ❌ | ❌ | ✅ | Doubly Linked List | General FIFO, also List/Deque |
| **ArrayDeque** | ❌ | ❌ | ❌ | ❌ | Circular Array | High performance, stack/queue |
| **PriorityQueue** | ❌ | ❌ | ❌ | ❌ | Binary Heap | Priority-based ordering |
| **ArrayBlockingQueue** | ✅ | ✅ | ✅ | ❌ | Circular Array | Bounded producer-consumer |
| **LinkedBlockingQueue** | ✅ | Optional | ✅ | ❌ | Linked Nodes | High throughput producer-consumer |
| **PriorityBlockingQueue** | ✅ | ❌ | ✅ | ❌ | Binary Heap | Thread-safe priority scheduling |
| **SynchronousQueue** | ✅ | ✅ | ✅ | ❌ | Direct handoff | Thread handoff (CSP style) |
| **DelayQueue** | ✅ | ❌ | ✅ | ❌ | PriorityQueue | Scheduled future tasks |
| **ConcurrentLinkedQueue** | ✅ | ❌ | ❌ | ❌ | Lock-free linked list | High concurrency, non-blocking |
| **LinkedTransferQueue** | ✅ | ❌ | ✅ | ❌ | Linked nodes | Advanced producer-consumer |
| **ArrayDeque as Stack** | ❌ | ❌ | ❌ | ❌ | Circular Array | LIFO (better than Stack class) |

---

## **📋 QUEUE HIERARCHY**

```
                    Collection
                        ↑
                    Queue Interface
                   ╱          ╲
              Deque           BlockingQueue
              ╱    ╲           ╱    ╲    ╲    ╲    ╲
        ArrayDeque  LinkedList  Array-  Linked- Priority- Synchronous- Delay-
                                Blocking  Blocking  Blocking  Queue    Queue
                                  Queue    Queue     Queue
                                          
                    TransferQueue (extends BlockingQueue)
                           ↑
                    LinkedTransferQueue
```

---

## **1. LINKEDLIST - Most Versatile Queue** 🔗

```java
Queue<String> queue = new LinkedList<>();

// Queue operations
queue.offer("A");      // Add to tail (returns true/false)
queue.add("B");        // Add to tail (throws exception if full)
queue.poll();          // Remove from head (returns null if empty)
queue.remove();        // Remove from head (throws exception if empty)
queue.peek();          // View head (returns null if empty)
queue.element();       // View head (throws exception if empty)

// Also works as Deque and List!
Deque<String> deque = new LinkedList<>();
List<String> list = new LinkedList<>();
```

### **Internal Structure:**
- Doubly-linked list with Node objects
- Each node has prev, next, item references

### **Key Features:**
- ✅ Implements Queue, Deque, and List
- ✅ O(1) add/remove at ends
- ✅ O(1) insert/remove in middle (with iterator)
- ✅ Allows null elements
- ❌ More memory overhead (node objects)
- ❌ Poor cache locality

### **Interview Questions:**
**Q: When to use LinkedList as Queue?**
> When you need both Queue and List operations, or need null elements, or frequent middle insertions.

**Q: LinkedList vs ArrayDeque as Queue?**  
> ArrayDeque is faster (better cache locality), uses less memory. Use LinkedList only if you need List features or nulls.

---

## **2. ARRAYDEQUE - Most Efficient Queue/Stack** ⚡

```java
// As Queue (FIFO)
Queue<String> queue = new ArrayDeque<>();
queue.offer("A");
queue.offer("B");
String first = queue.poll();  // "A"

// As Deque (double-ended)
Deque<String> deque = new ArrayDeque<>();
deque.addFirst("A");    // [A]
deque.addLast("Z");     // [A, Z]
deque.removeFirst();    // "A" → [Z]

// As Stack (LIFO) - BETTER THAN STACK CLASS!
Deque<String> stack = new ArrayDeque<>();
stack.push("A");        // [A]
stack.push("B");        // [B, A]
String top = stack.pop(); // "B" → [A]
```

### **Internal Structure:**
- Circular array that grows as needed
- Head and tail pointers for O(1) add/remove at both ends

### **Key Features:**
- ✅ Best performance for queue/stack operations
- ✅ O(1) amortized for all operations
- ✅ Excellent cache locality (array-based)
- ✅ Can be used as Stack (better than legacy Stack class)
- ❌ No null elements allowed
- ❌ Not thread-safe

### **Interview Questions:**
**Q: Why is ArrayDeque better than LinkedList for queue?**
> ArrayDeque: contiguous memory (cache-friendly), less overhead (no node objects). LinkedList: scattered nodes (cache misses).

**Q: Why is ArrayDeque better than Stack class?**  
> Stack extends Vector (synchronized, legacy). ArrayDeque is faster, not synchronized, designed for stack usage.

**Q: When does ArrayDeque resize?**  
> Doubles capacity when full (like ArrayList). Initial capacity can be set for optimization.

---

## **3. PRIORITYQUEUE - Priority-Based Ordering** 📊

```java
// Natural ordering (min-heap)
Queue<Integer> pq = new PriorityQueue<>();
pq.offer(5);  // [5]
pq.offer(1);  // [1, 5]
pq.offer(3);  // [1, 5, 3]
pq.poll();    // 1 (removes smallest)

// Custom ordering (max-heap)
Queue<Task> taskQueue = new PriorityQueue<>(
    (t1, t2) -> t2.priority - t1.priority  // Higher priority first
);

// Or using Comparator
Queue<Customer> vipQueue = new PriorityQueue<>(
    Comparator.comparing(Customer::isVip).reversed()
        .thenComparing(Customer::arrivalTime)
);
```

### **Internal Structure:**
- Binary heap (array representation)
- Min-heap by default (smallest element at root)
- Complete binary tree in array

### **Key Features:**
- ✅ Elements ordered by priority (not FIFO)
- ✅ O(log n) offer and poll
- ✅ O(1) peek (view highest priority)
- ✅ Custom ordering with Comparator
- ❌ Not thread-safe
- ❌ No null elements
- ❌ Iteration not in priority order

### **Interview Questions:**
**Q: How does PriorityQueue work internally?**
> Binary heap implemented as array. Parent at index i, children at 2i+1 and 2i+2. Heap property: parent ≤ children (min-heap).

**Q: PriorityQueue vs TreeSet?**  
> PriorityQueue allows duplicates, only access top element. TreeSet no duplicates, can iterate all in order.

**Q: How to implement max-heap?**  
> new PriorityQueue<>(Collections.reverseOrder()) or custom Comparator.

---

## **4. ARRAYBLOCKINGQUEUE - Bounded Thread-Safe Queue** 🔒

```java
// Fixed-size blocking queue
BlockingQueue<String> queue = new ArrayBlockingQueue<>(10);

// Producer thread
new Thread(() -> {
    try {
        queue.put("task");      // Blocks if full
        queue.offer("task", 1, TimeUnit.SECONDS); // Times out if full
    } catch (InterruptedException e) {}
}).start();

// Consumer thread
new Thread(() -> {
    try {
        String task = queue.take();  // Blocks if empty
        String task2 = queue.poll(1, TimeUnit.SECONDS); // Times out
    } catch (InterruptedException e) {}
}).start();

// Non-blocking methods
queue.offer("task");  // Returns false if full
queue.poll();         // Returns null if empty
```

### **Internal Structure:**
- Circular array with ReentrantLock
- Single lock for both put and take (Java 8)
- Two conditions: notFull and notEmpty

### **Key Features:**
- ✅ Fixed capacity (bounded)
- ✅ Blocking operations (put/take)
- ✅ Thread-safe
- ✅ Fairness policy optional (fair lock)
- ❌ Single lock (can be contention bottleneck)

### **Interview Questions:**
**Q: ArrayBlockingQueue vs LinkedBlockingQueue?**
> ArrayBlockingQueue: fixed size, single lock, better cache locality. LinkedBlockingQueue: optional bound, two locks (put/take), better throughput.

**Q: What's the fairness policy?**  
> If true, longest-waiting thread gets access first (reduces starvation, hurts throughput).

---

## **5. LINKEDBLOCKINGQUEUE - High Throughput Blocking Queue** 🔗🔒

```java
// Unbounded (Integer.MAX_VALUE)
BlockingQueue<String> unbounded = new LinkedBlockingQueue<>();

// Bounded
BlockingQueue<String> bounded = new LinkedBlockingQueue<>(1000);

// Producer-Consumer pattern
class Producer implements Runnable {
    private BlockingQueue<String> queue;
    
    public void run() {
        while (true) {
            String item = produce();
            queue.put(item);  // Blocks if full
        }
    }
}

class Consumer implements Runnable {
    public void run() {
        while (true) {
            String item = queue.take();  // Blocks if empty
            process(item);
        }
    }
}
```

### **Internal Structure:**
- Linked nodes (singly-linked)
- Two locks: putLock and takeLock (separate!)
- Separate conditions for each lock

### **Key Features:**
- ✅ Two locks → higher throughput (put and take can proceed simultaneously)
- ✅ Optional bounding (default unbounded)
- ✅ Thread-safe
- ✅ Better concurrency than ArrayBlockingQueue
- ❌ More memory overhead (nodes)

### **Interview Questions:**
**Q: Why is LinkedBlockingQueue faster for high concurrency?**
> Two separate locks allow simultaneous put and take operations. ArrayBlockingQueue uses single lock.

**Q: What's the risk of unbounded queue?**  
> Can lead to OutOfMemoryError if producer outpaces consumer indefinitely.

---

## **6. PRIORITYBLOCKINGQUEUE - Thread-Safe Priority Queue** 🎯

```java
// Thread-safe priority queue
BlockingQueue<Task> queue = new PriorityBlockingQueue<>();

// Producer (any thread)
queue.put(new Task("critical", 1));  // Priority 1 (highest)
queue.put(new Task("normal", 5));

// Consumer (worker thread)
while (true) {
    Task task = queue.take();  // Always gets highest priority task
    task.execute();
}

// Can be unbounded but careful!
PriorityBlockingQueue<MyTask> pq = new PriorityBlockingQueue<>(11, 
    (a, b) -> b.priority - a.priority);  // Max-heap
```

### **Internal Structure:**
- Binary heap with ReentrantLock
- Same as PriorityQueue but thread-safe
- Dynamically grows (unbounded)

### **Key Features:**
- ✅ Thread-safe priority queue
- ✅ O(log n) offer/take
- ✅ Unbounded (can grow)
- ✅ Iterator weakly consistent
- ❌ No blocking on put (unbounded)

### **Interview Questions:**
**Q: When to use PriorityBlockingQueue?**
> When you need thread-safe priority processing (task scheduling, emergency handling).

**Q: What happens if queue is empty?**  
> take() blocks until element available. poll() returns null.

---

## **7. SYNCHRONOUSQUEUE - Direct Handoff Queue** 🤝

```java
// No capacity - each put must wait for take
BlockingQueue<String> queue = new SynchronousQueue<>();

// Thread 1 (Producer)
new Thread(() -> {
    try {
        System.out.println("Putting...");
        queue.put("DATA");  // Blocks until someone takes
        System.out.println("Put complete");
    } catch (InterruptedException e) {}
}).start();

Thread.sleep(1000);
System.out.println("Queue size: " + queue.size());  // Always 0!

// Thread 2 (Consumer)
new Thread(() -> {
    try {
        System.out.println("Taking...");
        String data = queue.take();  // Blocks until someone puts
        System.out.println("Got: " + data);
    } catch (InterruptedException e) {}
}).start();

// Also works with fair ordering
SynchronousQueue<String> fairQueue = new SynchronousQueue<>(true);
```

### **Internal Structure:**
- No internal capacity!
- Each put must wait for corresponding take
- Uses dual stacks/queues (TransferStack/TransferQueue)

### **Key Features:**
- ✅ Zero capacity
- ✅ Each put blocks until take occurs
- ✅ Perfect for handoff scenarios
- ✅ Fairness option available
- ❌ Can't peek (always empty)
- ❌ Can deadlock if not paired

### **Interview Questions:**
**Q: Use case for SynchronousQueue?**
> Direct thread handoff, work stealing, Executors.newCachedThreadPool() uses it internally.

**Q: How is it different from other queues?**  
> No storage - rendezvous point for threads. Like CSP channels in Go.

---

## **8. DELAYQUEUE - Scheduled Future Tasks** ⏰

```java
// Elements must implement Delayed
class DelayedTask implements Delayed {
    private String name;
    private long triggerTime;
    
    public DelayedTask(String name, long delay, TimeUnit unit) {
        this.name = name;
        this.triggerTime = System.currentTimeMillis() + 
                          unit.toMillis(delay);
    }
    
    @Override
    public long getDelay(TimeUnit unit) {
        long diff = triggerTime - System.currentTimeMillis();
        return unit.convert(diff, TimeUnit.MILLISECONDS);
    }
    
    @Override
    public int compareTo(Delayed other) {
        DelayedTask that = (DelayedTask) other;
        return Long.compare(this.triggerTime, that.triggerTime);
    }
    
    public String toString() { return name; }
}

// Usage
BlockingQueue<DelayedTask> queue = new DelayQueue<>();
queue.put(new DelayedTask("Task1", 5, TimeUnit.SECONDS));
queue.put(new DelayedTask("Task2", 2, TimeUnit.SECONDS));

// Consumer - only gets expired tasks
while (true) {
    DelayedTask task = queue.take();  // Blocks until next task expires
    System.out.println("Executing: " + task);
}
```

### **Internal Structure:**
- PriorityQueue internally (sorted by delay)
- ReentrantLock for thread-safety

### **Key Features:**
- ✅ Elements only available after delay
- ✅ Ordered by expiration time
- ✅ Thread-safe
- ✅ Perfect for scheduled tasks
- ❌ Elements must implement Delayed

### **Interview Questions:**
**Q: How does DelayQueue know when to release elements?**
> Each element provides getDelay() - queue polls head repeatedly until delay ≤ 0.

**Q: Real-world use cases?**  
> Scheduled task execution, retry queues, connection pools, cache expiration.

---

## **9. CONCURRENTLINKEDQUEUE - Lock-Free High Concurrency** 🔓

```java
// Lock-free, non-blocking queue
Queue<String> queue = new ConcurrentLinkedQueue<>();

// Multiple threads can add/remove without locks
queue.offer("A");
queue.offer("B");
String head = queue.poll();  // "A"

// Thread-safe iteration
for (String item : queue) {  // No ConcurrentModificationException!
    System.out.println(item);
}

// Size is O(n) - use with caution!
int size = queue.size();  // Can be expensive!
```

### **Internal Structure:**
- Michael & Scott lock-free algorithm
- CAS (Compare-And-Swap) operations
- Singly-linked list with head/tail pointers

### **Key Features:**
- ✅ Lock-free (no blocking, no locks)
- ✅ Wait-free (progress guaranteed)
- ✅ Excellent scalability
- ✅ Weakly consistent iterators
- ❌ size() is O(n) - not constant time
- ❌ No blocking operations

### **Interview Questions:**
**Q: How does ConcurrentLinkedQueue achieve thread-safety without locks?**
> Uses CAS (Compare-And-Swap) atomic operations for head/tail updates. Retry on failure.

**Q: When to use ConcurrentLinkedQueue vs BlockingQueue?**
> Use CLQ when you don't need blocking (non-blocking consumers). Use BlockingQueue when consumers should wait.

---

## **10. LINKEDTRANSFERQUEUE - Advanced Producer-Consumer** 🔄

```java
TransferQueue<String> queue = new LinkedTransferQueue<>();

// Producer with transfer() - waits for consumer
new Thread(() -> {
    try {
        queue.transfer("URGENT");  // Blocks until consumer receives
        System.out.println("Message delivered!");
    } catch (InterruptedException e) {}
}).start();

// Consumer
new Thread(() -> {
    try {
        Thread.sleep(1000);
        String msg = queue.take();  // Receives immediately
        System.out.println("Got: " + msg);
    } catch (InterruptedException e) {}
}).start();

// Check for waiting consumers
if (queue.hasWaitingConsumer()) {
    System.out.println("Consumer waiting: " + 
                       queue.getWaitingConsumerCount());
}

// Try transfer with timeout
boolean success = queue.tryTransfer("DATA", 1, TimeUnit.SECONDS);
```

### **Internal Structure:**
- Extended LinkedBlockingQueue with transfer methods
- Dual data structure for handoff

### **Key Features:**
- ✅ transfer() - waits for consumer
- ✅ tryTransfer() with timeout
- ✅ Check waiting consumers
- ✅ More features than BlockingQueue
- ✅ High performance

### **Interview Questions:**
**Q: transfer() vs put() difference?**
> put() just adds to queue. transfer() blocks until consumer actually receives the element (handoff guaranteed).

**Q: When to use LinkedTransferQueue?**
> When you need producer to know element was consumed (reliable delivery), or advanced handoff patterns.

---

## **📝 QUEUE METHODS COMPARISON**

### **Core Queue Operations:**

| Operation | Throws Exception | Returns Special Value | Blocks | Times Out |
|-----------|------------------|----------------------|--------|-----------|
| **Insert** | `add(e)` | `offer(e)` | `put(e)` | `offer(e, time, unit)` |
| **Remove** | `remove()` | `poll()` | `take()` | `poll(time, unit)` |
| **Examine** | `element()` | `peek()` | N/A | N/A |

### **Deque Operations:**

| Operation | First (Exception) | First (Special) | Last (Exception) | Last (Special) |
|-----------|------------------|------------------|------------------|----------------|
| **Insert** | `addFirst(e)` | `offerFirst(e)` | `addLast(e)` | `offerLast(e)` |
| **Remove** | `removeFirst()` | `pollFirst()` | `removeLast()` | `pollLast()` |
| **Examine** | `getFirst()` | `peekFirst()` | `getLast()` | `peekLast()` |

---

## **🎯 WHEN TO USE WHICH QUEUE**

### **Single-threaded applications:**
- **General FIFO**: `ArrayDeque` (fastest)
- **Need nulls/List features**: `LinkedList`
- **Priority ordering**: `PriorityQueue`

### **Multi-threaded applications:**
- **Producer-Consumer, bounded**: `ArrayBlockingQueue`
- **Producer-Consumer, high throughput**: `LinkedBlockingQueue`
- **Priority processing**: `PriorityBlockingQueue`
- **Non-blocking, high concurrency**: `ConcurrentLinkedQueue`
- **Direct thread handoff**: `SynchronousQueue`
- **Scheduled tasks**: `DelayQueue`
- **Reliable delivery**: `LinkedTransferQueue`

### **Special purposes:**
- **Stack (LIFO)**: `ArrayDeque` (not Stack!)
- **Double-ended operations**: `ArrayDeque` or `LinkedList`
- **Work stealing**: `ForkJoinPool` queues

---

## **📝 COMMON INTERVIEW QUESTIONS**

### **Q1: ArrayDeque vs LinkedList as Queue?**
> ArrayDeque: faster (cache locality), less memory, no nulls. LinkedList: nulls allowed, implements List.

### **Q2: PriorityQueue vs TreeSet?**
> PriorityQueue: duplicates allowed, only access head. TreeSet: no duplicates, can iterate all in sorted order.

### **Q3: ArrayBlockingQueue vs LinkedBlockingQueue?**
> ABQ: fixed size, single lock, better cache locality. LBQ: optional bound, two locks, better throughput.

### **Q4: How does DelayQueue work?**
> PriorityQueue internally, elements only available when getDelay() ≤ 0.

### **Q5: What's the point of SynchronousQueue?**
> Zero capacity, direct handoff between threads - used in cached thread pools.

### **Q6: ConcurrentLinkedQueue vs LinkedBlockingQueue?**
> CLQ: non-blocking, CAS-based, no waiting. LBQ: blocking, lock-based, supports waiting consumers.

### **Q7: How to implement stack in Java?**
> Use ArrayDeque, not Stack class: `Deque<T> stack = new ArrayDeque<>();`

### **Q8: PriorityQueue internal structure?**
> Binary heap (array). Parent at i, children at 2i+1, 2i+2. Min-heap by default.

### **Q9: What's transfer() in LinkedTransferQueue?**
> Waits until consumer receives element - useful for guaranteed delivery.

### **Q10: When would queue size() be O(n)?**
> ConcurrentLinkedQueue - size() traverses entire queue (no atomic size counter).

---

## **💡 KEY TAKEAWAYS**

1. **Default FIFO choice**: `ArrayDeque` (single-threaded)
2. **Need priority**: `PriorityQueue` (single-threaded)
3. **Producer-consumer**: `BlockingQueue` implementations
4. **High concurrency, non-blocking**: `ConcurrentLinkedQueue`
5. **Sorted + concurrent**: `PriorityBlockingQueue`
6. **Scheduled tasks**: `DelayQueue`
7. **Stack**: `ArrayDeque` (never `Stack` class!)
8. **Direct handoff**: `SynchronousQueue`
9. **Reliable delivery**: `LinkedTransferQueue`

---

## **🚀 QUICK CODE SNIPPETS**

```java
// Basic FIFO
Queue<String> queue = new ArrayDeque<>();
queue.offer("A");
String head = queue.poll();

// Priority queue (min-heap)
Queue<Integer> pq = new PriorityQueue<>();
pq.offer(5); pq.offer(1); pq.offer(3);
int smallest = pq.poll();  // 1

// Blocking queue (producer-consumer)
BlockingQueue<String> bq = new LinkedBlockingQueue<>(100);
bq.put("task");              // Blocks if full
String task = bq.take();     // Blocks if empty

// Delay queue (scheduled tasks)
class MyTask implements Delayed { ... }
BlockingQueue<MyTask> dq = new DelayQueue<>();

// Stack using ArrayDeque
Deque<String> stack = new ArrayDeque<>();
stack.push("A");
String top = stack.pop();

// Transfer queue (reliable handoff)
TransferQueue<String> tq = new LinkedTransferQueue<>();
tq.transfer("data");  // Waits for consumer
```

---

*Happy Interview Prep! 🎉*