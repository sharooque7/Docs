# Java BlockingQueue Interface

## Introduction
- Represents a queue where elements are:
  - Enqueued at the end
  - Dequeued from the beginning
- Key difference from standard Queue: threads can block during insertion/removal

## BlockingQueue Implementations
Common implementations in `java.util.concurrent` package:
- `ArrayBlockingQueue`
- `LinkedBlockingQueue`
- Several others available

## Basic Usage Example
```java
BlockingQueue<String> queue = new ArrayBlockingQueue<>(2);

queue.put("1");  // Enqueue
queue.put("2");

System.out.println(queue.take());  // Dequeue and print
System.out.println(queue.take());
```

## Producer-Consumer Pattern
Common use case for BlockingQueue:

### Producer
```java
class Producer implements Runnable {
    private BlockingQueue<String> queue;
    
    public Producer(BlockingQueue<String> queue) {
        this.queue = queue;
    }
    
    public void run() {
        while(true) {
            String time = "" + System.currentTimeMillis();
            queue.put(time);
            Thread.sleep(1000);
        }
    }
}
```

### Consumer
```java
class Consumer implements Runnable {
    private BlockingQueue<String> queue;
    
    public Consumer(BlockingQueue<String> queue) {
        this.queue = queue;
    }
    
    public void run() {
        while(true) {
            String element = queue.take();
            System.out.println("Consumed: " + element);
        }
    }
}
```

## Enqueue Methods

| Method | Behavior | Throws |
|--------|----------|--------|
| `put(E e)` | Blocks until space available | InterruptedException |
| `add(E e)` | Throws exception if no space | IllegalStateException |
| `offer(E e)` | Returns true/false if inserted | - |
| `offer(E e, long timeout, TimeUnit unit)` | Waits up to timeout, then returns true/false | InterruptedException |

## Dequeue Methods

| Method | Behavior | Throws |
|--------|----------|--------|
| `take()` | Blocks until element available | InterruptedException |
| `poll()` | Returns element or null | - |
| `poll(long timeout, TimeUnit unit)` | Waits up to timeout, then returns element or null | InterruptedException |
| `remove(Object o)` | Removes specified element if present | - |

## Other Useful Methods

### Bulk Operations
- `drainTo(Collection<? super E> c)` - Removes all available elements
- `drainTo(Collection<? super E> c, int maxElements)` - Removes up to max elements

### Inspection Methods
- `peek()` - Returns head element or null
- `element()` - Returns head element or throws NoSuchElementException
- `size()` - Returns current element count
- `remainingCapacity()` - Returns available capacity
- `contains(Object o)` - Checks if element exists in queue

## Key Characteristics
- Thread-safe for concurrent access
- Capacity can be bounded or unbounded
- Elements are ordered FIFO (first-in-first-out)
- Null elements are not permitted

Note: Check video description for code samples and related tutorials.