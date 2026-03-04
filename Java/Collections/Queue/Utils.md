# Complete Queue Utility Classes Guide 🛠️

*A comprehensive guide to all utility methods for working with Queues in Java (JDK, Apache Commons, and Guava)*

---

## **📋 OVERVIEW**

Unlike Maps, Sets, and Lists, the **JDK does not have a dedicated `QueueUtils` class** in `java.util.Collections`. However, utility methods for queues are available through:

| Library | Utility Class | Key Features |
|---------|---------------|--------------|
| **JDK** | `Collections` class | `asLifoQueue()`, `synchronizedQueue()`, `checkedQueue()` |
| **Apache Commons** | `QueueUtils` | Predicated queues, transforming queues, synchronized/unmodifiable decorators |
| **Google Guava** | `Queues` class | Queue creation utilities, `drain()` methods for BlockingQueue |

---

## **1. JDK QUEUE UTILITIES (Standard Library)** ☕

### **1.1 Collections Utility Class Methods**

```java
import java.util.Collections;

// ===== asLifoQueue() - Create LIFO Queue View =====
Deque<String> deque = new ArrayDeque<>();
deque.push("A");
deque.push("B");
deque.push("C");

// View deque as LIFO queue (stack behavior)
Queue<String> lifoQueue = Collections.asLifoQueue(deque);

// Behaves as LIFO - accesses last element
String top = lifoQueue.remove();  // "C" (removes from end)
String next = lifoQueue.poll();   // "B"

// ===== synchronizedQueue() - Thread-Safe Wrapper =====
Queue<String> queue = new LinkedList<>();
Queue<String> syncQueue = Collections.synchronizedQueue(queue);

// Must synchronize on iteration!
synchronized(syncQueue) {
    for (String s : syncQueue) {
        // process
    }
}

// ===== checkedQueue() - Type-Safe Wrapper (Java 8+) =====
Queue<String> checkedQueue = Collections.checkedQueue(
    new LinkedList<>(), 
    String.class
);

// Prevents heap pollution
Queue rawQueue = checkedQueue;
// rawQueue.add(123);  // ❌ ClassCastException at runtime!

// ===== Unmodifiable Queue via unmodifiableCollection =====
Queue<String> queue = new LinkedList<>();
queue.offer("A");
queue.offer("B");

Collection<String> unmodCollection = Collections.unmodifiableCollection(queue);
// unmodCollection.add("C");  // ❌ UnsupportedOperationException!

// But note: this returns Collection, not Queue - lose Queue methods
// To get Queue, need to wrap:
Queue<String> unmodQueue = (Queue<String>) Collections.unmodifiableCollection(queue);
// Cast works but loses compile-time safety
```

### **1.2 Java 9+ Factory Methods - But No Queue.of()**

```java
// IMPORTANT: List, Set, Map have of() methods, but Queue does NOT!
// ❌ No such method:
// Queue.of("A", "B", "C");  // Doesn't exist!

// Workaround: Create from List
Queue<String> queue = new LinkedList<>(List.of("A", "B", "C"));

// For immutable queue, use Guava or Apache Commons
```

### **1.3 Queue Interface Default Methods (Java 8+)**

```java
// While not a utility class, these Queue methods are worth noting
Queue<String> queue = new LinkedList<>();

// offer() vs add()
queue.offer("A");  // Returns false if queue full (preferred for bounded queues)
queue.add("B");    // Throws exception if queue full

// poll() vs remove()
String s1 = queue.poll();   // Returns null if empty
String s2 = queue.remove(); // Throws exception if empty

// peek() vs element()
String s3 = queue.peek();    // Returns null if empty
String s4 = queue.element(); // Throws exception if empty

// Java 8+ forEach
queue.forEach(System.out::println);

// Remove if
queue.removeIf(s -> s.startsWith("A"));
```

---

## **2. APACHE COMMONS QUEUEUTILS** 🐘

### **Maven Dependency**
```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.4</version>
</dependency>
```

### **2.1 Basic Queue Operations** 

