# **Complete Java Multithreading - The Ultimate Interview Guide** 🧵

_Your comprehensive go-to reference for all Java Multithreading concepts with brief explanations and code examples_

---

## **📋 TABLE OF CONTENTS**

- [**Complete Java Multithreading - The Ultimate Interview Guide** 🧵](#complete-java-multithreading---the-ultimate-interview-guide-)
  - [**📋 TABLE OF CONTENTS**](#-table-of-contents)
  - [**1. WHAT IS MULTITHREADING?**](#1-what-is-multithreading)
  - [**2. WHY MULTITHREADING?**](#2-why-multithreading)
  - [**3. THREAD LIFECYCLE**](#3-thread-lifecycle)
    - [**Thread States**](#thread-states)
  - [**4. CREATING THREADS**](#4-creating-threads)
    - [**4.1 Extending Thread Class**](#41-extending-thread-class)
    - [**4.2 Implementing Runnable Interface**](#42-implementing-runnable-interface)
    - [**4.3 Implementing Callable (Returns Result)**](#43-implementing-callable-returns-result)
  - [**5. THREAD METHODS**](#5-thread-methods)
    - [**5.1 start()**](#51-start)
    - [**5.2 sleep()**](#52-sleep)
    - [**5.3 join()**](#53-join)
    - [**5.4 interrupt()**](#54-interrupt)
  - [**6. THREAD PRIORITIES**](#6-thread-priorities)
  - [**7. THREAD SYNCHRONIZATION**](#7-thread-synchronization)
    - [**7.1 Race Condition Problem**](#71-race-condition-problem)
    - [**7.2 Synchronized Method**](#72-synchronized-method)
    - [**7.3 Synchronized Block**](#73-synchronized-block)
  - [**8. INTER-THREAD COMMUNICATION**](#8-inter-thread-communication)
  - [**9. DEADLOCK**](#9-deadlock)
  - [**10. THREADLOCAL**](#10-threadlocal)
  - [**11. THREAD SAFETY**](#11-thread-safety)
  - [**12. ATOMIC VARIABLES**](#12-atomic-variables)
  - [**13. EXECUTOR FRAMEWORK**](#13-executor-framework)
  - [**14. CALLABLE AND FUTURE**](#14-callable-and-future)
  - [**15. LOCKS**](#15-locks)
  - [**16. COUNTDOWNLATCH**](#16-countdownlatch)
  - [**17. CYCLICBARRIER**](#17-cyclicbarrier)
  - [**18. SEMAPHORE**](#18-semaphore)
  - [**19. EXCHANGER**](#19-exchanger)
  - [**20. PHASER**](#20-phaser)
  - [**21. BLOCKINGQUEUE**](#21-blockingqueue)
  - [**22. FORK/JOIN FRAMEWORK**](#22-forkjoin-framework)
  - [**23. COMPLETABLEFUTURE**](#23-completablefuture)
  - [**24. THREAD SAFETY IN COLLECTIONS**](#24-thread-safety-in-collections)
  - [**25. VOLATILE KEYWORD**](#25-volatile-keyword)
  - [**26. THREADGROUP**](#26-threadgroup)
  - [**27. THREADFACTORY**](#27-threadfactory)
  - [**28. THREAD POOLS**](#28-thread-pools)
    - [**28.1 ThreadPoolExecutor**](#281-threadpoolexecutor)
    - [**28.2 ScheduledThreadPoolExecutor**](#282-scheduledthreadpoolexecutor)
    - [**28.3 WorkStealingPool (Java 8+)**](#283-workstealingpool-java-8)
  - [**29. THREAD DUMP ANALYSIS**](#29-thread-dump-analysis)
  - [**30. COMMON INTERVIEW QUESTIONS**](#30-common-interview-questions)
  - [**31. QUICK REFERENCE CHEAT SHEET**](#31-quick-reference-cheat-sheet)
  - [**📝 KEY TAKEAWAYS**](#-key-takeaways)

---

## **1. WHAT IS MULTITHREADING?**

> **Concept:** Multithreading is a Java feature that allows concurrent execution of two or more parts of a program for maximum CPU utilization.

```java
// Simple example
public class Main {
    public static void main(String[] args) {
        System.out.println("Main thread: " + Thread.currentThread().getName());

        // Create and start a new thread
        Thread thread = new Thread(() -> {
            System.out.println("New thread: " + Thread.currentThread().getName());
        });
        thread.start();
    }
}
```

---

## **2. WHY MULTITHREADING?**

| Benefit                    | Explanation                     | Example                            |
| -------------------------- | ------------------------------- | ---------------------------------- |
| **Better CPU Utilization** | Use multiple cores efficiently  | Process large data in parallel     |
| **Improved Performance**   | Tasks execute concurrently      | UI doesn't freeze while processing |
| **Better Resource Usage**  | Share resources between threads | Database connection pooling        |
| **Simplified Modeling**    | Model real-world concurrency    | Multiple users accessing system    |

```java
// Without threading - sequential
long start = System.currentTimeMillis();
for (int i = 0; i < 5; i++) {
    Thread.sleep(1000);  // Simulate work
    System.out.println("Task " + i + " completed");
}
long time = System.currentTimeMillis() - start;  // ~5000ms

// With threading - parallel
start = System.currentTimeMillis();
List<Thread> threads = new ArrayList<>();
for (int i = 0; i < 5; i++) {
    int taskId = i;
    Thread t = new Thread(() -> {
        try { Thread.sleep(1000); } catch (Exception e) {}
        System.out.println("Task " + taskId + " completed");
    });
    t.start();
    threads.add(t);
}
for (Thread t : threads) {
    t.join();
}
time = System.currentTimeMillis() - start;  // ~1000ms
```

---

## **3. THREAD LIFECYCLE**

> **Concept:** A thread goes through various states during its lifetime.

### **Thread States**

```
                    ┌─────────────┐
                    │    NEW      │
                    └──────┬──────┘
                           │ start()
                    ┌──────▼──────┐
               ┌───▶│ RUNNABLE    │◄───┐
               │    └──────┬──────┘    │
               │           │            │
               │    ┌──────▼──────┐    │
               │    │  BLOCKED    │    │
               │    └─────────────┘    │
               │                       │
               │    ┌──────▼──────┐    │
               │    │  WAITING    │    │
               │    └─────────────┘    │
               │                       │
               │    ┌──────▼──────┐    │
               │    │TIMED_WAITING│    │
               │    └─────────────┘    │
               │           │            │
               │    ┌──────▼──────┐    │
               └────│ TERMINATED  │────┘
                    └─────────────┘
```

```java
// Demonstrating thread states
public class ThreadLifecycle {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            try {
                Thread.sleep(2000);  // TIMED_WAITING
            } catch (InterruptedException e) {}
        });

        System.out.println("State after creation: " + t.getState());  // NEW

        t.start();
        System.out.println("State after start: " + t.getState());     // RUNNABLE

        Thread.sleep(500);
        System.out.println("State while sleeping: " + t.getState());  // TIMED_WAITING

        t.join();
        System.out.println("State after completion: " + t.getState()); // TERMINATED
    }
}
```

---

## **4. CREATING THREADS**

> **Concept:** Two ways to create threads - extending Thread class or implementing Runnable interface.

### **4.1 Extending Thread Class**

```java
class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("Thread running: " + Thread.currentThread().getName());
    }
}

// Usage
MyThread t1 = new MyThread();
t1.start();  // Starts new thread
```

### **4.2 Implementing Runnable Interface**

```java
class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("Runnable running: " + Thread.currentThread().getName());
    }
}

// Usage
Thread t2 = new Thread(new MyRunnable());
t2.start();

// With lambda (Java 8+)
Thread t3 = new Thread(() -> {
    System.out.println("Lambda thread: " + Thread.currentThread().getName());
});
t3.start();
```

### **4.3 Implementing Callable (Returns Result)**

```java
class MyCallable implements Callable<String> {
    @Override
    public String call() throws Exception {
        return "Result from " + Thread.currentThread().getName();
    }
}

// Usage with ExecutorService
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<String> future = executor.submit(new MyCallable());
String result = future.get();
executor.shutdown();
```

---

## **5. THREAD METHODS**

> **Concept:** Important methods for controlling thread execution.

### **5.1 start()**

> **Concept:** Starts thread execution by calling run() in a new thread.

```java
Thread t = new Thread(() -> System.out.println("Running"));
t.start();  // Creates new stack, calls run()
```

### **5.2 sleep()**

> **Concept:** Causes current thread to pause execution for specified time.

```java
try {
    Thread.sleep(2000);  // Pauses for 2000ms
} catch (InterruptedException e) {
    Thread.currentThread().interrupt();
}
```

### **5.3 join()**

> **Concept:** Waits for thread to die.

```java
Thread t = new Thread(() -> {
    try { Thread.sleep(2000); } catch (Exception e) {}
});
t.start();
t.join();  // Main thread waits until t finishes
```

### **5.4 interrupt()**

> **Concept:** Interrupts a thread (sets interrupt flag).

```java
Thread t = new Thread(() -> {
    while (!Thread.currentThread().isInterrupted()) {
        // do work
    }
});
t.start();
t.interrupt();  // Interrupt the thread
```

---

## **6. THREAD PRIORITIES**

> **Concept:** Thread priority ranges from 1 (MIN) to 10 (MAX), default 5 (NORM).

```java
Thread t1 = new Thread(() -> {});
t1.setPriority(Thread.MIN_PRIORITY);  // 1

Thread t2 = new Thread(() -> {});
t2.setPriority(Thread.MAX_PRIORITY);  // 10
```

---

## **7. THREAD SYNCHRONIZATION**

> **Concept:** Mechanism to control access to shared resources by multiple threads.

### **7.1 Race Condition Problem**

```java
class Counter {
    private int count = 0;
    public void increment() { count++; }  // Not atomic!
}
```

### **7.2 Synchronized Method**

```java
class SafeCounter {
    private int count = 0;
    public synchronized void increment() { count++; }
}
```

### **7.3 Synchronized Block**

```java
class BankAccount {
    private int balance = 1000;
    private final Object lock = new Object();

    public void withdraw(int amount) {
        synchronized(lock) {
            if (balance >= amount) {
                balance -= amount;
            }
        }
    }
}
```

---

## **8. INTER-THREAD COMMUNICATION**

> **Concept:** Threads can communicate using wait(), notify(), and notifyAll().

```java
class SharedQueue {
    private List<Integer> queue = new LinkedList<>();
    private final int CAPACITY = 5;

    public synchronized void produce(int value) throws InterruptedException {
        while (queue.size() == CAPACITY) {
            wait();  // Release lock and wait
        }
        queue.add(value);
        notifyAll();
    }

    public synchronized int consume() throws InterruptedException {
        while (queue.isEmpty()) {
            wait();
        }
        int value = queue.remove(0);
        notifyAll();
        return value;
    }
}
```

---

## **9. DEADLOCK**

> **Concept:** Two or more threads blocked forever, waiting for each other's locks.

```java
// Deadlock example
Resource r1 = new Resource();
Resource r2 = new Resource();

Thread t1 = new Thread(() -> {
    synchronized(r1) {
        Thread.sleep(100);
        synchronized(r2) { }  // Waiting for r2
    }
});

Thread t2 = new Thread(() -> {
    synchronized(r2) {
        Thread.sleep(100);
        synchronized(r1) { }  // Waiting for r1
    }
});

t1.start();
t2.start();  // DEADLOCK!
```

---

## **10. THREADLOCAL**

> **Concept:** Provides thread-local variables - each thread has its own independent copy.

```java
ThreadLocal<Integer> threadLocal = ThreadLocal.withInitial(() -> 0);

Runnable task = () -> {
    int value = threadLocal.get();
    threadLocal.set(value + 1);
    System.out.println(Thread.currentThread().getName() + ": " + threadLocal.get());
    threadLocal.remove();  // Clean up
};
```

---

## **11. THREAD SAFETY**

> **Concept:** Code is thread-safe if it works correctly when accessed by multiple threads.

```java
// Immutable - always thread-safe
final class ImmutablePoint {
    private final int x, y;
    public ImmutablePoint(int x, int y) { this.x = x; this.y = y; }
}

// Stateless - thread-safe
class StatelessService {
    public int add(int a, int b) { return a + b; }
}

// Synchronized when needed
class SafeCounter {
    private int count = 0;
    public synchronized int increment() { return ++count; }
}
```

---

## **12. ATOMIC VARIABLES**

> **Concept:** Lock-free thread-safe operations on single variables.

```java
AtomicInteger counter = new AtomicInteger(0);
counter.incrementAndGet();      // ++counter
counter.getAndIncrement();      // counter++
counter.addAndGet(5);           // counter += 5
counter.compareAndSet(10, 20);  // If current is 10, set to 20

AtomicBoolean flag = new AtomicBoolean(false);
AtomicReference<String> ref = new AtomicReference<>("initial");
```

---

## **13. EXECUTOR FRAMEWORK**

> **Concept:** Framework for decoupling task submission from task execution.

```java
// Thread pool types
ExecutorService fixedPool = Executors.newFixedThreadPool(5);
ExecutorService cachedPool = Executors.newCachedThreadPool();
ExecutorService single = Executors.newSingleThreadExecutor();
ScheduledExecutorService scheduled = Executors.newScheduledThreadPool(3);

// Submit tasks
executor.submit(() -> System.out.println("Task running"));

// Scheduled tasks
scheduled.schedule(() -> System.out.println("Delayed"), 5, TimeUnit.SECONDS);
scheduled.scheduleAtFixedRate(() -> System.out.println("Periodic"), 0, 1, TimeUnit.SECONDS);

// Shutdown
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

---

## **14. CALLABLE AND FUTURE**

> **Concept:** Callable returns result, Future represents asynchronous result.

```java
Callable<Integer> task = () -> {
    Thread.sleep(1000);
    return 42;
};

ExecutorService executor = Executors.newSingleThreadExecutor();
Future<Integer> future = executor.submit(task);

Integer result = future.get();  // Blocks until done
boolean done = future.isDone();
boolean cancelled = future.cancel(true);
```

---

## **15. LOCKS**

> **Concept:** More flexible synchronization mechanism than synchronized.

```java
// ReentrantLock
class Counter {
    private final Lock lock = new ReentrantLock();
    private int count = 0;

    public void increment() {
        lock.lock();
        try {
            count++;
        } finally {
            lock.unlock();
        }
    }

    // Try lock with timeout
    public boolean tryIncrement() {
        if (lock.tryLock()) {
            try {
                count++;
                return true;
            } finally {
                lock.unlock();
            }
        }
        return false;
    }
}

// ReadWriteLock - multiple readers, single writer
class ReadWriteCache {
    private final ReentrantReadWriteLock rwLock = new ReentrantReadWriteLock();
    private final Lock readLock = rwLock.readLock();
    private final Lock writeLock = rwLock.writeLock();
    private Map<String, String> cache = new HashMap<>();

    public String get(String key) {
        readLock.lock();
        try { return cache.get(key); }
        finally { readLock.unlock(); }
    }

    public void put(String key, String value) {
        writeLock.lock();
        try { cache.put(key, value); }
        finally { writeLock.unlock(); }
    }
}
```

---

## **16. COUNTDOWNLATCH**

> **Concept:** Allows one or more threads to wait until a set of operations completes.

```java
CountDownLatch latch = new CountDownLatch(3);

// Worker threads
Runnable worker = () -> {
    try {
        Thread.sleep(1000);
        System.out.println(Thread.currentThread().getName() + " done");
        latch.countDown();  // Decrement count
    } catch (Exception e) {}
};

for (int i = 0; i < 3; i++) {
    new Thread(worker).start();
}

// Main thread waits
latch.await();  // Waits until count reaches 0
System.out.println("All workers done, main continues");

// Cannot reset - one-time use
```

---

## **17. CYCLICBARRIER**

> **Concept:** Allows multiple threads to wait for each other at a common point.

```java
CyclicBarrier barrier = new CyclicBarrier(3, () -> {
    System.out.println("All parties reached barrier, running action");
});

Runnable task = () -> {
    try {
        System.out.println(Thread.currentThread().getName() + " at barrier");
        barrier.await();  // Wait for others
        System.out.println(Thread.currentThread().getName() + " passed barrier");
    } catch (Exception e) {}
};

for (int i = 0; i < 3; i++) {
    new Thread(task).start();
}

// Can be reused
barrier.reset();  // Reset for next use
```

---

## **18. SEMAPHORE**

> **Concept:** Controls access to a pool of resources.

```java
Semaphore semaphore = new Semaphore(3);  // 3 permits

Runnable task = () -> {
    try {
        semaphore.acquire();  // Get permit (blocks if none available)
        System.out.println(Thread.currentThread().getName() + " acquired permit");
        Thread.sleep(2000);  // Use resource
        semaphore.release();  // Release permit
        System.out.println(Thread.currentThread().getName() + " released permit");
    } catch (Exception e) {}
};

for (int i = 0; i < 5; i++) {
    new Thread(task).start();
}

// Fair semaphore
Semaphore fairSemaphore = new Semaphore(3, true);

// Try acquire without blocking
if (semaphore.tryAcquire()) {
    try {
        // Use resource
    } finally {
        semaphore.release();
    }
}
```

---

## **19. EXCHANGER**

> **Concept:** Synchronization point where two threads exchange objects.

```java
Exchanger<String> exchanger = new Exchanger<>();

Thread producer = new Thread(() -> {
    try {
        String data = "Data from producer";
        System.out.println("Producer sending: " + data);
        String received = exchanger.exchange(data);
        System.out.println("Producer received: " + received);
    } catch (InterruptedException e) {}
});

Thread consumer = new Thread(() -> {
    try {
        String data = "Data from consumer";
        System.out.println("Consumer sending: " + data);
        String received = exchanger.exchange(data);
        System.out.println("Consumer received: " + received);
    } catch (InterruptedException e) {}
});

producer.start();
consumer.start();
```

---

## **20. PHASER**

> **Concept:** More flexible barrier that can be reused and supports dynamic registration.

```java
Phaser phaser = new Phaser(1);  // Register main thread

Runnable task = () -> {
    phaser.register();  // Register with phaser
    try {
        System.out.println(Thread.currentThread().getName() + " at phase 1");
        phaser.arriveAndAwaitAdvance();  // Wait for others

        System.out.println(Thread.currentThread().getName() + " at phase 2");
        phaser.arriveAndAwaitAdvance();

        phaser.arriveAndDeregister();  // Leave
    } catch (Exception e) {}
};

for (int i = 0; i < 3; i++) {
    new Thread(task).start();
}

Thread.sleep(1000);
phaser.arriveAndDeregister();  // Main leaves

// Check phase
int phase = phaser.getPhase();
int registered = phaser.getRegisteredParties();
```

---

## **21. BLOCKINGQUEUE**

> **Concept:** Queue that supports operations that wait for queue to become non-empty/full.

```java
// ArrayBlockingQueue - bounded
BlockingQueue<String> queue = new ArrayBlockingQueue<>(10);

// Producer
Thread producer = new Thread(() -> {
    try {
        queue.put("Item");  // Blocks if full
        queue.offer("Item", 1, TimeUnit.SECONDS);  // With timeout
    } catch (InterruptedException e) {}
});

// Consumer
Thread consumer = new Thread(() -> {
    try {
        String item = queue.take();  // Blocks if empty
        String item2 = queue.poll(1, TimeUnit.SECONDS);  // With timeout
    } catch (InterruptedException e) {}
});

// LinkedBlockingQueue - optionally bounded
BlockingQueue<String> linkedQueue = new LinkedBlockingQueue<>();
BlockingQueue<String> boundedQueue = new LinkedBlockingQueue<>(100);

// PriorityBlockingQueue - priority order
BlockingQueue<Task> priorityQueue = new PriorityBlockingQueue<>();

// SynchronousQueue - no capacity (handoff)
BlockingQueue<String> syncQueue = new SynchronousQueue<>();

// DelayQueue - delayed elements
BlockingQueue<DelayedTask> delayQueue = new DelayQueue<>();
```

---

## **22. FORK/JOIN FRAMEWORK**

> **Concept:** Framework for parallel processing using divide-and-conquer.

```java
class SumTask extends RecursiveTask<Integer> {
    private static final int THRESHOLD = 1000;
    private int[] array;
    private int start, end;

    public SumTask(int[] array, int start, int end) {
        this.array = array;
        this.start = start;
        this.end = end;
    }

    @Override
    protected Integer compute() {
        if (end - start <= THRESHOLD) {
            // Compute directly
            int sum = 0;
            for (int i = start; i < end; i++) {
                sum += array[i];
            }
            return sum;
        } else {
            // Split task
            int mid = start + (end - start) / 2;
            SumTask left = new SumTask(array, start, mid);
            SumTask right = new SumTask(array, mid, end);

            left.fork();  // Execute asynchronously
            int rightResult = right.compute();
            int leftResult = left.join();  // Wait for result

            return leftResult + rightResult;
        }
    }
}

// Usage
ForkJoinPool pool = new ForkJoinPool();
int[] array = new int[10000];
// fill array
SumTask task = new SumTask(array, 0, array.length);
int result = pool.invoke(task);

// RecursiveAction (no return value)
class PrintTask extends RecursiveAction {
    // similar but compute() returns void
}
```

---

## **23. COMPLETABLEFUTURE**

> **Concept:** Enhanced Future with functional composition (Java 8+).

```java
// Create CompletableFuture
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    return "Result";
});

// Chain operations
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "Hello")
    .thenApply(s -> s + " World")
    .thenApply(String::toUpperCase)
    .thenApply(s -> s + "!!!");

// Async with custom executor
ExecutorService executor = Executors.newFixedThreadPool(5);
CompletableFuture<String> future3 = CompletableFuture.supplyAsync(() -> "Hello", executor);

// Combining futures
CompletableFuture<String> future4 = CompletableFuture.supplyAsync(() -> "Hello")
    .thenCombine(
        CompletableFuture.supplyAsync(() -> "World"),
        (s1, s2) -> s1 + " " + s2
    );

// Handling results
future4.thenAccept(result -> System.out.println(result))
       .exceptionally(ex -> {
           System.out.println("Error: " + ex);
           return null;
       });

// Wait for multiple futures
CompletableFuture.allOf(future1, future2, future3).join();

// Get result with timeout
String result = future4.get(1, TimeUnit.SECONDS);

// Run after both complete
future1.runAfterBoth(future2, () -> System.out.println("Both done"));

// Run after either completes
future1.acceptEither(future2, s -> System.out.println("First: " + s));

// Complete manually
CompletableFuture<String> manual = new CompletableFuture<>();
manual.complete("Manual result");
manual.completeExceptionally(new RuntimeException("Error"));
```

---

## **24. THREAD SAFETY IN COLLECTIONS**

> **Concept:** Concurrent collections for thread-safe operations.

```java
// ConcurrentHashMap - thread-safe Map
ConcurrentHashMap<String, String> concurrentMap = new ConcurrentHashMap<>();
concurrentMap.putIfAbsent("key", "value");
concurrentMap.computeIfAbsent("key", k -> "value");

// CopyOnWriteArrayList - for read-heavy scenarios
CopyOnWriteArrayList<String> cowList = new CopyOnWriteArrayList<>();
cowList.add("item");  // Creates copy

// CopyOnWriteArraySet
CopyOnWriteArraySet<String> cowSet = new CopyOnWriteArraySet<>();

// ConcurrentLinkedQueue - lock-free queue
ConcurrentLinkedQueue<String> queue = new ConcurrentLinkedQueue<>();
queue.offer("item");
String item = queue.poll();

// ConcurrentLinkedDeque
ConcurrentLinkedDeque<String> deque = new ConcurrentLinkedDeque<>();
deque.addFirst("first");
deque.addLast("last");

// BlockingQueue implementations
BlockingQueue<String> blockingQueue = new LinkedBlockingQueue<>();

// Synchronized wrappers (older approach)
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());

// Must synchronize on iteration
synchronized(syncList) {
    for (String s : syncList) {
        // process
    }
}
```

---

## **25. VOLATILE KEYWORD**

> **Concept:** Ensures visibility of changes across threads (prevents caching).

```java
class VolatileExample {
    private volatile boolean running = true;

    public void start() {
        new Thread(() -> {
            while (running) {
                // This thread sees changes to running immediately
            }
        }).start();
    }

    public void stop() {
        running = false;  // Change visible to other thread
    }
}

// Without volatile - may run forever (thread may cache value)

// volatile doesn't guarantee atomicity
class VolatileCounter {
    private volatile int count = 0;

    public void increment() {
        count++;  // Not atomic! (read, modify, write)
    }
}
// Use AtomicInteger for atomic operations
```

---

## **26. THREADGROUP**

> **Concept:** Represents a group of threads for collective management.

```java
// Create ThreadGroup
ThreadGroup group = new ThreadGroup("Worker Group");

// Create threads in group
Thread t1 = new Thread(group, () -> {}, "Thread-1");
Thread t2 = new Thread(group, () -> {}, "Thread-2");

// Group operations
group.activeCount();  // Number of active threads
group.activeGroupCount();  // Number of active subgroups
group.enumerate(threads);  // Get all threads
group.interrupt();  // Interrupt all threads
group.setMaxPriority(Thread.NORM_PRIORITY);  // Max priority

// Uncaught exception handler
group.setUncaughtExceptionHandler((g, e) -> {
    System.out.println("Thread in group " + g.getName() + " threw: " + e);
});

// System thread groups
ThreadGroup system = Thread.currentThread().getThreadGroup();
while (system.getParent() != null) {
    system = system.getParent();
}
System.out.println("Root group: " + system.getName());
```

---

## **27. THREADFACTORY**

> **Concept:** Factory for creating threads with custom configuration.

```java
class CustomThreadFactory implements ThreadFactory {
    private int count = 0;
    private String namePrefix;
    private boolean daemon;
    private int priority;

    public CustomThreadFactory(String namePrefix) {
        this(namePrefix, false, Thread.NORM_PRIORITY);
    }

    public CustomThreadFactory(String namePrefix, boolean daemon, int priority) {
        this.namePrefix = namePrefix;
        this.daemon = daemon;
        this.priority = priority;
    }

    @Override
    public Thread newThread(Runnable r) {
        Thread thread = new Thread(r, namePrefix + "-" + ++count);
        thread.setDaemon(daemon);
        thread.setPriority(priority);
        return thread;
    }
}

// Usage
ThreadFactory factory = new CustomThreadFactory("Worker", true, Thread.MAX_PRIORITY);
Thread t = factory.newThread(() -> System.out.println("Custom thread"));

// With ExecutorService
ExecutorService executor = Executors.newFixedThreadPool(5, factory);

// Default thread factory
ThreadFactory defaultFactory = Executors.defaultThreadFactory();
```

---

## **28. THREAD POOLS**

> **Concept:** Manage pool of worker threads for executing tasks.

### **28.1 ThreadPoolExecutor**

```java
ThreadPoolExecutor executor = new ThreadPoolExecutor(
    2,                          // corePoolSize
    5,                          // maximumPoolSize
    60,                         // keepAliveTime
    TimeUnit.SECONDS,
    new LinkedBlockingQueue<>(100),  // workQueue
    new ThreadPoolExecutor.CallerRunsPolicy()  // rejectedExecutionHandler
);

// Monitor thread pool
int active = executor.getActiveCount();
long completed = executor.getCompletedTaskCount();
int coreSize = executor.getCorePoolSize();
int maxSize = executor.getMaximumPoolSize();
long taskCount = executor.getTaskCount();

// Dynamic adjustment
executor.setCorePoolSize(3);
executor.setMaximumPoolSize(8);
executor.prestartAllCoreThreads();  // Start core threads
```

### **28.2 ScheduledThreadPoolExecutor**

```java
ScheduledThreadPoolExecutor scheduled = new ScheduledThreadPoolExecutor(3);

scheduled.schedule(() -> System.out.println("One-time"), 5, TimeUnit.SECONDS);
scheduled.scheduleAtFixedRate(() -> System.out.println("Periodic"), 0, 1, TimeUnit.SECONDS);
scheduled.scheduleWithFixedDelay(() -> System.out.println("Delayed"), 0, 1, TimeUnit.SECONDS);

// Additional features
scheduled.setContinueExistingPeriodicTasksAfterShutdownPolicy(false);
scheduled.setExecuteExistingDelayedTasksAfterShutdownPolicy(false);
scheduled.setRemoveOnCancelPolicy(true);
```

### **28.3 WorkStealingPool (Java 8+)**

```java
// ForkJoinPool-based pool that distributes work
ExecutorService workStealing = Executors.newWorkStealingPool();
ExecutorService workStealingWithParallelism = Executors.newWorkStealingPool(4);

// Uses work-stealing algorithm for better load balancing
```

---

## **29. THREAD DUMP ANALYSIS**

> **Concept:** Snapshot of all threads' states for debugging.

```java
// Programmatically get thread dump
ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();

// Get all thread information
long[] threadIds = threadMXBean.getAllThreadIds();
ThreadInfo[] threadInfos = threadMXBean.getThreadInfo(threadIds, true, true);

for (ThreadInfo info : threadInfos) {
    System.out.println("Thread: " + info.getThreadName());
    System.out.println("State: " + info.getThreadState());
    System.out.println("Blocked time: " + info.getBlockedTime());
    System.out.println("Waited time: " + info.getWaitedTime());

    // Stack trace
    StackTraceElement[] stack = info.getStackTrace();
    for (StackTraceElement element : stack) {
        System.out.println("  at " + element);
    }
}

// Detect deadlocks
long[] deadlockedThreads = threadMXBean.findDeadlockedThreads();
if (deadlockedThreads != null) {
    System.out.println("Deadlock detected!");
}

// Using jstack command
// jstack <pid>

// Using kill command (Linux)
// kill -3 <pid>  // Prints thread dump to console
```

---

## **30. COMMON INTERVIEW QUESTIONS**

| Question                                       | Answer                                                                               |
| ---------------------------------------------- | ------------------------------------------------------------------------------------ |
| **What is multithreading?**                    | Concurrent execution of multiple parts of program for better CPU utilization         |
| **Difference between process and thread?**     | Process has own memory space, threads share memory within process                    |
| **How to create thread?**                      | Extend Thread class or implement Runnable/Callable                                   |
| **What is race condition?**                    | Multiple threads accessing shared data concurrently leading to inconsistent results  |
| **How to avoid race condition?**               | Use synchronization, locks, atomic variables                                         |
| **What is deadlock?**                          | Two or more threads blocked forever waiting for each other's locks                   |
| **How to avoid deadlock?**                     | Lock ordering, timeouts, deadlock detection                                          |
| **What is volatile?**                          | Ensures visibility of changes across threads, prevents caching                       |
| **What is ThreadLocal?**                       | Each thread has its own copy of variable                                             |
| **Difference between wait() and sleep()?**     | wait() releases lock, sleep() doesn't; wait() needs notify, sleep() wakes after time |
| **What is ExecutorService?**                   | Framework for managing thread pools and task execution                               |
| **Difference between submit() and execute()?** | submit() returns Future, execute() doesn't                                           |
| **What is Callable?**                          | Similar to Runnable but returns result and throws exception                          |
| **What is Future?**                            | Represents result of asynchronous computation                                        |
| **What is CountDownLatch?**                    | Allows threads to wait until count reaches zero                                      |
| **What is CyclicBarrier?**                     | Allows threads to wait for each other at common point                                |
| **What is Semaphore?**                         | Controls access to pool of resources                                                 |
| **What is BlockingQueue?**                     | Queue with operations that wait                                                      |
| **What is Fork/Join framework?**               | Parallel processing using divide-and-conquer                                         |
| **What is CompletableFuture?**                 | Enhanced Future with functional composition                                          |
| **Difference between synchronized and Lock?**  | Lock more flexible (tryLock, lockInterruptibly)                                      |
| **What is thread safety?**                     | Code works correctly when accessed by multiple threads                               |
| **How to make collection thread-safe?**        | Concurrent collections or synchronized wrappers                                      |
| **What is thread starvation?**                 | Thread unable to gain access to resources                                            |
| **What is thread pool?**                       | Pool of worker threads for executing tasks                                           |

---

## **31. QUICK REFERENCE CHEAT SHEET**

```java
// ========== CREATING THREADS ==========
Thread t = new Thread(() -> {}); t.start();
ExecutorService exec = Executors.newFixedThreadPool(5);
exec.submit(() -> {});

// ========== SYNCHRONIZATION ==========
synchronized(lock) { }
public synchronized void method() { }
Lock lock = new ReentrantLock(); lock.lock(); try {} finally { lock.unlock(); }

// ========== INTER-THREAD COMM ==========
wait(); notify(); notifyAll();

// ========== ATOMIC VARIABLES ==========
AtomicInteger ai = new AtomicInteger(); ai.incrementAndGet();

// ========== THREAD LOCAL ==========
ThreadLocal<Integer> tl = ThreadLocal.withInitial(() -> 0);

// ========== EXECUTOR SERVICE ==========
ExecutorService exec = Executors.newFixedThreadPool(5);
Future<?> f = exec.submit(() -> {});
exec.shutdown();

// ========== FUTURE ==========
Future<Integer> f = exec.submit(() -> 42);
Integer result = f.get();

// ========== COUNTDOWNLATCH ==========
CountDownLatch latch = new CountDownLatch(3); latch.countDown(); latch.await();

// ========== CYCLICBARRIER ==========
CyclicBarrier barrier = new CyclicBarrier(3); barrier.await();

// ========== SEMAPHORE ==========
Semaphore sem = new Semaphore(3); sem.acquire(); sem.release();

// ========== BLOCKINGQUEUE ==========
BlockingQueue<String> q = new LinkedBlockingQueue<>(); q.put("item"); q.take();

// ========== COMPLETABLEFUTURE ==========
CompletableFuture.supplyAsync(() -> "Hello")
    .thenApply(s -> s + " World")
    .thenAccept(System.out::println);

// ========== THREAD SAFE COLLECTIONS ==========
ConcurrentHashMap<String, String> map = new ConcurrentHashMap<>();
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();

// ========== VOLATILE ==========
private volatile boolean flag;

// ========== FORK/JOIN ==========
ForkJoinPool pool = new ForkJoinPool();
pool.invoke(new RecursiveTask<Integer>() { protected Integer compute() { return 0; }});
```

---

## **📝 KEY TAKEAWAYS**

1. **Thread creation** - Thread class vs Runnable (prefer Runnable)
2. **Synchronization** - synchronized, locks, atomic variables
3. **Communication** - wait/notify, blocking queues
4. **Thread pools** - ExecutorService manages threads
5. **Concurrent utilities** - CountDownLatch, CyclicBarrier, Semaphore
6. **Concurrent collections** - For thread-safe data structures
7. **Futures** - Get results from async tasks
8. **CompletableFuture** - Functional composition of async tasks
9. **Fork/Join** - Parallel processing framework
10. **Thread safety** - Immutable, stateless, synchronized

---

_Good luck with your interview! 🎉_
