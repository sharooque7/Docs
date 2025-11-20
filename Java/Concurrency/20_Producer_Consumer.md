# Producer-Consumer Pattern in Java

## Overview
The producer-consumer pattern is a workload distribution pattern that:
- Decouples work detection from work execution
- Uses a queue to balance workload between threads
- Enables efficient utilization of system resources

## Key Components
1. **Producer Thread(s)**: Detect work and create task objects
2. **Task Queue**: Holds tasks to be processed (typically a `BlockingQueue`)
3. **Consumer Thread(s)**: Take tasks from queue and execute them

## Benefits
- **Load Balancing**: Distributes work evenly across available CPUs
- **Responsiveness**: Keeps foreground threads (like UI) free
- **Resource Management**: Avoids overloading system with too many threads
- **Backpressure**: Queue size naturally limits work in progress

## Common Use Cases

### 1. Reducing Foreground Thread Latency
#### GUI Applications
- UI thread remains responsive by offloading work to background threads
- Example: File processing in desktop apps

```java
// UI thread (producer)
button.setOnAction(event -> {
    File file = fileChooser.showOpenDialog();
    executor.submit(() -> processFile(file));  // Offload to background
});
```

#### Servers
- Connection-accepting thread remains responsive
- Processing handled by worker threads

### 2. Load Balancing
- Match number of consumer threads to available CPUs
- Example: Image processing pipeline

### 3. Backpressure Management
- Queue size limits prevent system overload
- Producers slow down when queue is full

## Java Implementation Example

### Producer
```java
class Producer implements Runnable {
    private BlockingQueue<String> queue;
    
    public Producer(BlockingQueue<String> queue) {
        this.queue = queue;
    }
    
    public void run() {
        try {
            while(true) {
                String task = "" + System.currentTimeMillis();
                queue.put(task);  // Blocks if queue is full
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
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
        try {
            while(true) {
                String task = queue.take();  // Blocks until task available
                System.out.println(Thread.currentThread().getName() 
                    + " consumed: " + task);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```

### Main Application
```java
public static void main(String[] args) {
    BlockingQueue<String> queue = new ArrayBlockingQueue<>(10);
    
    // Create producer and consumers
    Producer producer = new Producer(queue);
    Consumer consumer1 = new Consumer(queue);
    Consumer consumer2 = new Consumer(queue);
    
    // Start threads
    new Thread(producer).start();
    new Thread(consumer1, "Consumer-1").start();
    new Thread(consumer2, "Consumer-2").start();
}
```

## Best Practices
1. **Thread Pool**: Consider using `ExecutorService` instead of raw threads
2. **Queue Size**: Choose appropriate queue size based on memory constraints
3. **Error Handling**: Properly handle interrupts and exceptions
4. **Poison Pills**: Use special task objects to signal shutdown
5. **Monitoring**: Track queue size and processing times

## Advanced Variations
- **Priority Queues**: `PriorityBlockingQueue` for task prioritization
- **Work Stealing**: `ForkJoinPool` for dynamic workload balancing
- **Multiple Queues**: Separate queues for different task types

Note: Check video description for code samples and related tutorials on Java concurrency.