```java
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.Queue;

Queue<String> queue = new LinkedList<>();

// Empty queue utilities
Queue<String> empty = QueueUtils.emptyQueue();  // Type-safe empty queue
boolean isEmpty = empty.isEmpty();  // true

// Synchronized queue (thread-safe)
Queue<String> syncQueue = QueueUtils.synchronizedQueue(queue);
// All operations are synchronized

// Must still synchronize on iteration!
synchronized(syncQueue) {
    for (String s : syncQueue) {
        // process
    }
}
```

### **2.2 Unmodifiable Queue**

```java
import org.apache.commons.collections4.QueueUtils;

Queue<String> original = new LinkedList<>();
original.offer("A");
original.offer("B");
original.offer("C");

// Create read-only view
Queue<String> unmodifiable = QueueUtils.unmodifiableQueue(original);

// Read operations OK
String head = unmodifiable.peek();  // "A"
int size = unmodifiable.size();      // 3

// Write operations throw UnsupportedOperationException
// unmodifiable.offer("D");  // ❌ Exception!

// Original changes still reflect in view
original.offer("D");
System.out.println(unmodifiable);  // [A, B, C, D] (view sees changes!)
```

### **2.3 Predicated Queue (Validation)** 

```java
import org.apache.commons.collections4.PredicateUtils;
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.Predicate;

// Create a predicate that validates elements
Predicate<String> nonEmptyString = s -> s != null && !s.trim().isEmpty();

// Wrap queue with validation
Queue<String> validatedQueue = QueueUtils.predicatedQueue(
    new LinkedList<>(),
    nonEmptyString
);

validatedQueue.offer("Hello");  // OK
validatedQueue.offer("World");  // OK
// validatedQueue.offer("");     // ❌ IllegalArgumentException!
// validatedQueue.offer(null);   // ❌ NullPointerException (depends on predicate)

// Combine predicates
Predicate<Integer> positive = i -> i > 0;
Predicate<Integer> lessThan100 = i -> i < 100;
Predicate<Integer> validRange = PredicateUtils.allPredicate(positive, lessThan100);

Queue<Integer> numberQueue = QueueUtils.predicatedQueue(
    new LinkedList<>(),
    validRange
);

numberQueue.offer(50);   // OK
numberQueue.offer(150);  // ❌ IllegalArgumentException!
```

### **2.4 Transforming Queue** 

```java
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.QueueUtils;

// Transformer that converts input
Transformer<String, String> toUpperCase = input -> 
    input != null ? input.toUpperCase() : null;

// Wrap queue with transformer - transforms on add
Queue<String> upperQueue = QueueUtils.transformingQueue(
    new LinkedList<>(),
    toUpperCase
);

upperQueue.offer("hello");  // Transforms and stores "HELLO"
upperQueue.offer("world");  // Stores "WORLD"

System.out.println(upperQueue);  // [HELLO, WORLD]

// Original queue is not transformed - it's a view!
Queue<String> original = new LinkedList<>();
Queue<String> transforming = QueueUtils.transformingQueue(original, toUpperCase);

transforming.offer("test");  // original gets transformed value
System.out.println(original);  // ["TEST"]

// Existing entries NOT transformed
original.offer("existing");
System.out.println(transforming);  // ["existing", "TEST"] - "existing" unchanged!

// For transforming existing entries, use TransformedQueue.transformedQueue()
```

### **2.5 Empty Queue Constants** 

```java
import org.apache.commons.collections4.QueueUtils;

// Type-safe empty queue (singleton instance)
Queue<String> empty1 = QueueUtils.emptyQueue();
Queue<Integer> empty2 = QueueUtils.emptyQueue();

// All empty queues share same instance (memory efficient)
System.out.println(empty1 == empty2);  // false? Actually returns different type-safe views

// EMPTY_QUEUE constant (raw type)
@SuppressWarnings("unchecked")
Queue<String> empty3 = QueueUtils.EMPTY_QUEUE;
```

### **2.6 Complete Example with All Decorators**

