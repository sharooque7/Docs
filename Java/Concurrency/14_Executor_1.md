
# Java ExecutorService - Thread Pool Implementation

## Overview
The `ExecutorService` interface provides a thread pool mechanism for concurrent task execution in Java. It manages a pool of threads and a task queue, handling thread creation and task scheduling automatically.

## Key Concepts

### Creating an ExecutorService
```java
// Fixed thread pool (most common)
ExecutorService executor = Executors.newFixedThreadPool(10);

// Custom ThreadPoolExecutor
ExecutorService executor = new ThreadPoolExecutor(
    10,  // core pool size
    20,  // max pool size
    3000, // keep-alive time (ms)
    TimeUnit.MILLISECONDS,
    new ArrayBlockingQueue<>(100)
);
```

### Task Submission Methods

#### 1. execute(Runnable)
```java
executor.execute(() -> {
    System.out.println("Task executed by: " + Thread.currentThread().getName());
});
```
- Basic submission for fire-and-forget tasks
- No return value or status tracking

#### 2. submit(Runnable)
```java
Future<?> future = executor.submit(() -> {
    // Task logic
});
// Can check completion status
boolean isDone = future.isDone(); 
// Blocks until task completes (returns null for Runnable)
future.get(); 
```

#### 3. submit(Callable)
```java
Future<String> future = executor.submit(() -> {
    return "Result from " + Thread.currentThread().getName();
});
String result = future.get(); // Blocks and returns the result
```

#### 4. invokeAny(Collection<Callable>)
```java
List<Callable<String>> tasks = Arrays.asList(
    () -> "Task 1 result",
    () -> "Task 2 result"
);
String firstResult = executor.invokeAny(tasks); // Returns first completed result
```
- Executes all tasks but returns only the first result
- Cancels remaining tasks

#### 5. invokeAll(Collection<Callable>)
```java
List<Future<String>> futures = executor.invokeAll(tasks);
for (Future<String> future : futures) {
    String result = future.get(); // Get each result
}
```
- Executes all tasks and returns all results
- Blocks until all tasks complete

## ThreadPoolExecutor Configuration

| Parameter        | Description |
|-----------------|------------|
| corePoolSize    | Minimum number of threads to keep alive |
| maximumPoolSize | Maximum number of threads to create |
| keepAliveTime   | Time to wait before terminating idle threads beyond core size |
| workQueue       | Queue to hold tasks before execution |
| threadFactory   | Factory for creating new threads |
| handler         | Policy for rejected tasks |

## Best Practices

1. **Shutdown Properly**:
```java
executor.shutdown(); // Graceful shutdown
executor.shutdownNow(); // Immediate shutdown
```

2. **Handle Rejected Tasks**:
   - Implement `RejectedExecutionHandler` for full queue scenarios

3. **Thread Pool Sizing**:
   - CPU-bound tasks: `N_threads = N_cores + 1`
   - I/O-bound tasks: Larger pool size (depends on wait/compute ratio)

4. **Task Design**:
   - Prefer `Callable` over `Runnable` when results are needed
   - Make tasks independent of each other

## Example: Complete Usage

```java
ExecutorService executor = Executors.newFixedThreadPool(3);

// Submit tasks
List<Future<String>> futures = new ArrayList<>();
for (int i = 0; i < 5; i++) {
    final int taskId = i;
    futures.add(executor.submit(() -> {
        return "Task " + taskId + " executed by " + Thread.currentThread().getName();
    }));
}

// Process results
for (Future<String> future : futures) {
    try {
        System.out.println(future.get());
    } catch (Exception e) {
        e.printStackTrace();
    }
}

// Shutdown
executor.shutdown();
```

## When to Use Which Method

| Use Case | Recommended Method |
|----------|--------------------|
| Fire-and-forget | execute() |
| Need task status | submit(Runnable) |
| Need task result | submit(Callable) |
| Fastest result wins | invokeAny() |
| All results needed | invokeAll() |

This Markdown summary covers the essential aspects of Java's ExecutorService, including creation, task submission methods, configuration options, best practices, and example usage patterns.