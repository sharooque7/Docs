# Java Happens-Before Guarantee

## Introduction

The Java Happens-Before Guarantee is a set of restrictions on instruction reordering designed to ensure that the Java visibility guarantees aren't broken during execution. This documentation assumes basic familiarity with the Java Memory Model, including thread stacks, heap, and how Java threads use these structures.

## Background: Instruction Reordering

### Parallel Execution by CPUs

Modern CPUs can execute multiple instructions in parallel when these instructions are independent of each other. For example:

- Instructions that are dependent (e.g., where one instruction uses the result of another) cannot be executed in parallel.
- Independent instructions can be executed simultaneously.

```
// Not independent (cannot execute in parallel)
a = b + c
d = a + e  // Uses result of first instruction

// Not independent (cannot execute in parallel)
f = g + h
i = f - j  // Uses result of first instruction

// Independent (can execute in parallel)
a = b + c
f = g + h  // Doesn't depend on first instruction
```

### Look-Ahead Execution

To increase parallelism, CPUs may look ahead at future instructions to identify which can be executed in parallel with the current instruction. This means that even though instructions are listed in a specific order in the program, they may be executed out of order by the CPU.

### Compiler Reordering

To further optimize execution, both the Java compiler and the Java Virtual Machine (JVM) may reorder instructions at compile time:
- When Java source code is compiled into bytecode
- When bytecode is compiled into assembly language by the JVM's JIT compiler

For example, the compiler might detect that certain instructions are independent and reorder them to make parallel execution easier for the CPU.

## The Problem with Instruction Reordering in Multi-Threaded Applications

Instruction reordering can affect the correctness of multi-threaded applications where threads communicate via shared objects. 

### Example Scenario

Consider an application with two threads running on separate CPUs:
- Thread 1 produces frames to be drawn on the screen
- Thread 2 consumes these frames and draws them

The threads communicate through a shared `FrameExchanger` class:

```java
class FrameExchanger {
    private Frame frame;
    private long frameStoredCount = 0;
    private boolean hasNewFrame = false;
    
    public void storeFrame(Frame frame) {
        this.frame = frame;
        this.frameStoredCount++;
        this.hasNewFrame = true;
    }
    
    public Frame takeFrame() {
        while(!this.hasNewFrame) {
            // Wait for new frame
        }
        Frame frame = this.frame;
        this.framesTakenCount++;
        this.hasNewFrame = false;
        return frame;
    }
}
```

### Visibility Issues

Since the fields aren't declared `volatile` and the methods don't contain `synchronized` blocks, there's no guarantee that changes made to these fields by one thread will be visible to the other thread.

For visibility between threads:
1. The thread making changes must flush updates to main memory
2. The reading thread must read values from main memory (not just local copies)

## Solving with Volatile Variables

### The Volatile Visibility Guarantee

Declaring fields as `volatile` helps solve the visibility problem:
- Every write to a volatile field is flushed directly to main memory
- Every read of a volatile field reads directly from main memory

```java
class FrameExchanger {
    private Frame frame;
    private long frameStoredCount = 0;
    private volatile boolean hasNewFrame = false;
    
    // Methods remain the same
}
```

Not all fields need to be declared volatile. The Java volatile visibility guarantee states:
- When writing to a volatile variable, all variables visible to the writing thread are also flushed to main memory
- When reading a volatile variable, all variables visible to the reading thread are refreshed from main memory

## How Instruction Reordering Can Break Volatile Visibility

In the example, if the CPU reorders instructions in `storeFrame()`:

```java
// Original order
this.frame = frame;
this.frameStoredCount++;
this.hasNewFrame = true;  // volatile write

// Potentially reordered by CPU
this.hasNewFrame = true;  // volatile write happens first
this.frame = frame;
this.frameStoredCount++;
```

This reordering breaks the visibility guarantee because:
- The write to the volatile variable (`hasNewFrame`) happens first
- This flushes whatever values are currently in the other fields to main memory
- The subsequent writes to non-volatile fields are not guaranteed to be written to main memory
- Thread 2 might exit the while loop due to seeing `hasNewFrame = true` but could read an outdated frame

## The Volatile Happens-Before Guarantee

To fix these problems, Java introduced the Volatile Happens-Before Guarantee:

### Write Guarantee
Any write to a field that happens before a write to a volatile variable will remain before the write to that volatile variable. In our example:
- The writes to `this.frame` and `this.frameStoredCount` cannot be reordered to happen after the write to `hasNewFrame`
- They can still be reordered between themselves

### Read Guarantee
Any read of a volatile variable located before reads of other variables is guaranteed to happen before those subsequent reads. In our example:
- The read of `hasNewFrame` in the while loop cannot be reordered to happen after the read of `this.frame`

## Synchronized Visibility Guarantee

Similar challenges exist with synchronized blocks. Consider another example:

```java
class ValueExchanger {
    private int valA, valB, valC;
    
    public synchronized void set(Values v) {
        this.valA = v.getA();
        this.valB = v.getB();
        this.valC = v.getC();
    }
    
    public synchronized void get(Values v) {
        v.setA(this.valA);
        v.setB(this.valB);
        v.setC(this.valC);
    }
}
```

The Java synchronized blocks visibility guarantee states:
- When a thread enters a synchronized block, it refreshes all variables visible to the thread from main memory
- When a thread exits a synchronized block, all changed variables visible to the thread are flushed to main memory

## How Instruction Reordering Can Break Synchronized Visibility

If instructions are reordered so that some operations happen outside the synchronized block:

```java
// Reordered set() method
public void set(Values v) {
    synchronized(this) {
        this.valA = v.getA();
        this.valB = v.getB();
    }
    this.valC = v.getC();  // Moved outside synchronized block
}

// Reordered get() method
public void get(Values v) {
    v.setA(this.valA);  // Moved outside synchronized block
    synchronized(this) {
        v.setB(this.valB);
        v.setC(this.valC);
    }
}
```

This breaks visibility guarantees because:
- When Thread 1 exits the synchronized block, only `valA` and `valB` are guaranteed to be flushed to main memory
- When Thread 2 enters its synchronized block, it may not see the updated value of `valC`
- The value read for `valA` by Thread 2 may be outdated since it's read before entering the synchronized block

## The Synchronized Happens-Before Guarantee

To address these issues, Java also provides happens-before guarantees for synchronized blocks:

### Write Guarantee
Any write to a variable that happens before the exit of a synchronized block is guaranteed to remain before the exit of that synchronized block. This means:
- Writes inside the synchronized block cannot be reordered to happen after exiting the block
- Writes before the synchronized block cannot be reordered to happen after exiting the block

### Read Guarantee
Reads that happen after entering a synchronized block cannot be reordered to happen before entering that block. This means:
- Reads inside the synchronized block cannot be reordered to happen before entering the block
- Reads after the synchronized block cannot be reordered to happen before entering the block

## Summary

The Java Happens-Before Guarantee is a set of restrictions on instruction reordering that ensures Java visibility guarantees are maintained. These guarantees are essential for correct thread communication in concurrent Java applications.

The key components are:
1. **Volatile Happens-Before**: Ensures writes to volatile variables and preceding writes remain ordered, and reads of volatile variables and subsequent reads remain ordered
2. **Synchronized Happens-Before**: Ensures operations inside synchronized blocks cannot be reordered to happen outside those blocks

These guarantees work together to ensure that when threads communicate through shared memory, they see a consistent view of that memory despite the optimizations performed by compilers and CPUs.