```java
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;

public class QueueUtilsDemo {
    public static void main(String[] args) {
        // Create base queue
        Queue<String> baseQueue = new LinkedList<>();
        
        // Add validation
        Predicate<String> notNull = java.util.Objects::nonNull;
        Queue<String> validated = QueueUtils.predicatedQueue(baseQueue, notNull);
        
        // Add transformation
        Transformer<String, String> trimmer = s -> s != null ? s.trim() : null;
        Queue<String> transformed = QueueUtils.transformingQueue(validated, trimmer);
        
        // Make thread-safe
        Queue<String> syncQueue = QueueUtils.synchronizedQueue(transformed);
        
        // Make unmodifiable
        Queue<String> finalQueue = QueueUtils.unmodifiableQueue(syncQueue);
        
        // Use the decorated queue
        finalQueue.offer("  hello  ");  // Validated, trimmed, synced, then unmodifiable
        
        // But unmodifiable prevents further modifications!
        // finalQueue.offer("another");  // ❌ UnsupportedOperationException
        
        // Chain decorators carefully - order matters!
    }
}
```

---

## **3. GOOGLE GUAVA QUEUES** 🎯

### **Maven Dependency** 
```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>33.4.0-jre</version>
</dependency>
```

### **3.1 Queue Creation Utilities** 

```java
import com.google.common.collect.Queues;

// ===== ArrayBlockingQueue =====
ArrayBlockingQueue<String> abq = Queues.newArrayBlockingQueue(100);
// Fixed-size blocking queue

// ===== ConcurrentLinkedQueue =====
ConcurrentLinkedQueue<String> clq = Queues.newConcurrentLinkedQueue();
// Empty concurrent queue

// From existing elements
Iterable<String> elements = List.of("A", "B", "C");
ConcurrentLinkedQueue<String> clqWithElements = 
    Queues.newConcurrentLinkedQueue(elements);

// ===== LinkedBlockingQueue =====
LinkedBlockingQueue<String> lbq = Queues.newLinkedBlockingQueue();
// Unbounded blocking queue

// Bounded
LinkedBlockingQueue<String> bounded = Queues.newLinkedBlockingQueue(100);

// With elements
LinkedBlockingQueue<String> lbqWithElements = 
    Queues.newLinkedBlockingQueue(elements);

// ===== PriorityQueue =====
PriorityQueue<String> pq = Queues.newPriorityQueue();
// Natural ordering

// From elements
PriorityQueue<String> pqWithElements = Queues.newPriorityQueue(elements);

// ===== PriorityBlockingQueue =====
PriorityBlockingQueue<String> pbq = Queues.newPriorityBlockingQueue();

// With elements
PriorityBlockingQueue<String> pbqWithElements = 
    Queues.newPriorityBlockingQueue(elements);

// ===== SynchronousQueue =====
SynchronousQueue<String> sq = Queues.newSynchronousQueue();
// Direct handoff queue
```

### **3.2 ArrayDeque Creation** 

```java
import com.google.common.collect.Queues;

// Empty ArrayDeque
ArrayDeque<String> deque = Queues.newArrayDeque();

// With elements
ArrayDeque<String> dequeWithElements = Queues.newArrayDeque(List.of("A", "B", "C"));

// ArrayDeque is often better than LinkedList for queue/stack operations
Queue<String> queue = Queues.newArrayDeque();  // Use as FIFO queue
Deque<String> stack = Queues.newArrayDeque();  // Use as LIFO stack
```

### **3.3 LinkedBlockingDeque Creation** 

```java
import com.google.common.collect.Queues;

// Unbounded
LinkedBlockingDeque<String> deque1 = Queues.newLinkedBlockingDeque();

// Bounded
LinkedBlockingDeque<String> deque2 = Queues.newLinkedBlockingDeque(100);

// With elements
LinkedBlockingDeque<String> deque3 = Queues.newLinkedBlockingDeque(List.of("A", "B"));
```

### **3.4 Draining Methods for BlockingQueue** 

