# Process Pauses

Let’s consider another example of dangerous clock use in a distributed system. Say you have a database with a single leader per partition. Only the leader is allowed to accept writes. How does a node know that it is still leader (that it hasn’t been declared dead by the others), and that it may safely accept writes?

One option is for the leader to obtain a **lease** from the other nodes, which is similar to a lock with a timeout. Only one node can hold the lease at any one time—thus, when a node obtains a lease, it knows that it is the leader for some amount of time, until the lease expires. In order to remain leader, the node must periodically renew the lease before it expires. If the node fails, it stops renewing the lease, so another node can take over when it expires.

You can imagine the request-handling loop looking something like this:

```java
while (true) {
  request = getIncomingRequest();
  
  // Ensure that the lease always has at least 10 seconds remaining
  if (lease.expiryTimeMillis - System.currentTimeMillis() < 10000) {
    lease = lease.renew();
  }
  
  if (lease.isValid()) {
    process(request);
  }
}
```

## What’s Wrong with This Code?

1. **It relies on synchronized clocks**:  
   The expiry time on the lease is set by a different machine and is compared to the local system clock. If the clocks are out of sync, the logic may behave incorrectly.

2. **It assumes minimal delay between time check and request processing**:  
   Normally, the check and processing happen quickly. However, if there is an **unexpected pause** (e.g., 15 seconds), the lease could expire during that pause. The system might continue to process the request without knowing it’s no longer the leader.

## Is it Crazy to Assume a Thread Might Pause That Long?

Unfortunately, no. Several things can cause significant and unpredictable pauses:

- **Garbage Collection (GC)**:  
  Some GCs pause all threads (stop-the-world). Even "concurrent" GCs like CMS occasionally pause the world.

- **Virtual Machine Suspension**:  
  Virtual machines may be suspended for live migration or snapshots.

- **End-User Device Sleep**:  
  Laptops or mobile devices suspend execution when the lid is closed or the device sleeps.

- **OS Context Switches & Hypervisor Steal Time**:  
  Threads can be paused anytime due to load or resource contention.

- **Synchronous Disk I/O**:  
  Threads may pause waiting for slow I/O. This can be triggered even without explicit file access (e.g., Java classloader).

- **Paging and Swapping**:  
  Memory accesses may lead to page faults and disk swaps, especially if paging is enabled.

- **Manual Pause via Signals**:  
  A process can be paused using `SIGSTOP` (e.g., Ctrl+Z in terminal) and resumed with `SIGCONT`.

All of these can **pause a thread at any time**, and the thread won’t be aware of the pause duration until much later.

## Analogy: Multi-threaded Programming

In multi-threaded programming, timing can't be assumed. We use:

- Mutexes
- Semaphores
- Atomic counters
- Lock-free data structures
- Blocking queues

But in **distributed systems**, there's **no shared memory**, only unreliable messages across the network.

## Distributed Implication

A node can be paused **anytime**, and during the pause:

- The world moves on.
- The node might be declared dead.
- It might resume later and process a request it shouldn't.

---

# Response Time Guarantees

Many systems **cannot guarantee** that processes will respond in a bounded amount of time. But **some systems must**, such as:

- Aircraft control
- Rockets
- Robots
- Cars

These are **hard real-time systems**, where missing a deadline can cause critical failure.

### Is Real-Time Really Real?

In **embedded systems**, _real-time_ means strict timing guarantees. This differs from _real-time_ in web or stream processing, where timing is "soft".

> Example:  
> If your car detects a crash, the airbag release system must respond instantly. A GC pause in this system could be fatal.

### How to Provide Real-Time Guarantees?

You need support from all layers:

- **Real-Time Operating System (RTOS)**:  
  Allows CPU time allocation guarantees.
