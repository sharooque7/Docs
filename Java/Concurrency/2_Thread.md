# Java Threads

## What is a Java Thread?
A Java thread is like a virtual CPU that can execute code inside a Java application. When the Java Virtual Machine (JVM) starts an application, it creates a main thread to execute the `main` method.

## Creating and Starting a Java Thread
Inside the `main` method, a new thread can be created and started using the `Thread` class. This allows the new thread to run in parallel with the main thread.

```java
class MyThread extends Thread {
    public void run() {
        System.out.println("My thread is running");
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread thread = new MyThread();
        thread.start();
    }
}
```

## Four Ways to Specify Code Execution in a Thread
There are four ways to specify what code a Java thread should execute:

### 1. Extend the `Thread` Class
Create a class that extends the `Thread` class and override the `run` method.

```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Thread is running");
    }
}
```

### 2. Implement the `Runnable` Interface
Create a class that implements the `Runnable` interface and pass an instance of this class to a `Thread` object.

```java
class MyRunnable implements Runnable {
    public void run() {
        System.out.println("Runnable is running");
    }
}

public class Main {
    public static void main(String[] args) {
        Thread thread = new Thread(new MyRunnable());
        thread.start();
    }
}
```

### 3. Use an Anonymous Runnable Class
Use an anonymous class to define the `Runnable` implementation directly.

```java
Thread thread = new Thread(new Runnable() {
    public void run() {
        System.out.println("Anonymous Runnable is running");
    }
});
thread.start();
```

### 4. Use a Lambda Expression
Use a lambda expression to define the `Runnable` interface.

```java
Thread thread = new Thread(() -> {
    System.out.println("Lambda Runnable is running");
});
thread.start();
```

## Obtaining Reference to the Currently Executing Thread
Use `Thread.currentThread()` to get a reference to the currently executing thread.

```java
Thread currentThread = Thread.currentThread();
System.out.println("Current Thread: " + currentThread.getName());
```

## Getting and Setting the Thread Name
Threads have default names, but custom names can be set.

```java
Thread thread = new Thread(() -> {
    System.out.println("Thread running: " + Thread.currentThread().getName());
}, "MyCustomThread");
thread.start();
```

## Starting Multiple Threads
Multiple threads can be started and executed concurrently.

```java
Thread thread1 = new Thread(() -> System.out.println("Thread 1 running"), "Thread 1");
Thread thread2 = new Thread(() -> System.out.println("Thread 2 running"), "Thread 2");

thread1.start();
thread2.start();
```

## Pausing a Thread Using `Thread.sleep()`
A thread can be paused using `Thread.sleep(milliseconds)`.

```java
Thread thread = new Thread(() -> {
    try {
        System.out.println("Thread sleeping for 2 seconds...");
        Thread.sleep(2000);
        System.out.println("Thread awake");
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
});
thread.start();


```