```java
import com.google.common.collect.Queues;
import java.util.concurrent.*;
import java.util.*;

BlockingQueue<String> blockingQueue = new LinkedBlockingQueue<>();

// Producer
new Thread(() -> {
    for (int i = 0; i < 10; i++) {
        try {
            blockingQueue.put("Item-" + i);
            Thread.sleep(100);
        } catch (InterruptedException e) {}
    }
}).start();

// ===== drain() - Transfer elements with timeout =====
List<String> buffer = new ArrayList<>();

try {
    // Wait up to 5 seconds to get 5 elements
    int transferred = Queues.drain(
        blockingQueue,    // source queue
        buffer,           // destination collection
        5,                // number of elements wanted
        5,                // timeout value
        TimeUnit.SECONDS  // timeout unit
    );
    
    System.out.println("Transferred " + transferred + " elements: " + buffer);
} catch (InterruptedException e) {
    Thread.currentThread().interrupt();
}

// ===== drainUninterruptibly() - Ignore interrupts =====
List<String> buffer2 = new ArrayList<>();

// Will continue even if interrupted
int transferred = Queues.drainUninterruptibly(
    blockingQueue,
    buffer2,
    5,
    5,
    TimeUnit.SECONDS
);

// Thread's interrupted status will be set if interruption occurred
if (Thread.interrupted()) {
    System.out.println("Was interrupted but continued");
}
```

### **3.5 Complete Drain Example**

```java
import com.google.common.collect.Queues;
import java.util.concurrent.*;
import java.util.*;

public class DrainDemo {
    public static void main(String[] args) {
        BlockingQueue<String> queue = new LinkedBlockingQueue<>();
        
        // Start producer
        startProducer(queue);
        
        // Consumer with drain
        List<String> batch = new ArrayList<>();
        try {
            while (true) {
                batch.clear();
                
                // Wait up to 2 seconds for at least 3 items
                int count = Queues.drain(
                    queue, 
                    batch, 
                    3, 
                    2, 
                    TimeUnit.SECONDS
                );
                
                if (count > 0) {
                    System.out.println("Processing batch: " + batch);
                    processBatch(batch);
                } else {
                    System.out.println("No items received, continuing...");
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("Consumer interrupted");
        }
    }
    
    private static void startProducer(BlockingQueue<String> queue) {
        new Thread(() -> {
            try {
                for (int i = 0; i < 20; i++) {
                    queue.put("Item-" + i);
                    Thread.sleep(500);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();
    }
    
    private static void processBatch(List<String> batch) {
        // Simulate processing
        System.out.println("Processing " + batch.size() + " items");
        batch.forEach(item -> System.out.println("  " + item));
    }
}
```

### **3.6 Difference Between drain() and drainUninterruptibly()**

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>();

// drain() - throws InterruptedException
try {
    List<String> buffer = new ArrayList<>();
    int count = Queues.drain(queue, buffer, 10, 1, TimeUnit.SECONDS);
    // If interrupted while waiting, throws exception
} catch (InterruptedException e) {
    // Handle interruption
    Thread.currentThread().interrupt();
}

// drainUninterruptibly() - continues on interruption
List<String> buffer2 = new ArrayList<>();
int count2 = Queues.drainUninterruptibly(queue, buffer2, 10, 1, TimeUnit.SECONDS);
// After method returns, check interruption status
if (Thread.interrupted()) {
    // Was interrupted but operation completed
    System.out.println("Operation completed despite interruption");
}
```

### **3.7 Synchronized Queue/Deque Wrappers** 

```java
import com.google.common.collect.Queues;

// Synchronized queue
Queue<String> queue = new LinkedList<>();
Queue<String> syncQueue = Queues.synchronizedQueue(queue);

// Must synchronize on iteration
synchronized(syncQueue) {
    for (String s : syncQueue) {
        // process
    }
}

// Synchronized deque
Deque<String> deque = new ArrayDeque<>();
Deque<String> syncDeque = Queues.synchronizedDeque(deque);

