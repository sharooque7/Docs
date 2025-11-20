
# Thread Pools in Java

## Overview
Thread pools are used to efficiently execute multiple tasks concurrently by reusing a fixed number of threads. This approach helps control resource usage since each thread consumes OS resources.

## Key Concepts

### Thread Pool Components
1. **Pre-created Threads**: Fixed number of threads created upfront
2. **Task Queue**: Blocking queue that holds tasks to be executed
   - When a thread is available, it takes a task from the queue
   - If queue is empty, threads wait until tasks are available

### Benefits
- Controls number of active threads
- Efficient resource utilization
- Automatic load balancing between threads

## Implementation Example

### Using the ThreadPool
```java
ThreadPool threadPool = new ThreadPool(3, 10); // 3 threads, max 10 tasks

for(int i=0; i<10; i++) {
    int taskNumber = i;
    threadPool.execute(() -> {
        System.out.println(Thread.currentThread().getName() + " executing task " + taskNumber);
    });
}

threadPool.waitUntilAllTasksFinished();
threadPool.stop();
```

### ThreadPool Class Implementation
```java
public class ThreadPool {
    private BlockingQueue<Runnable> taskQueue;
    private List<PoolThreadRunnable> runnables;
    private boolean isStopped = false;

    public ThreadPool(int numThreads, int maxTasks) {
        taskQueue = new ArrayBlockingQueue<>(maxTasks);
        runnables = new ArrayList<>();
        
        for(int i=0; i<numThreads; i++) {
            PoolThreadRunnable runnable = new PoolThreadRunnable(taskQueue);
            runnables.add(runnable);
            new Thread(runnable).start();
        }
    }

    public synchronized void execute(Runnable task) {
        if(isStopped) throw new IllegalStateException("ThreadPool is stopped");
        taskQueue.offer(task);
    }

    public synchronized void stop() {
        isStopped = true;
        for(PoolThreadRunnable runnable : runnables) {
            runnable.doStop();
        }
    }

    public void waitUntilAllTasksFinished() {
        while(taskQueue.size() > 0) {
            try { Thread.sleep(1); } 
            catch (InterruptedException e) {}
        }
    }
}
```

### PoolThreadRunnable Implementation
```java
public class PoolThreadRunnable implements Runnable {
    private Thread thread;
    private BlockingQueue<Runnable> taskQueue;
    private boolean isStopped = false;

    public PoolThreadRunnable(BlockingQueue<Runnable> queue) {
        taskQueue = queue;
    }

    public void run() {
        this.thread = Thread.currentThread();
        while(!isStopped()) {
            try {
                Runnable task = taskQueue.take();
                task.run();
            } catch(InterruptedException e) {}
        }
    }

    public synchronized void doStop() {
        isStopped = true;
        thread.interrupt(); // Break thread out of dequeue() call
    }

    public synchronized boolean isStopped() {
        return isStopped;
    }
}
```

## Key Implementation Details

1. **Task Queue**: Uses `ArrayBlockingQueue` for thread-safe operations
2. **Thread Management**:
   - Threads continuously take tasks from queue
   - Block when queue is empty
3. **Shutdown Process**:
   - Sets stop flag
   - Interrupts threads to wake them from blocking state
   - Uses synchronization for thread-safe flag access

## Important Notes

- Java provides built-in thread pools (`ExecutorService`) - consider using these in production
- Implementing your own helps understand concurrency concepts
- Tasks should be thread-independent (order/thread shouldn't matter)
- Actual execution order may vary between runs


## Summary

This summary captures the key points about thread pool implementation while maintaining the technical details from the original content. The Markdown format makes it easy to read and reference.