synchronized(syncDeque) {
    for (String s : syncDeque) {
        // process
    }
}
```

---

## **4. COMPARISON TABLE**

| Feature | JDK | Apache Commons | Guava |
|---------|-----|----------------|-------|
| **Empty queue** | `Collections.emptyList()` (not Queue) | `QueueUtils.emptyQueue()` | `Queues.newArrayDeque()` (not empty singleton) |
| **Synchronized wrapper** | `Collections.synchronizedQueue()` | `QueueUtils.synchronizedQueue()` | `Queues.synchronizedQueue()` |
| **Unmodifiable wrapper** | `Collections.unmodifiableCollection()` (loses Queue) | `QueueUtils.unmodifiableQueue()` | ❌ |
| **Predicated/Validating** | ❌ | `QueueUtils.predicatedQueue()` | ❌ |
| **Transforming** | ❌ | `QueueUtils.transformingQueue()` | ❌ |
| **Drain methods** | `BlockingQueue.drainTo()` | ❌ | `Queues.drain()`, `drainUninterruptibly()` |
| **Queue creation** | Constructor | ❌ | `Queues.new*()` methods |
| **LIFO view** | `Collections.asLifoQueue()` | ❌ | ❌ |
| **Checked (type-safe)** | `Collections.checkedQueue()` | ❌ | ❌ |

---

## **5. PERFORMANCE CONSIDERATIONS**

```java
// JDK synchronizedQueue - single lock, good for low concurrency
Queue<String> syncJdk = Collections.synchronizedQueue(new LinkedList<>());

// Apache Commons synchronizedQueue - similar to JDK
Queue<String> syncApache = QueueUtils.synchronizedQueue(new LinkedList<>());

// Guava synchronizedQueue - also similar
Queue<String> syncGuava = Queues.synchronizedQueue(new LinkedList<>());

// All require manual synchronization on iteration!

// For high concurrency, use concurrent implementations instead
Queue<String> concurrent = new ConcurrentLinkedQueue<>();  // Lock-free
BlockingQueue<String> blocking = new LinkedBlockingQueue<>();  // Separate locks
```

---

## **🎯 WHEN TO USE WHICH UTILITY**

| Scenario | Recommended Utility |
|----------|---------------------|
| **Need empty queue singleton** | Apache Commons `QueueUtils.emptyQueue()` |
| **Need unmodifiable queue** | Apache Commons `QueueUtils.unmodifiableQueue()` |
| **Need validation on add** | Apache Commons `QueueUtils.predicatedQueue()` |
| **Need transformation on add** | Apache Commons `QueueUtils.transformingQueue()` |
| **Need LIFO queue view** | JDK `Collections.asLifoQueue()` |
| **Need type-safe queue** | JDK `Collections.checkedQueue()` |
| **Need to create concurrent queue** | Guava `Queues.newConcurrentLinkedQueue()` |
| **Need blocking queue creation** | Guava `Queues.new*()` methods |
| **Need advanced drain operations** | Guava `Queues.drain()` and `drainUninterruptibly()` |
| **Need synchronized wrapper** | Any (JDK, Apache, Guava) - they're similar |
| **Need thread-safe queue** | Use `ConcurrentLinkedQueue` or `BlockingQueue` directly |

---

## **🚀 QUICK CHEAT SHEET**

```java
// ========== JDK ==========
Collections.asLifoQueue(deque);              // LIFO view
Collections.synchronizedQueue(queue);        // Thread-safe wrapper
Collections.checkedQueue(queue, String.class); // Type-safe wrapper
Collections.unmodifiableCollection(queue);   // Read-only (loses Queue type)

// ========== Apache Commons ==========
QueueUtils.emptyQueue();                      // Empty queue
QueueUtils.unmodifiableQueue(queue);           // Read-only queue
QueueUtils.synchronizedQueue(queue);           // Thread-safe wrapper
QueueUtils.predicatedQueue(queue, predicate);  // Validating queue
QueueUtils.transformingQueue(queue, transformer); // Transforming queue

// ========== Guava ==========
Queues.newArrayBlockingQueue(100);             // Bounded blocking queue
Queues.newConcurrentLinkedQueue();              // Concurrent queue
Queues.newLinkedBlockingQueue();                // Unbounded blocking queue
Queues.newLinkedBlockingQueue(100);             // Bounded blocking queue
Queues.newPriorityQueue();                      // Priority queue
Queues.newPriorityBlockingQueue();              // Thread-safe priority queue
Queues.newSynchronousQueue();                   // Direct handoff queue
Queues.newArrayDeque();                         // ArrayDeque
Queues.drain(blockingQueue, list, 10, 1, SECONDS); // Drain with timeout
Queues.drainUninterruptibly(blockingQueue, list, 10, 1, SECONDS); // Uninterruptible drain
Queues.synchronizedQueue(queue);                // Thread-safe wrapper
Queues.synchronizedDeque(deque);                // Thread-safe deque wrapper
```

---

## **📝 REAL-WORLD EXAMPLES**

### **Example 1: Thread-Safe Task Queue with Validation**

```java
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.Predicate;

public class TaskQueue {
    private final Queue<Task> queue;
    
    public TaskQueue() {
        // Validate tasks before adding
        Predicate<Task> validTask = task -> 
            task != null && 
            task.getId() != null && 
            !task.getId().isEmpty();
        
        Queue<Task> baseQueue = new LinkedList<>();
        Queue<Task> validated = QueueUtils.predicatedQueue(baseQueue, validTask);
        this.queue = QueueUtils.synchronizedQueue(validated);
    }
    
    public boolean submitTask(Task task) {
        return queue.offer(task);  // Validated and thread-safe
    }
    
    public Task processNext() {
        synchronized(queue) {
            return queue.poll();
        }
    }
}
```

### **Example 2: Batch Processing with Guava Drain**

```java
import com.google.common.collect.Queues;
import java.util.concurrent.*;

public class BatchProcessor {
    private final BlockingQueue<Job> jobQueue = Queues.newLinkedBlockingQueue(1000);
    private final List<Job> batch = new ArrayList<>();
    
    public void startProcessing() {
        Executors.newSingleThreadScheduledExecutor()
            .scheduleAtFixedRate(this::processBatch, 0, 5, TimeUnit.SECONDS);
    }
    
    private void processBatch() {
        try {
            batch.clear();
            int count = Queues.drain(jobQueue, batch, 100, 1, TimeUnit.SECONDS);
            
            if (count > 0) {
                System.out.println("Processing " + count + " jobs");
                batch.forEach(this::executeJob);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
    
    private void executeJob(Job job) {
        // Process job
    }
}
```

### **Example 3: LIFO Stack from Queue**

```java
import java.util.*;

public class UndoStack {
    private final Deque<String> deque = new ArrayDeque<>();
    private final Queue<String> lifoView = Collections.asLifoQueue(deque);
    
    public void push(String state) {
        lifoView.offer(state);  // Actually adds to front due to LIFO view
    }
    
    public String pop() {
        return lifoView.poll();  // Actually removes from front
    }
    
    public String peek() {
        return lifoView.peek();
    }
}
```

### **Example 4: Transforming Queue for Logging**

```java
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.Transformer;

public class LoggingQueue<T> {
    private final Queue<T> queue;
    
    public LoggingQueue(Queue<T> delegate) {
        Transformer<T, T> logger = input -> {
            System.out.println("Adding to queue: " + input);
            return input;
        };
        this.queue = QueueUtils.transformingQueue(delegate, logger);
    }
    
    public boolean add(T item) {
        return queue.offer(item);  // Automatically logged
    }
}
```

---

## **⚠️ IMPORTANT NOTES**

1. **No `Queue.of()` in JDK** - unlike List and Set, Queue doesn't have factory methods
2. **Synchronized wrappers require external sync on iteration** - common pitfall!
3. **Unmodifiable wrappers are views** - backing changes reflect
4. **Apache Commons transformingQueue** doesn't transform existing elements
5. **Guava drain methods** are more flexible than `BlockingQueue.drainTo()`
6. **Empty queue singletons** - Apache provides, others don't
7. **Checked queue** - only JDK provides type-safe wrapper

---

*Happy Coding with Queues! 🎉*